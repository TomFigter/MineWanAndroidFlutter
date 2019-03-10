import 'package:flutter/material.dart';
import 'package:my_flutter/fonts/IconF.dart';

class BackBtn extends StatelessWidget {
  final Color color;

  const BackBtn({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    return IconButton(
      icon: Icon(IconF.back),
      color: color,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () {
        Navigator.maybePop(context);
      },
    );
  }
}
