
import 'package:ism_app/imports.dart';

class KeyItem extends StatelessWidget {
  String title;
  double topMargin;

  KeyItem({this.title, this.topMargin = 11});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MyText(
        title,
        fontWeight: FontWeight.bold,
        color: MyColors.color_3F4446,
      ),
      margin: EdgeInsets.only(top: topMargin),
    );
  }
}

