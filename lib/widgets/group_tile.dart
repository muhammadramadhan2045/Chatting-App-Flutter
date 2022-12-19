import 'package:chatting_app/screen/chat_page.dart';
import 'package:chatting_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const GroupTile(
      {Key? key,
      required this.userName,
      required this.groupId,
      required this.groupName})
      : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
          context,
          ChatPage(
              groupId: widget.groupId,
              groupName: widget.groupName,
              userName: widget.userName),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            widget.groupName,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),
          ),
          subtitle: Text(
            "Bergabung ke chat sebagai " + widget.userName,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
