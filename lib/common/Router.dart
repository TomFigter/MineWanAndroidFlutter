import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter/model/article_list/ArticleItemModel.dart';
import 'package:my_flutter/pages/login/LoginRegisterPage.dart';
import 'package:my_flutter/pages/search/SearchDetailPage.dart';
import 'package:my_flutter/pages/web/WebViewPage.dart';

/**
 * 页面路由Router
 */
class Router {
  /**
   * (路由)打开WEB页面
   */
  openWebPage(BuildContext context, String URL, String title) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return WebViewPage(URL: URL, title: title);
    }));
  }

  /**
   * (路由)打开文章页面
   */
  openArticlePage(BuildContext context, ArticleItemModel item) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return WebViewPage(
        articleBean: item,
      );
    }));
  }

  /**
   * (路由)打开搜索页面
   */
  openSearchPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return SearchDetailPage();
    }));
  }

  /**
   * 返回
   */
  back(BuildContext context) {
    Navigator.of(context).pop();
  }

  openLogin(BuildContext context) {
    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return LoginRegisterPage();
    }));
  }
}
