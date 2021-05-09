import 'package:ism_app/imports.dart';

class MyContainer extends StatelessWidget {
  Widget children;
  Color bgColor;
  EdgeInsets margin, padding;

  MyContainer(
      {this.children,
      this.margin,
      this.padding,
      this.bgColor = MyColors.color_FFFFFF});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
      ),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              Strings.loginBottomImage,
            ),
          ),
          children,
        ],
      ),
    );
  }
}
