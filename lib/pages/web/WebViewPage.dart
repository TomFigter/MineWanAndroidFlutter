import 'dart:async'; //异步框架
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:my_flutter/utils/CollectUtil.dart';
import 'package:my_flutter/widget/BackBtn.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_flutter/fonts/IconF.dart';
import 'package:my_flutter/model/article_list/ArticleItemModel.dart';
import 'package:my_flutter/utils/StringUtil.dart';

/**
 * WEB 页面
 */
class WebViewPage extends StatefulWidget {
  final String URL;
  final String title;
  final ArticleItemModel articleBean;

  WebViewPage({Key key, this.URL, this.title, this.articleBean});

  @override
  State<StatefulWidget> createState() => new _WebViewState();

  /**
   * 获取URL地址
   */
  String getUrl() {
    return (!StringUtil.isNullOrEmpty(URL))
        ? URL
        : ((null != articleBean) ? articleBean.link : "");
  }

  /**
   * 获取标题
   */
  String getTitle() {
    return (!StringUtil.isNullOrEmpty(title))
        ? title
        : ((null != articleBean) ? articleBean.title : "");
  }
}

class _WebViewState extends State<WebViewPage> {
  String toastMessage;

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
//      scrollBar: true,
//      withZoom: true,
//      withLocalStorage: true,
//      withLocalUrl: true,
      url: widget.getUrl(),
      appBar: AppBar(
        title: Text(
          null != toastMessage ? toastMessage : widget.getTitle(),
          textAlign: null != toastMessage ? TextAlign.center : TextAlign.start,
          style: null != toastMessage
              ? TextStyle(
                  fontSize: 15.0,
                  color: Colors.yellow,
                )
              : null,
        ),
        leading: BackBtn(),
        actions: <Widget>[
          _buildStared(context),
          _buildOpenWithBrowser(),
        ],
      ),
    );
  }

  /**
   * 收藏功能
   */
  Widget _buildStared(BuildContext context) {
    if (null == widget.articleBean || null == widget.articleBean.collect) {
      return Text("");
    } else {
      return IconButton(
        icon: Icon(
          (widget.articleBean.collect) ? IconF.like_fill : IconF.like_stroke,
          color: Colors.white,
        ),
        onPressed: () {
          CollectUtil.updateCollectState(context, widget.articleBean,
              (bool isOK, String errorMessage) {
            if (isOK) {
              setState(() {
                widget.articleBean.collect = !widget.articleBean.collect;
              });
            } else {
              setState(() {
                toastMessage = errorMessage;
              });
              Timer(Duration(seconds: 2), () {
                setState(() {
                  toastMessage = null;
                });
              });
            }
          });
        },
      );
    }
  }

  Widget _buildOpenWithBrowser() {
    return IconButton(
      icon: Icon(IconF.browser),
      onPressed: () {
        launch(widget.getUrl());
      },
    );
  }
}
