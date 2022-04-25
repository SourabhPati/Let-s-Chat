import 'package:chat_application/helper/authenticate.dart';
import 'package:chat_application/helper/helperFunctions.dart';
import 'package:chat_application/views/ChatRoomScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  bool loggedIn;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getLoggedInInfo().then((value) {
      setState(() {
        loggedIn = value;
      });
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF1F1F1F),
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: loggedIn == null
          ? Authenticate()
          : (loggedIn ? ChatRoom() : Authenticate()),
    );
  }
}
