import 'package:chat_application/Widgets/widget.dart';
import 'package:chat_application/helper/helperFunctions.dart';
import 'package:chat_application/services/auth.dart';
import 'package:chat_application/services/database.dart';
import 'package:chat_application/views/ChatRoomScreen.dart';
import 'package:flutter/material.dart';

import 'allUsers.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  Auth auth = new Auth();
  Database db = new Database();

  final formKey = GlobalKey<FormState>();
  TextEditingController username = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  signUpUser() {
    if (formKey.currentState.validate()) {
      Map<String, String> userInfo = {
        "name": username.text.trim(),
        "email": email.text.trim(),
      };

      HelperFunctions.saveUserEmailInfo(email.text);
      HelperFunctions.saveUsernameInfo(username.text);

      setState(() {
        isLoading = true;
      });
      auth
          .signUpWithEmailAndPassword(email.text.trim(), password.text)
          .then((value) {
        db.uploadUserInfo(userInfo);
        HelperFunctions.saveLoggedInInfo(true);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChatRoom(),
            ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(child: Center(child: CircularProgressIndicator()))
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 70,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (val) {
                                if (val.isEmpty == true)
                                  return "Please enter a username";
                                else if (val.length < 3)
                                  return "Username should atleast be 3 characters.";
                                else if (!RegExp(
                                        r"^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                                    .hasMatch(val))
                                  return "Please enter a valid username";
                                return null;
                              },
                              controller: username,
                              style: whiteText(16),
                              decoration: whiteDecoration("username"),
                            ),
                            TextFormField(
                              validator: (val) {
                                return RegExp(
                                            r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                                        .hasMatch(val.trim())
                                    ? null
                                    : "Please enter a valid email id";
                              },
                              controller: email,
                              style: whiteText(16),
                              decoration: whiteDecoration("email"),
                            ),
                            TextFormField(
                              obscureText: true,
                              validator: (val) {
                                return RegExp(
                                            r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$")
                                        .hasMatch(val)
                                    ? null
                                    : "Password must be 8+ characters with atleast a letter and a number";
                              },
                              controller: password,
                              style: whiteText(16),
                              decoration: whiteDecoration("password"),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      // Container(
                      //   alignment: Alignment.centerRight,
                      //   child: Container(
                      //     padding: EdgeInsets.symmetric(
                      //         horizontal: 16, vertical: 10),
                      //     child: Text("Forgot Password?", style: whiteText(18)),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      GestureDetector(
                        onTap: () {
                          signUpUser();
                        },
                        child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [Colors.green, Colors.greenAccent]),
                                borderRadius: BorderRadius.circular(30)),
                            child: Text("Sign Up", style: whiteText(20))),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllUsers(),
                              ));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            "See all Users",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?  ",
                            style: whiteText(18),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "Sign in Now",
                                style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 18,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
