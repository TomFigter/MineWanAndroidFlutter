import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:my_flutter/api/CommonService.dart';
import 'package:my_flutter/common/SharedPreferencesUtil.dart';
import 'package:my_flutter/model/login/UserModel.dart';
import 'package:my_flutter/utils/DateUtil.dart';

class User {
  String userName;
  String password;
  String cookie;
  DateTime cookieExpiresTime;

  /**
   * 以"_"命名的变量或方法名,代表私有变量\私有方法
   */
  Map<String, String> _headerMap;

  /**
   * 私有构造方法
   */
  static final User _singleton = User._internal();

  factory User() {
    return _singleton;
  }

  User._internal();

  /**
   * 是否登陆成功
   */
  bool isLogin() {
    return null != userName &&
        userName.length >= 6 &&
        null != password &&
        password.length > 6;
  }

  /**
   * 退出操作 清除所有用户缓存信息
   */
  void logout() {
    SharedPreferencesUtil.putUserName(null);
    SharedPreferencesUtil.putPassword(null);
    userName = null;
    password = null;
    _headerMap = null;
  }

  /**
   * 参数 允许是一个方法
   */
  void refreshUserData({Function callback}) {
    SharedPreferencesUtil.getPassword((password) {
      this.password = password;
    });
    SharedPreferencesUtil.getUserName((userName) {
      this.userName = userName;
      if (null != callback) {
        callback();
      }
    });
    SharedPreferencesUtil.getCookie((cookie) {
      this.cookie = cookie;
      _headerMap = null;
    });
    SharedPreferencesUtil.getCookieExpires((cookieExpiresTime) {
      if (null != cookieExpiresTime && cookieExpiresTime.length > 0) {
        this.cookieExpiresTime = DateTime.parse(cookieExpiresTime);
        //提前3天请求新的cookie
        if (this.cookieExpiresTime.isAfter(DateUtil.getDaysAgo(3))) {
          Timer(Duration(microseconds: 100), () {
            autoLogin();
          });
        }
      }
    });
  }

  /**
   * 登陆操作
   */
  void login({Function callback}) {
    _saveUserInfo(CommonService().login(userName, password), userName, password,
        callback: callback);
  }

  /**
   * 保存用户信息
   */
  void _saveUserInfo(
      Future<Response> responseF, String userName, String password,
      {Function callback}) {
    responseF.then((response) {
      var userModel = UserModel.fromJson(response.data);
      if (userModel.errorCode == 0) {
        SharedPreferencesUtil.putUserName(userName);
        SharedPreferencesUtil.putPassword(password);
        String cookie = "";
        DateTime expires;
        response.headers.forEach((String name, List<String> values) {
          if (name == "set-cookie") {
            //cookie记录
            cookie = json
                .encode(values)
                .replaceAll("\[\"", "")
                .replaceAll("\"\]", "")
                .replaceAll("\",\"", "; ");
            try {
              expires = DateUtil.formatExpiresTime(cookie);
            } catch (e) {
              expires = DateTime.now();
            }
          }
        });
        SharedPreferencesUtil.putCookie(cookie); //存储cookie
        SharedPreferencesUtil.putCookieExpires(expires.toIso8601String());
        if (null != callback) callback(true, null);
      } else {
        if (null != callback) callback(false, userModel.errorMsg);
      }
    });
  }

  void autoLogin() {
    if (isLogin()) {
      login();
    }
  }

  /**
   * 获取Handler数据
   */
  Map<String, String> getHeader() {
    if (null == _headerMap) {
      _headerMap = Map();
      _headerMap["Cookie"] = cookie;
    }
    return _headerMap;
  }

  void register({Function callback}) {}
}
