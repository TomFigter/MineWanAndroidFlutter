import 'package:flutter/material.dart';
import 'package:my_flutter/api/Api.dart';
import 'package:my_flutter/api/CommonService.dart';
import 'package:my_flutter/common/GlobalConfig.dart';
import 'package:my_flutter/fonts/IconF.dart';
import 'package:my_flutter/model/wechat/WeChatItemModel.dart';
import 'package:my_flutter/model/wechat/WeChatModel.dart';
import 'package:my_flutter/pages/article_list/ArticleListPage.dart';
import 'package:my_flutter/widget/ClearableInputField.dart';
import 'package:my_flutter/widget/EmptyHolder.dart';

class MineWeChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MineWeChatPageState();
  }
}

class _MineWeChatPageState extends State<MineWeChatPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  Map<int, MapEntry<ArticleListPage, GlobalKey<ArticleListPageState>>>
      _itemListPageMap = Map();
  List<WeChatItemModel> _list = List();
  var _maxCachePageNums = 5;
  var _cachePageNum = 0;
  TabController _tabController;
  String _searchKey = "";
  bool _isSearching = false;
  int _currentItemIndex = 0;
  var _controller = TextEditingController();

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadWeChatNames();
  }

  void _loadWeChatNames() async {
    CommonService().getWechatNames((WeChatModel model) {
      if (model.data.length > 0) {
        setState(() {
          _updateState(model.data);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: _isSearching ? _buildSearchingAppbar() : _buildNormalAppbar(),
      body: _buildBody(),
    );
  }

  /**
   *关闭搜索窗口
   */
  AppBar _buildNormalAppbar() {
    return AppBar(
      title: Text(GlobalConfig.weChatTab),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(IconF.search),
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        )
      ],
      bottom: _buildSubTitle(),
    );
  }

  AppBar _buildSearchingAppbar() {
    var originTheme = Theme.of(context);
    return AppBar(
      leading: IconButton(
          icon: Icon(IconF.back),
          onPressed: () {
            handleRefreshSearchKey(key: "");
            setState(() {
              _isSearching = false;
            });
          }),
      centerTitle: true,
      title: Theme(
          data: originTheme.copyWith(
              hintColor: GlobalConfig.color_white_a80,
              textTheme: TextTheme(subhead: TextStyle(color: Colors.white))),
          child: ClearableInputField(
            hintTxt: "搜索公众号历史文章",
            controller: _controller,
            autoFocus: true,
            border: InputBorder.none,
            onchange: (str) {
              handleRefreshSearchKey(key: str);
            },
          )),
      bottom: _buildSubTitle(),
    );
  }

  TabBar _buildSubTitle() {
    return _list.length <= 0
        ? null
        : TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            isScrollable: true,
            unselectedLabelColor: GlobalConfig.color_white_a80,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.only(bottom: 2.0, top: 100.0),
            indicatorWeight: 1.0,
            indicatorColor: Colors.white,
            tabs: _buildTabs(),
          );
  }

  List<Widget> _buildTabs() {
    return _list?.map((WeChatItemModel _bean) {
      return Tab(
        text: _bean?.name,
      );
    })?.toList();
  }

  Widget _buildBody() {
    return (null == _tabController || _list.length <= 0)
        ? EmptyHolder()
        : new TabBarView(
            controller: _tabController,
            children: _buildPages(),
          );
  }

  bool _keepAlive() {
    if (_cachePageNum <= _maxCachePageNums) {
      _cachePageNum++;
      return true;
    }
    return false;
  }

  List<Widget> _buildPages() {
    return _list?.map((_bean) {
      if (!_itemListPageMap.containsKey(_bean.id)) {
        var key = GlobalKey<ArticleListPageState>();
        _itemListPageMap[_bean.id] = MapEntry(
            ArticleListPage(
                key: key,
                keepAlive: _keepAlive(),
                emptyMsg: "没搜到数据!",
                request: (page) {
                  return CommonService().getWeChatListData(
                      "${Api.MP_WECHAT_LIST}${_bean.id}/$page/json?k=$_searchKey");
                }),
            key);
      }
      return _itemListPageMap[_bean.id].key;
    })?.toList();
  }

  void _updateState(List<WeChatItemModel> data) {
    data.forEach((_weChatItemModel) {
      _list.add(_weChatItemModel);
    });
    _tabController = new TabController(vsync: this, length: _list.length);
    _tabController.addListener(() {
      _currentItemIndex = _tabController.index;
      handleRefreshSearchKey();
    });
  }

  void handleRefreshSearchKey({String key}) {
    if (null != key) _searchKey = key;
    _itemListPageMap[_list[_currentItemIndex].id]
        ?.value
        ?.currentState
        ?.handleRefresh();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
