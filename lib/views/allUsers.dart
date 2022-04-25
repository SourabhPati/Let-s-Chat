import 'package:chat_application/Widgets/widget.dart';
import 'package:chat_application/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllUsers extends StatefulWidget {
  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  Database db = new Database();

  QuerySnapshot searchSnaphot;

  getUsersFromDb() {
    db.getAllUsers().then((val) {
      setState(() {
        searchSnaphot = val;
      });
    });
  }

  Widget userList() {
    return searchSnaphot != null
        ? ListView.builder(
            itemCount: searchSnaphot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return UserTile(
                username: searchSnaphot.documents[index].data["name"],
                email: searchSnaphot.documents[index].data["email"],
              );
            })
        : Container();
  }

  Widget UserTile({String username, String email}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      color: Colors.black26,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.green,
            ),
            child: Text(
              "${username.substring(0, 1).toUpperCase()}",
              style: whiteText(24),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(username, style: whiteText(20)),
              SizedBox(
                height: 6,
              ),
              Text(email, style: whiteText(16))
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    getUsersFromDb();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            userList(),
          ],
        ),
      ),
    );
  }
}
