import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_flutter/common/GlobalConfig.dart';
import 'package:my_flutter/common/Router.dart';
import 'package:my_flutter/common/Snack.dart';
import 'package:my_flutter/common/User.dart';
import 'package:my_flutter/widget/BackBtn.dart';
import 'package:my_flutter/widget/ClearableInputField.dart';

class LoginRegisterPage extends StatefulWidget {
  LoginRegisterPage();

  @override
  State<StatefulWidget> createState() => new _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  bool isLogin = true;
  ClearableInputField _userNameInputForm;
  ClearableInputField _psdInputForm;
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _psdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackBtn(),
        centerTitle: true,
        title: Text(isLogin ? "登录" : "注册"),
      ),
      body: Builder(builder: (ct) {
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            SizedBox(height: 48.0),
            _buildUserNameInputFrom(),
            SizedBox(height: 8.0,),
            _buildPasswordInputFrom(),
            SizedBox(height: 24.0,),
            _buildLoginBtn(ct),
            SizedBox(height: 10.0,),
            Container(
              child: _buildRegBtn(),
              alignment: Alignment.bottomRight,
            )
          ],
        );
      }),
    );
  }

  Widget _buildLoginBtn(BuildContext context) {
    return RaisedButton(
      padding: const EdgeInsets.all(8.0),
      color: GlobalConfig.color_tags,
      textColor: Colors.white,
      child: Text(isLogin ? "登录" : "注册"),
      elevation: 4.0,
      onPressed: () {
        var _userNameStr = _userNameController.text;
        var _passwordStr = _psdController.text;
        if (null == _userNameStr || null == _passwordStr ||
            _userNameStr.length < 6 || _passwordStr.length < 6) {
          Snack.show(context, "不符合标准");
        } else {
          User().userName = _userNameStr;
          User().password = _passwordStr;
          var callback = (bool loginOK, String errorMessage) {
            if (loginOK) {
              Snack.show(context, "登录成功");
              Timer(Duration(milliseconds: 400), () {
                Router().back(context);
              });
            } else {
              Snack.show(context, errorMessage);
            }
          };
          isLogin ? User().login(callback: callback) : User().register(
              callback: callback);
        }
      },
    );
  }

  Widget _buildUserNameInputFrom() {
    _userNameInputForm = ClearableInputField(
      controller: _userNameController,
      inputType: TextInputType.emailAddress,
      hintTxt: '用户名',
    );
    return _userNameInputForm;
  }

  Widget _buildPasswordInputFrom() {
    _psdInputForm = ClearableInputField(
      controller: _psdController,
      obscureText: true,
      hintTxt: '密码',
    );
    return _psdInputForm;
  }

  Widget _buildRegBtn() {
    return FlatButton(
      child: Text(
        isLogin ? '注册新账号' : '直接登录',
        style: TextStyle(fontSize: 15.0, color: Colors.black45),
      ),
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
    );
  }

  @override
  void dispose() {
    _userNameController?.dispose();
    _psdController?.dispose();
    super.dispose();
  }
}
















