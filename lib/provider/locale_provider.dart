import 'package:flutter/material.dart';
import 'package:inputgram/l10n/l10n.dart';
import 'package:inputgram/util.dart';

class LocaleProvider extends ChangeNotifier {
  //Locale _locale = Locale('en');

  Locale get locale => gLocale;

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;

    gLocale = locale;
    notifyListeners();
  }

  void clearLocale() {
    gLocale = Locale('en');
    notifyListeners();
  }
}
