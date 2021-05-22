import 'dart:ui';

import 'package:ism_app/imports.dart';

class ErrorView extends StatelessWidget {
  String strError;

  ErrorView(this.strError);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(24),
      child: MyText(
        strError,
        fontWeight: FontWeight.normal,
        fontSize: 14,
        textAlign: TextAlign.center,
        maxLines: 4,
      ),
    );
  }
}
