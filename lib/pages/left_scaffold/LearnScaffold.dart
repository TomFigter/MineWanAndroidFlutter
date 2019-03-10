import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter/api/Api.dart';
import 'package:my_flutter/common/User.dart';
import 'package:my_flutter/pages/mine/MinePage.dart';
import 'package:my_flutter/resources/res_index.dart';
import 'package:my_flutter/utils/navigator_util.dart';
import 'package:flustars/src/screen_util.dart';

class LearnScaffold extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MainLeftPageState();
  }
}

class PageInfo {
  PageInfo(this.titleId, this.iconData, this.page, [this.withScaffold = true]);

  String titleId;
  IconData iconData;
  Widget page;
  bool withScaffold;
}

class _MainLeftPageState extends State<LearnScaffold> {
  List<PageInfo> _pageInfo = new List();

  @override
  void initState() {
    super.initState();
    _pageInfo.add(PageInfo("收藏", Icons.collections, MinePage()));
    _pageInfo.add(PageInfo("设置", Icons.settings, null));
    _pageInfo.add(PageInfo("关于", Icons.info, null));
    _pageInfo.add(PageInfo("分享", Icons.share, null));
    _pageInfo.add(PageInfo("注销", Icons.power_settings_new, null));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.only(
                top: ScreenUtil.getInstance().statusBarHeight, left: 10.0),
            child: new SizedBox(
              height: 120.0,
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        width: 64.0,
                        height: 64.0,
                        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                "${Api.AVATAR_CODING}${getUserName().hashCode % 20}.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      new Text(
                        getUserName(),
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                      ),
                      new Text(
                        "个人简介",
                        style:
                            new TextStyle(color: Colors.white, fontSize: 10.0),
                      ),
                    ],
                  ),
                  new Align(
                    alignment: Alignment.topRight,
                    child: new IconButton(
                        iconSize: 18.0,
                        icon: new Icon(Icons.edit, color: Colors.white),
                        onPressed: () {}),
                  )
                ],
              ),
            ),
          ),
          new Container(
            height: 50.0,
            child: new Material(
              color: Colors.grey[200],
              child: new InkWell(
                onTap: () {
                  NavigatorUtil.pushPage(context, null,
                      pageName: "Flutter Demos");
                },
                child: new Center(
                  child: new Text(
                    "Flutter Demos",
                    style: new TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 16.0),
                  ),
                ),
              ),
            ),
          ),
          new Expanded(
            child: new ListView.builder(
                padding: const EdgeInsets.all(0.0),
                itemCount: _pageInfo.length,
                itemBuilder: (BuildContext context, int index) {
                  PageInfo pageInfo = _pageInfo[index];
                  return new ListTile(
                    leading: new Icon(pageInfo.iconData),
                    title:
                        new Text(pageInfo.titleId),
                    onTap: () {
                      if (pageInfo.titleId != Ids.titleSignOut && pageInfo.page!=null) {
                        NavigatorUtil.pushPage(context, pageInfo.page,
                            pageName: pageInfo.titleId);
                      } else {}
                    },
                  );
                }),
            flex: 1,
          )
        ],
      ),
    );
  }
  String getUserName() {
    return (!User().isLogin()) ? "登录" : User().userName;
  }
}
