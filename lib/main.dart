import 'package:flutter/material.dart';
import 'screen/inputInfo.dart';

void main() async {
  /*
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
  } catch (e) {
    print(e);
  }
  */

  runApp(const input());
}

class input extends StatefulWidget {
  const input({Key? key}) : super(key: key);

  @override
  _inputState createState() => _inputState();
}

class _inputState extends State<input> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "input info GramPanchayat",
      home: inputInfo(),
    );
  }
}
