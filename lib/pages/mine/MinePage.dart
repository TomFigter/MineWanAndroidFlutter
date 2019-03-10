import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter/api/Api.dart';
import 'package:my_flutter/api/CommonService.dart';
import 'package:my_flutter/common/GlobalConfig.dart';
import 'package:my_flutter/common/Router.dart';
import 'package:my_flutter/common/User.dart';
import 'package:my_flutter/pages/article_list/ArticleListPage.dart';
import 'package:my_flutter/widget/EmptyHolder.dart';
import 'package:my_flutter/widget/QuickTopFloatBtn.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  double _screenWidth = MediaQueryData.fromWindow(ui.window).size.width;
  GlobalKey<QuickTopFloatBtnState> _quickTopFloatBtnKey = new GlobalKey();
  ArticleListPage _itemListPage;
  GlobalKey<ArticleListPageState> _itemListPageKey = new GlobalKey();
  ScrollController _controller;

  @override
  Widget build(BuildContext context) {
    _controller = FixedExtentScrollController();
    return Scaffold(
      body: NestedScrollView(
          controller: _controller,
          headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                pinned: true,
                expandedHeight: _screenWidth * 2 / 3,
                forceElevated: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    background: _buildHead(context),
                    title: Text(getUserName())),
              ),
            ];
          },
          body: User().isLogin()
              ? _buildMineBody()
              : EmptyHolder(
                  msg: "要查看收藏文章,请先登录!",
                )),
      floatingActionButton: QuickTopFloatBtn(
          key: _quickTopFloatBtnKey,
          onPressed: () {
            _itemListPageKey.currentState
                ?.handlerScroll(0.0, controller: _controller);
          }),
    );
  }

  Widget _buildHead(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: GlobalConfig.color_dark_gray),
      child: GestureDetector(
        onTap: () {
          if (User().isLogin()) {
            _showLoginOut(context);
          } else {
            _toLogin(context);
          }
        },
        child: _buildAvatar(),
      ),
    );
  }

  void _toLogin(BuildContext context) async {
    await Router().openLogin(context);
    User().refreshUserData(callback: () {
      setState(() {});
    });
  }

  /**
   * 图片
   */
  Widget _buildAvatar() {
    return Center(
      child: Container(
        width: _screenWidth/2,
        height: _screenWidth/2 ,
        decoration: BoxDecoration(
            color: Colors.amberAccent,
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                  "${Api.AVATAR_CODING}${getUserName().hashCode % 20}.png"),
              fit: BoxFit.contain,
            ),
            borderRadius: BorderRadius.all(new Radius.circular(500.0))),
      ),
    );
  }

  Future<Null> _showLoginOut(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return _buildLoginOut(context);
        });
  }

  Widget _buildLoginOut(BuildContext context) {
    return AlertDialog(
      content: Text("确定退出登录?"),
      actions: <Widget>[
        RaisedButton(
          elevation: 0.0,
          child: Text("OK"),
          color: Colors.transparent,
          textColor: GlobalConfig.color_tags,
          onPressed: () {
            User().logout();
            User().refreshUserData(callback: () {
              setState(() {});
            });
            Navigator.pop(context);
          },
        ),
        RaisedButton(
          elevation: 0.0,
          color: Colors.transparent,
          textColor: GlobalConfig.color_tags,
          child: Text("NO NO NO"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  String getUserName() {
    return (!User().isLogin()) ? "登录" : User().userName;
  }

  Widget _buildMineBody() {
    if (null == _itemListPage) {
      _itemListPage = ArticleListPage(
        key: _itemListPageKey,
        keepAlive: true,
        selfControl: false,
        showQuickTop: (show) {
          _quickTopFloatBtnKey.currentState.refreshVisible(show);
        },
        request: (page) {
          return CommonService().getCollectListData(page);
        },
      );
    }
    return _itemListPage;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
