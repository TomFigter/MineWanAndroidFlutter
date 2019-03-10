import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:my_flutter/common/User.dart';
import 'package:my_flutter/model/homebanner/HomeBannerModel.dart';
import 'package:my_flutter/model/knowledge_systems/KnowledgeSystemsModel.dart';
import 'package:my_flutter/model/project/ProjectClassifyModel.dart';
import 'package:my_flutter/model/wechat/WeChatModel.dart';
import 'Api.dart';

class CommonService {
  void getBanner(Function callback) {
    Dio().get(Api.HOME_BANNER, options: _getOptions()).then((response) {
      callback(HomeBannerModel.fromJson(response.data));
    });
  }

  void getProjectClassify(Function callback) async {
    Dio().get(Api.PROJECT_CLASSIFY, options: _getOptions()).then((response) {
      callback(ProjectClassifyModel.fromJson(response.data));
    });
  }

  void getWechatNames(Function callback) async {
    Dio().get(Api.MP_WECHAT_NAMES, options: _getOptions()).then((response) {
      callback(WeChatModel.fromJson(response.data));
    });
  }

  Future<Response> getWeChatListData(String URL) async {
    return await Dio().get(URL, options: _getOptions());
  }

  void getTree(Function callback) async {
    Dio().get(Api.TREES_LIST, options: _getOptions()).then((response) {
      callback(KnowledgeSystemsModel.fromJson(response.data));
    });
  }

  Future<Response> getTreeItemList(String url) async {
    return await Dio().get(url, options: _getOptions());
  }

  /**
   * 获取文章列表数据
   * Article 文章
   */
  Future<Response> getArticleListData(int page) async {
    return await Dio()
        .get("${Api.HOME_LIST}$page/json", options: _getOptions());
  }

  Future<Response> getCollectListData(int page) async {
    return await Dio()
        .get("${Api.COLLECTED_ARTICLE}$page/json", options: _getOptions());
  }

  Future<Response> getProjectListData(String url) async {
    return await Dio().get(url, options: _getOptions());
  }

  Future<Response> getSearchListData(String key, int page) async {
    FormData formData = new FormData.from({
      "k": "$key",
    });
    return await Dio().post("${Api.SEARCH_LIST}$page/json",
        data: formData, options: _getOptions());
  }

  /**
   * 在线登陆操作
   */
  Future<Response> login(String username, String password) async {
    FormData formData = new FormData.from({
      "username": "$username",
      "password": "$password",
    });
    return await Dio().post(Api.LOGIN, data: formData);
  }

  Future<Response> register(String username, String password) async {
    FormData formData = new FormData.from({
      "username": "$username",
      "password": "$password",
      "repassword": "$password",
    });
    return await Dio().post(Api.REGISTER, data: formData);
  }

  Future<Response> collectInArticles(int id) async {
    return await Dio()
        .post("${Api.COLLECT_IN_ARTICLE}$id/json", options: _getOptions());
  }

  Future<Response> unCollectArticle(int id) async {
    return await Dio()
        .post("${Api.UNCOLLECT_ARTICLE}$id/json", options: _getOptions());
  }

  Future<Response> collectOutArticles(
      String title, String author, String link) async {
    FormData formData = new FormData.from({
      "title": "$title",
      "author": "$author",
      "link": "$link",
    });
    return await Dio()
        .post(Api.COLLECT_OUT_ARTICLE, data: formData, options: _getOptions());
  }

  Options _getOptions() {
    return Options(headers: User().getHeader());
  }
}
