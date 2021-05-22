import 'package:ism_app/imports.dart';

class ValueItem extends StatelessWidget {
  String title;
  double topMargin;
  Color textColor;
  bool isHidden;

  ValueItem(
      {this.title,
      this.topMargin = 11,
      this.textColor = Colors.white,
      this.isHidden = true});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isHidden,
      child: Container(
        child: MyText(
          title,
          fontWeight: FontWeight.normal,
          color: textColor,
          maxLines: 1,
        ),
        margin: EdgeInsets.only(top: topMargin),
      ),
    );
  }
}
