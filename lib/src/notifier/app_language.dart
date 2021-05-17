import 'package:get/get.dart';
import 'package:ism_app/imports.dart';
import 'package:ism_app/src/services/api_constant.dart';
import 'package:ism_app/src/utils/preference.dart';

class AppLanguage extends ChangeNotifier {
  static String locale = "en";
  String locale_en = "en";
  Locale _appLocale = new Locale(locale);

  Locale get appLocale => _appLocale ?? Locale(locale);

  fetchLocale() async {
    var languageCode =
        await MyPreference.get(ApiConstant.LANGUAGE_CODE, SharePrefType.String);
    if (languageCode == null || languageCode == '') {
      _appLocale = Locale(locale);
      return null;
    }
    _appLocale = Locale(languageCode);
    notifyListeners();
    return null;
  }

  Future<bool> changeLanguage(Locale type) async {
    if (appLocale == type) {
      return false;
    }
    if (type == Locale(locale_en)) {
      _appLocale = Locale(locale_en);
      await MyPreference.add(
          ApiConstant.LANGUAGE_CODE, locale_en, SharePrefType.String);
    } else {
      _appLocale = type;
      await MyPreference.add(
          ApiConstant.LANGUAGE_CODE, type.languageCode, SharePrefType.String);
    }
    Get.updateLocale(type);
    notifyListeners();
    return true;
  }
}
