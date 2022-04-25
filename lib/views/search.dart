import 'package:chat_application/Widgets/widget.dart';
import 'package:chat_application/helper/constants.dart';
import 'package:chat_application/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'ConversationsScreen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Database db = new Database();
  TextEditingController search = new TextEditingController();

  QuerySnapshot searchSnaphot;

  searchDb() {
    db.getUserByUsername(search.text).then((val) {
      setState(() {
        searchSnaphot = val;
      });
    });
  }

  Widget searchList() {
    return searchSnaphot != null
        ? ListView.builder(
            itemCount: searchSnaphot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                username: searchSnaphot.documents[index].data["name"],
                email: searchSnaphot.documents[index].data["email"],
              );
            })
        : Container();
  }

  createAndOpenChatRoom({String userName}) {
    String chatRoomId = getChatRoomId(userName, Constants.myName);

    List<String> users = [userName, Constants.myName];
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatroomId": chatRoomId
    };
    Database().createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId),
        ));
  }

  Widget SearchTile({String username, String email}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1),
      color: Colors.black26,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(username, style: whiteText(18)),
              Text(email, style: whiteText(18))
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createAndOpenChatRoom(userName: username);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(50),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Text(
                "Message",
                style: whiteText(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    //searchDb();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x49007706),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: search,
                        style: whiteText(20),
                        decoration: InputDecoration(
                            hintText: "search user ...",
                            hintStyle: TextStyle(
                              color: Colors.white54,
                              fontSize: 18,
                            ),
                            border: InputBorder.none)),
                  ),
                  GestureDetector(
                    onTap: () {
                      searchDb();
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0x4900FF0D), Color(0x4901A109)]),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.search,
                        size: 24,
                        color: Colors.white,
                      ),

                      //Image.asset("assets/images/search.png")
                    ),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.compareTo(b) == 1) {
    return b + '_' + a;
  } else {
    return a + '_' + b;
  }
}
