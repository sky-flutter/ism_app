import 'package:ism_app/imports.dart';

class ValueItem extends StatelessWidget {
  String title;
  double topMargin;
  Color textColor;

  ValueItem({this.title, this.topMargin = 11, this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MyText(
        title,
        fontWeight: FontWeight.normal,
        color: textColor,
        maxLines: 1,
        fontSize: 14,
      ),
      margin: EdgeInsets.only(top: topMargin),
    );
  }
}
