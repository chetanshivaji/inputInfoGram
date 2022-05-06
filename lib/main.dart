import 'package:flutter/material.dart';
import 'screen/inputInfo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'myApp.dart';

import 'screen/approve.dart';
import 'screen/updateInfo.dart';
import 'screen/reportInfo.dart';
import 'screen/welcome_login/login_screen.dart';
import 'screen/welcome_login/registration_screen.dart';
import 'screen/welcome_login/welcome_screen.dart';
import 'screen/welcome_login/forgotPassword.dart';

import 'package:provider/provider.dart';
import 'provider/locale_provider.dart';
import 'l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:inputgram/constants.dart';
import 'package:inputgram/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      // Replace with actual values
      options: FirebaseOptions(
        apiKey: "AIzaSyAxXZsweakuYy5HBQnsU5tmlUVq7rp4gzk",
        appId: "1:221118467263:android:93a0115c427c05eca94a0a",
        messagingSenderId: "221118467263",
        projectId: "gramtry-7a07a",
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    final String? lang = await prefs
        .getString(keyAdminAppLanguage); //read on disk in key value format.

    if (lang != null) {
      gLocale = Locale(lang);
    } else {
      gLocale = Locale('en');
    }
  } catch (e) {
    print(e);
  }

  runApp(xApp());
}

class xApp extends StatelessWidget {
  static final String title = 'Localization';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => LocaleProvider(),
        builder: (context, child) {
          final provider = Provider.of<LocaleProvider>(context);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Admin",
            initialRoute: WelcomeScreen.id,
            supportedLocales: L10n.all,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            locale: provider.locale,
            routes: {
              MyApp.id: (context) => MyApp(),
              inputInfo.id: (context) => inputInfo(),
              updateInfo.id: (context) => updateInfo(),
              reportInfo.id: (context) => reportInfo(),
              approve.id: (context) => approve(),
              WelcomeScreen.id: (context) => WelcomeScreen(),
              LoginScreen.id: (context) => LoginScreen(),
              RegistrationScreen.id: (context) => RegistrationScreen(),
              forgotPasswordScreen.id: (context) => forgotPasswordScreen(),
            },
          );
        },
      );
}
