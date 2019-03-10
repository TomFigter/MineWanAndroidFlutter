import 'dart:async';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter/common/GlobalConfig.dart';
import 'package:my_flutter/model/article_list/ArticleItemModel.dart';
import 'package:my_flutter/model/article_list/ArticleListModel.dart';
import 'package:my_flutter/pages/article_list/ArticleItemPage.dart';
import 'package:my_flutter/widget/EmptyHolder.dart';
import 'package:my_flutter/widget/QuickTopFloatBtn.dart';

typedef Future<Response> RequestData(int page);
typedef void ShowQuickTop(bool show);

class ArticleListPage extends StatefulWidget {
  final Widget header;
  final RequestData request;
  final String emptyMsg;
  final bool keepAlive;
  final ShowQuickTop showQuickTop;
  final bool selfControl;

  /**
   * 构造方法
   */
  ArticleListPage(
      {Key key,
      this.header,
      @required this.request,
      this.emptyMsg,
      this.selfControl = true,
      this.showQuickTop,
      this.keepAlive = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ArticleListPageState();
  }
}

class ArticleListPageState extends State<ArticleListPage>
    with AutomaticKeepAliveClientMixin {
  List<ArticleItemModel> _listData = List();
  List<int> _listDataId = List();
  GlobalKey<QuickTopFloatBtnState> _quickTopFloatBtnKey = new GlobalKey();
  int _listDataPage = -1;
  var _haveMoreData = true;
  double _screenHeight;
  ListView listView;
  ScrollController _controller;

  @override
  bool get wantKeepAlive => widget.keepAlive;

  @override
  void initState() {
    super.initState();
    _loadNextPage();
  }

  /**
   * 滑动效果
   */
  void handlerScroll(double offset, {ScrollController controller}) {
    ((null == controller) ? _controller : controller)?.animateTo(offset,
        duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    var itemCount = ((null == _listData) ? 0 : _listData.length) +
        (null == widget.header ? 0 : 1) +
        (_haveMoreData ? 1 : 0);
    //空视图
    if (itemCount <= 0) {
      return EmptyHolder(
        msg: (widget.emptyMsg == null)
            ? (_haveMoreData ? "Loading" : "not found")
            : widget.emptyMsg,
      );
    }
    //ListView组织视图
    listView = ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: itemCount,
        controller: getControllerForListView(),
        itemBuilder: (context, index) {
          if (index == 0 && null != widget.header) {
            return widget.header;
          } else if (index - (null == widget.header ? 0 : 1) >=
              _listData.length) {
            return _buildLoadMoreItem();
          } else {
            return _buildListViewItemLayout(
                context, index - (null == widget.header ? 0 : 1));
          }
        });
    /**
     * 下拉刷新图标（刷新动态图）
     */
    var notificationBody = NotificationListener<ScrollNotification>(
      onNotification: onScrollNotification,
      child: RefreshIndicator(
        backgroundColor: GlobalConfig.color_white_a80,
        child: listView,
        onRefresh: handleRefresh,  //刷新
        color: GlobalConfig.color_tags,
      ),
    );

    return (null == widget.showQuickTop)
        ? Scaffold(
            resizeToAvoidBottomPadding: false,
            body: notificationBody,
            floatingActionButton: QuickTopFloatBtn(
                key: _quickTopFloatBtnKey,
                onPressed: () {
                  handlerScroll(0.0);
                }),
          )
        : notificationBody;
  }

  /**
   * 滑动通知
   */
  bool onScrollNotification(ScrollNotification scrollNotification) {
    if (scrollNotification.metrics.pixels >=
        scrollNotification.metrics.maxScrollExtent) {
      _loadNextPage();
    }
    if (null == _screenHeight || _screenHeight <= 0) {
      _screenHeight = MediaQueryData.fromWindow(ui.window).size.height;
    }
    if (scrollNotification.metrics.axisDirection == AxisDirection.down &&
        _screenHeight >= 10 &&
        scrollNotification.metrics.pixels >= _screenHeight) {
      if (null != widget.showQuickTop) {
        widget.showQuickTop(true);
      } else {
        _quickTopFloatBtnKey.currentState.refreshVisible(true);
      }
    } else {
      if (null != widget.showQuickTop) {
        widget.showQuickTop(false);
      } else {
        _quickTopFloatBtnKey.currentState.refreshVisible(false);
      }
    }
    return false;
  }

  Widget _buildListViewItemLayout(BuildContext context, int index) {
    if (null == _listData ||
        _listData.length <= 0 ||
        index < 0 ||
        index >= _listData.length) {
      return Container();
    }
    return ArticleItemPage(_listData[index]);
  }

  /**
   * 加载更多Item
   */
  Widget _buildLoadMoreItem() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text("加载更多 ..."),
      ),
    );
  }

  /**
   * 数据异步刷新
   * async 异步
   * await 等待加载结果
   */
  Future<Null> handleRefresh() async {
    _listDataPage = -1;
    _listData.clear();
    _listDataId.clear();
    await _loadNextPage();
  }

  bool isLoading = false;

  /**
   * 异步加载下一页数据
   */
  Future<Null> _loadNextPage() async {
    if (isLoading || !this.mounted) {
      return null;
    }
    isLoading = true;
    _listDataPage++;
    var result = await _loadListData(_listDataPage);
    //至少加载8个,如果初始化加载不足,则加载下一页,如果使用递归的话需要考虑中止操作
    if (_listData.length < 8) {
      _listDataPage++;
      result = await _loadListData(_listDataPage);
    }
    if (this.mounted) setState(() {});
    isLoading = false;
    return result;
  }

  ScrollController getControllerForListView() {
    if (widget.selfControl) {
      if (null == _controller) _controller = ScrollController();
      return _controller;
    } else {
      return null;
    }
  }

  /**
   * 加载每个页面的链表数据
   */
  Future<Null> _loadListData(int page) {
    _haveMoreData = true;
    return widget.request(page).then((response) {
      var newList = ArticleListModel.fromJson(response.data).data.datas;
      var originListLength = _listData.length;
      if (null != newList && newList.length > 0) {
        //防止添加进重复数据
        //forEach() 顺序循环每个元素
        newList.forEach((item) {
          if (!_listDataId.contains(item.id)) {
            _listData.add(item);
            _listDataId.add(item.id);
          }
        });
      }
      _haveMoreData = originListLength != _listData.length;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _listData?.clear();
    _listDataId?.clear();
    super.dispose();
  }
}
