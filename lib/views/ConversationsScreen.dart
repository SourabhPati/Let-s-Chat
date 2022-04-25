import 'package:chat_application/Widgets/widget.dart';
import 'package:chat_application/helper/constants.dart';
import 'package:chat_application/helper/helperFunctions.dart';
import 'package:chat_application/services/database.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  Database db = new Database();
  TextEditingController message = new TextEditingController();
  Stream chatStream;
  Widget ChatMessageList() {
    return StreamBuilder(
      stream: chatStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageBubble(
                    snapshot.data.documents[index].data["message"],
                    snapshot.data.documents[index].data["sentBy"] ==
                        Constants.myName,
                  );
                })
            : Container();
      },
    );
  }

  sendMessage() {
    if (message.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": message.text,
        "sentBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      db.addConversationMessages(widget.chatRoomId, messageMap);
      message.text = "";
    }
  }

  @override
  void initState() {
    db.getConversationMessages(widget.chatRoomId).then((val) {
      setState(() {
        chatStream = val;
      });
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    String chatName =
        HelperFunctions().getChatName(widget.chatRoomId, Constants.myName);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: LinearGradient(
                    colors: [Color(0xC9047A0C), Color(0xE00C3300)]),
              ), //0xE00C3300
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
              style: whiteText(22),
            ),
          ],
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).viewInsets.bottom == 0
                  ? MediaQuery.of(context).size.height - 160
                  : MediaQuery.of(context).size.height - 410,
              child: ChatMessageList(),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x49007706),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          controller: message,
                          style: whiteText(20),
                          decoration: InputDecoration(
                              hintText: "send message ...",
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                fontSize: 18,
                              ),
                              border: InputBorder.none)),
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 14, right: 10, top: 12, bottom: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0x4900FF0D), Color(0x4901A109)]),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.send,
                          size: 24,
                          color: Colors.white,
                        ),

                        //Image.asset("assets/images/search.png")
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMyMessage;
  MessageBubble(this.message, this.isMyMessage);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      width: MediaQuery.of(context).size.width,
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isMyMessage
                  ? [Color(0x4900FF0D), Color(0x4901A109)]
                  : [Color(0xA23B3B3B), Color(0xE19C9C9C)],
            ),
            borderRadius: isMyMessage
                ? BorderRadius.only(
                    topLeft: Radius.circular(30), // 0xE19C9C9C
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))
                : BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
        child: Text(
          message,
          style: whiteText(16),
        ),
      ),
    );
  }
}
