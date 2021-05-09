import 'package:ism_app/imports.dart';

class MyShadowContainer extends StatelessWidget {
  Widget child;
  Color bgColor;
  EdgeInsets margin, padding;
  BorderRadius borderRadius;
  Color shadowColor;

  MyShadowContainer(
      {this.child,
      this.margin,
      this.shadowColor = MyColors.color_FFFFFF,
      this.padding,
      this.borderRadius,
      this.bgColor = MyColors.color_FFFFFF});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration:
          BoxDecoration(color: bgColor, borderRadius: borderRadius, boxShadow: [
        BoxShadow(
          color: shadowColor,
          spreadRadius: 1,
          blurRadius: 7,
          offset: Offset(0, 3),
        )
      ]),
      child: child,
    );
  }
}
