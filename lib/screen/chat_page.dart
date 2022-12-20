import 'package:chatting_app/screen/group_info.dart';
import 'package:chatting_app/services/database_service.dart';
import 'package:chatting_app/widgets/message_tile.dart';
import 'package:chatting_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const ChatPage(
      {Key? key,
      required this.userName,
      required this.groupId,
      required this.groupName})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageControler = TextEditingController();
  String admin = "";
  @override
  void initState() {
    // TODO: implement initState
    getChatsAndAdmin();
    super.initState();
  }

  getChatsAndAdmin() {
    DatabaseService().getChats(widget.groupId).then((value) {
      setState(() {
        chats = value;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        admin = value;
        print(admin);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 10,
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: Text(
            widget.groupName,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  nextScreen(
                      context,
                      GroupInfo(
                          adminName: admin,
                          groupId: widget.groupId,
                          groupName: widget.groupName));
                },
                icon: const Icon(Icons.info))
          ],
        ),
        body: Stack(
          children: <Widget>[
            chatMessages(),
            const SizedBox(
              height: 100,
            ),
            sendMessages2(),
          ],
        ));
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data!.docs[index]["message"],
                      sender: snapshot.data!.docs[index]["sender"],
                      sentByMe: widget.userName ==
                          snapshot.data!.docs[index]["sender"]);
                },
              )
            : Container();
      },
    );
  }

  sendMessages() {
    if (messageControler.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageControler.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageControler.clear();
      });
    }
  }

  sendMessages2() {
    return Container(
      alignment: Alignment.bottomCenter,
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        width: MediaQuery.of(context).size.width,
        color: Colors.grey.withOpacity(0.5),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: messageControler,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Kirim pesan..",
                  hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.8), fontSize: 16),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                sendMessages();
              },
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(40)),
                child: const Center(
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
