import 'dart:ui' as ui;
import 'package:banner/banner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter/common/Router.dart';
import 'package:my_flutter/fonts/IconF.dart';
import 'package:my_flutter/model/homebanner/HomeBannerItemModel.dart';
import 'package:my_flutter/model/homebanner/HomeBannerModel.dart';
import 'package:my_flutter/api/CommonService.dart';
import 'package:my_flutter/common/GlobalConfig.dart';
import 'package:my_flutter/pages/Application.dart';
import 'package:my_flutter/pages/article_list/ArticleListPage.dart';
import 'package:my_flutter/pages/left_scaffold/LearnScaffold.dart';
import 'package:my_flutter/widget/EmptyHolder.dart';
import 'package:my_flutter/widget/QuickTopFloatBtn.dart';

/**
 * 进入主页面
 * 创建一个有状态的Widget
 */
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  double screentWidth = MediaQueryData.fromWindow(ui.window).size.width; //屏幕宽度
  GlobalKey<QuickTopFloatBtnState> _quickTopFloatBtnKey = new GlobalKey();
  GlobalKey<ArticleListPageState> _itemListPageKey = new GlobalKey();
  GlobalKey<ApplicationPageState> _applicationPageState = new GlobalKey();
  List<HomeBannerItemModel> _bannerData;
  ScrollController _controller;
  bool _isOldQuickTop = false;
  bool _isQuickTop = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadBannerData();
  }

  @override
  Widget build(BuildContext context) {
    _controller = FixedExtentScrollController();
    return Scaffold(
//      drawer: new Drawer(
//        child: LearnScaffold.homeDrawer(),
//        elevation: 10.0,
//        semanticLabel: "提示",
//      ),
      primary: true,
      body: NestedScrollView(
        controller: _controller,
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            _buildSliverAppBanner(),
          ];
        },
        body: ArticleListPage(
          keepAlive: true,
          selfControl: false,
          request: (page) {
            return CommonService().getArticleListData(page);
          },
          showQuickTop: (show) {
            //滑动事件监听
            _quickTopFloatBtnKey.currentState.refreshVisible(show);
            //获取滑动的之前的位置
            if (_controller?.position.extentBefore > screentWidth * 500 / 945) {
              _isQuickTop = true;
            } else {
              _isQuickTop = false;
            }
            if (_isOldQuickTop != _isQuickTop) setState(() {});
            _isOldQuickTop = _isQuickTop;
          },
        ),
      ),
      floatingActionButton: QuickTopFloatBtn(
          //滑动视图关联
          key: _quickTopFloatBtnKey,
          onPressed: () {
            _itemListPageKey.currentState
                ?.handlerScroll(0.0, controller: _controller);
          }),
    );
  }

  /**
   * 弹性APP Bar
   */
  Widget _buildSliverAppBanner() {
    if (null == _bannerData || _bannerData.length <= 0) {
      return Center(
        child: Text("Loading List..."),
      );
    } else {
      return SliverAppBar(
        backgroundColor:
            _isQuickTop ? GlobalConfig.color_tags : Colors.white,
        expandedHeight: screentWidth * 500 / 830,
        pinned: true,
        forceElevated: true,
        actions: <Widget>[organizationAppBar()],
        flexibleSpace: _isQuickTop ? showTopTitle() : hintTopTitle(),
      );
    }
  }

  Widget organizationAppBar() {
    return _isQuickTop
        ? IconButton(
            icon: Icon(IconF.search),
            onPressed: () {
              Router().openSearchPage(context); //页面跳转
            },
          )
        : EmptyHolder(msg: "");
  }

  /**
   * 显示头部的Tab Title
   */
  Widget showTopTitle() {
    return FlexibleSpaceBar(
      centerTitle: true,
      background: _buildHead(context),
      title: Text(GlobalConfig.homeTab),
    );
  }

  /**
   * 隐藏头部的Tab Title
   */
  Widget hintTopTitle() {
    return FlexibleSpaceBar(
      centerTitle: true,
      background: _buildHead(context),
    );
  }

  Widget _buildHead(BuildContext context) {
    double screentWidth =
        MediaQueryData.fromWindow(ui.window).size.width; //屏幕宽度
    return Container(
      //页面TOP的滑动图片
      height: screentWidth* 500 / 945,
      width: screentWidth,
      child: GestureDetector(
        child: Card(
          elevation:90.0,
          //Card的阴影
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(1.0)), //Item的圆角卡
          ),
          color: Colors.white,
//          margin: EdgeInsets.only(top: 20.0),
          child: BannerView(
            data: _bannerData,
            delayTime: 10,
            onBannerClickListener: (int index, dynamic itemData) {
              HomeBannerItemModel itemModel = itemData;
              Router().openWebPage(context, itemModel.url, itemModel.title);
            },
            buildShowView: (index, data) {
              return CachedNetworkImage(
                fadeInDuration: Duration(milliseconds: 0),
                fadeOutDuration: Duration(milliseconds: 0),
                imageUrl: (data as HomeBannerItemModel).imagePath,
              );
            },
          ),
        ),
      ),
    );
  }

  /**
   * 主页加载数据操作
   */
  void _loadBannerData() {
    CommonService().getBanner((HomeBannerModel _bean) {
      if (_bean.data.length > 0) {
        setState(() {
          _bannerData = _bean.data;
        });
      }
    });
  }
}
