import 'package:get/get.dart';
import 'package:ism_app/imports.dart';
import 'package:ism_app/src/widgets/loading/loader.dart';

showProgressDialog() {
  var dialog = Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(100),
    ),
    child: Container(
      height: 56,
      width: 56,
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: Loader(),
    ),
  );
  var willPopScope = WillPopScope(
    child: dialog,
    onWillPop: () {
      return Future.value(false);
    },
  );
  Get.dialog(willPopScope);
}
