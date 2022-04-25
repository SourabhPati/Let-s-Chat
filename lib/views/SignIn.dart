import 'package:chat_application/Widgets/widget.dart';
import 'package:chat_application/helper/helperFunctions.dart';
import 'package:chat_application/services/auth.dart';
import 'package:chat_application/services/database.dart';
import 'package:chat_application/views/allUsers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

import 'ChatRoomScreen.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  Auth auth = new Auth();
  Database db = new Database();
  bool isLoading = false;
  bool validCreds = true;
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  QuerySnapshot gotUser;

  signInUser() {
    if (formKey.currentState.validate()) {
      HelperFunctions.saveUserEmailInfo(email.text);

      setState(() {
        isLoading = true;
      });
      db.getUserByEmail(email.text).then((val) {
        gotUser = val;
        HelperFunctions.saveUsernameInfo(gotUser.documents[0].data["name"]);
      });
      auth
          .signInWithEmailAndPassword(email.text.trim(), password.text)
          .then((value) {
        if (value != null) {
          HelperFunctions.saveLoggedInInfo(true);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChatRoom(),
              ));
        } else {
          setState(() {
            validCreds = false;
          });
        }
      }).catchError((onError) {
        print("Error Occured : " + onError);
        setState(() {
          validCreds = false;
        });
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
                              // validator: (val) {
                              //   return RegExp(
                              //               r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$")
                              //           .hasMatch(val)
                              //       ? null
                              //       : "Password must be 8+ characters with atleast a letter and a number";
                              // },
                              controller: password,
                              style: whiteText(16),
                              decoration: whiteDecoration("password"),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      validCreds
                          ? Row()
                          : Container(
                              //color: Color(0x49007706),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 14),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "Invalid email or password",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      GestureDetector(
                        onTap: validCreds
                            ? () {
                                print(validCreds);
                              }
                            : null,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: !validCreds
                                ? Text("Forgot Password?", style: whiteText(18))
                                : Text("Forgot Password?",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white12,
                                    )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          signInUser();
                        },
                        child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [Colors.green, Colors.greenAccent]),
                                borderRadius: BorderRadius.circular(30)),
                            child: Text("Sign In", style: whiteText(20))),
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
                            "Don't have an account?  ",
                            style: whiteText(18),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "Register Now",
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
