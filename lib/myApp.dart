import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inputgram/screen/approve.dart';
import 'package:inputgram/screen/inputInfo.dart';
import 'package:inputgram/screen/reportInfo.dart';
import 'package:inputgram/screen/updateInfo.dart';
import 'constants.dart';
import 'package:inputgram/util.dart';
import 'package:inputgram/constants.dart';

import 'package:provider/provider.dart';
import 'provider/locale_provider.dart';
import 'l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguagePickerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    gContext = context;
    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale ?? Locale('en');

    return DropdownButtonHideUnderline(
      child: DropdownButton(
        value: locale,
        icon: Container(width: 5),
        items: L10n.all.map(
          (locale) {
            final flag = L10n.getFlag(locale.languageCode);

            return DropdownMenuItem(
              child: Center(
                child: Text(
                  flag,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              value: locale,
              onTap: () {
                final provider =
                    Provider.of<LocaleProvider>(context, listen: false);

                provider.setLocale(locale);
              },
            );
          },
        ).toList(),
        onChanged: (langChanged) async {
          //set language in firebase db to use for next launch of app.
          String userAppLang = "en";
          if (langChanged == Locale('en')) {
            userAppLang = "en";
          }
          if (langChanged == Locale('mr')) {
            userAppLang = "mr";
          }
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(keyAdminAppLanguage,
              userAppLang); //write on disk in key value format.
        },
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  static String id = "myappscreen";
  bool drawerOpen = false;

  MyApp({Key? key}) : super(key: key);
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    gContext = context;
    return WillPopScope(
      onWillPop: () {
        if (drawerOpen == true) {
          Navigator.pop(context);
        }

        popLogOutAlert(
          context,
          AppLocalizations.of(gContext)!.kTitleSignOut,
          AppLocalizations.of(gContext)!.kSubtitleLogOutConfirmation,
          Icon(Icons.power_settings_new),
        );
        //we need to return a future
        return Future.value(false);
      },
      child: Scaffold(
        onDrawerChanged: (isOpen) {
          drawerOpen = isOpen;
        },
        appBar: AppBar(
          title: Text(AppLocalizations.of(gContext)!.appBarMainAppInfo),
          actions: <Widget>[
            LanguagePickerWidget(),
            IconButton(
              splashColor: clrIconSpalsh,
              splashRadius: iconSplashRadius,
              tooltip: AppLocalizations.of(gContext)!.kTitleSignOut,
              onPressed: () {
                //logout
                popLogOutAlert(
                    context,
                    AppLocalizations.of(gContext)!.kTitleSignOut,
                    AppLocalizations.of(gContext)!.kSubtitleLogOutConfirmation,
                    Icon(Icons.power_settings_new));
              },
              icon: Icon(Icons.power_settings_new),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Stack(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(gContext)!.dHeading,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.yellow,
                      ),
                    ), //gree
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.person_add),
                title: Text(AppLocalizations.of(gContext)!.dAddPerson),
                tileColor: clrGreen, //green
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  if (onPressedDrawerAddPerson == false) {
                    onPressedDrawerAddPerson = true;
                    Navigator.pushNamed(context, inputInfo.id);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.update),
                title: Text(AppLocalizations.of(gContext)!.dUpdatePerson),
                tileColor: clrBlue, //red
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  if (onPressedDrawerUpdatePerson == false) {
                    onPressedDrawerUpdatePerson = true;
                    Navigator.pushNamed(context, updateInfo.id);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.approval),
                title: Text(AppLocalizations.of(gContext)!.dApprove),
                tileColor: clrAmber, //red
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  if (onPressedDrawerApprove == false) {
                    onPressedDrawerApprove = true;
                    Navigator.pushNamed(context, approve.id);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.report),
                title: Text(AppLocalizations.of(gContext)!.dReport),
                tileColor: clrRed, //red
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  if (onPressedDrawerReport == false) {
                    onPressedDrawerReport = true;
                    Navigator.pushNamed(context, reportInfo.id);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
