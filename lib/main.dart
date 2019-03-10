import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter/common/GlobalConfig.dart';
import 'package:my_flutter/pages/Application.dart';

void main(){
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
  return runApp(new MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "玩Android",
      theme: ThemeData(
        fontFamily: "noto",
        primaryColor:GlobalConfig.color_tags,
      ),
      home:  ApplicationPage(),
    );
  }

}