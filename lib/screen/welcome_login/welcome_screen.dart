import 'package:flutter/material.dart';
import 'package:inputgram/screen/welcome_login/forgotPassword.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:inputgram/constants.dart';
import 'package:inputgram/util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = "welcomescreen";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    gContext = context;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                appLabel,
                style: TextStyle(
                  fontSize: 45.0,
                  shadows: [
                    Shadow(
                      color: Colors.red,
                      blurRadius: 5.0,
                      offset: Offset(0.0, 5.0),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                elevation: 5.0,
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  splashColor: clrBSplash,
                  onPressed: () {
                    //Go to login screen.
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                  minWidth: 150.0,
                  height: 42.0,
                  child: Text(
                    AppLocalizations.of(gContext)!.bLabelAdminlogin,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30.0),
                elevation: 5.0,
                child: MaterialButton(
                  splashColor: clrBSplash,
                  onPressed: () async {
                    //Go to registration screen.
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                  minWidth: 150.0,
                  height: 42.0,
                  child: Text(
                    AppLocalizations.of(gContext)!.bLabelAdminRegiter,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, forgotPasswordScreen.id);
              },
              child: Text(
                AppLocalizations.of(gContext)!.labelForgotPassword,
                style: TextStyle(
                    color: Colors.blueGrey,
                    decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
