
import 'package:ism_app/imports.dart';

class KeyItem extends StatelessWidget {
  String title;
  double topMargin;
  bool isHidden;
  KeyItem({this.title, this.topMargin = 11,this.isHidden=true});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isHidden,
      child: Container(
        child: MyText(
          title,
          fontWeight: FontWeight.bold,
          color: MyColors.color_3F4446,
        ),
        margin: EdgeInsets.only(top: topMargin),
      ),
    );
  }
}

