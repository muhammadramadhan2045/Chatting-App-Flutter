import 'package:chatting_app/helper/helper_function.dart';
import 'package:chatting_app/screen/home_page.dart';
import 'package:chatting_app/services/database_service.dart';
import 'package:chatting_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupInfo extends StatefulWidget {
  final String adminName;
  final String groupId;
  final String groupName;
  const GroupInfo(
      {super.key,
      required this.adminName,
      required this.groupId,
      required this.groupName});

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  String userName = "";

  @override
  void initState() {
    // TODO: implement initState
    getMembers();
    getUserName();
    super.initState();
  }

  getUserName() async {
    HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
        print(userName);
      });
    });
  }

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((value) {
      setState(() {
        members = value;
      });
    });
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getAdminName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text(
          "Group Info",
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Exit Group"),
                        content: const Text(
                            "Are you sure you want to Ext fromt this group?"),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              DatabaseService(
                                      uid: FirebaseAuth
                                          .instance.currentUser!.uid)
                                  .joinGrup(
                                widget.groupId,
                                userName,
                                widget.groupName,
                              )
                                  .whenComplete(() {
                                nextScreenReplace(context, const HomePage());
                              });
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).primaryColor.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group ${widget.groupName}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 5),
                      Text("Admin : ${getAdminName(widget.adminName)}"),
                    ],
                  ),
                ],
              ),
            ),
            memberList(),
          ],
        ),
      ),
    );
  }

  memberList() {
    return StreamBuilder(
      stream: members,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data["members"] != null) {
            if (snapshot.data["members"].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data["members"].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          getAdminName(snapshot.data["members"][index])
                              .substring(0, 1)
                              .toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, color: Colors.white),
                        ),
                      ),
                      title: Text(getAdminName(snapshot.data["members"][index])
                        ..substring(0, 1)),
                      subtitle: Text(getId(snapshot.data["members"][index])),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("Tidak Ada Member"),
              );
            }
          } else {
            return const Center(
              child: Text("Tidak Ada Member"),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }
}
