import 'package:flutter/material.dart';

/**
 * Item中下部分的 边框widget TAG
 */
class StrokeWidget extends StatelessWidget {
  final Color color;
  final Widget childWidget;
  EdgeInsets edgeInsets;
  final double strokeWidth;
  final double strokeRadius;

  StrokeWidget(
      {Key key,
      @required this.childWidget,
      this.color = Colors.black,
      this.edgeInsets,
      this.strokeWidth = 1.0,
      this.strokeRadius = 5.0})
      : super(key: key) {
    if (null == edgeInsets)
      edgeInsets = EdgeInsets.symmetric(horizontal: 2.0, vertical: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: edgeInsets,
        decoration: BoxDecoration(
            border: Border.all(color: color, width: strokeWidth),  //边框的颜色和宽度
            borderRadius: BorderRadius.circular(strokeRadius)), //圆角边框的角度
        child: childWidget);
  }
}
