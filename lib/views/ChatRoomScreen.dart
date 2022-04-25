import 'package:chat_application/Widgets/widget.dart';
import 'package:chat_application/helper/authenticate.dart';
import 'package:chat_application/helper/constants.dart';
import 'package:chat_application/helper/helperFunctions.dart';
import 'package:chat_application/services/auth.dart';
import 'package:chat_application/services/database.dart';
import 'package:chat_application/views/ConversationsScreen.dart';
import 'package:chat_application/views/search.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<ChatRoom> {
  Auth auth = new Auth();
  Database db = new Database();

  Stream chatRoomsSteam;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsSteam,
      builder: (context, snapshot) {
        return snapshot.data != null
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  String chatRoomId =
                      snapshot.data.documents[index].data["chatroomId"];
                  String chatName = HelperFunctions()
                      .getChatName(chatRoomId, Constants.myName);
                  return ChatRooms(chatName, chatRoomId);
                })
            : Container(
                // alignment: Alignment.center,
                // child: Text(
                //   "No chats",
                //   style: whiteText(28),
                // ),
                );
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUsernameInfo();
    db.getChatRooms(Constants.myName).then((val) {
      setState(() {
        chatRoomsSteam = val;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/chatAppTitleCrop.png",
          height: 55,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              auth.signOut();
              HelperFunctions.logoutUser();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Authenticate(),
                  ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchScreen(),
              ));
        },
      ),
    );
  }
}

class ChatRooms extends StatelessWidget {
  final String chatName;
  final String chatRoomId;
  ChatRooms(this.chatName, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(chatRoomId)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1),
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.green,
              ),
              child: Text(
                "${chatName.substring(0, 1).toUpperCase()}",
                style: whiteText(24),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              chatName,
              style: whiteText(18),
            ),
          ],
        ),
      ),
    );
  }
}
