import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socsem_flutter/utils/constants.dart' as Constants;
import 'package:socsem_flutter/utils/util_methods.dart';

class ReadingLogPage extends StatefulWidget {
  @override
  _ReadingLogPageState createState() => _ReadingLogPageState();
}

class _ReadingLogPageState extends State<ReadingLogPage> {
  final firestoreInstance = FirebaseFirestore.instance;
  final firebaseUser = FirebaseAuth.instance.currentUser;
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.PRIMARY,
        appBar: AppBar(
            backgroundColor: Constants.PRIMARY,
            title: const Text("Reading Log",
                style: TextStyle(color: Constants.WHITE)),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                })),
        body: StreamBuilder<DocumentSnapshot>(
            stream: firestoreInstance
                .collection("reading_sessions")
                .doc(firebaseUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var sessions = snapshot.data.toString().contains("sessions")
                    ? snapshot.data?.get("sessions")
                    : "";
                return ListView.builder(
                    itemCount: sessions.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return buildCard(sessions[index]);
                    });
              } else if (snapshot.hasError) {
                showMessage(context, "No Reading Sessions",
                    "You have not logged any reading sessions, so there is no data to show");
                return Container();
              }
              return LinearProgressIndicator();
            }));
  }

  Card buildCard(var session) {
    return Card(
      elevation: 1.0,
      child: Container(
          decoration: const BoxDecoration(color: Constants.WHITE),
          child: buildListTile(session)),
    );
  }

  ListTile buildListTile(var session) {
    Size size = MediaQuery.of(context).size;
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    DateTime date =
        new DateTime.fromMillisecondsSinceEpoch(session["timestamp"]);
    Duration dur = Duration(seconds: session["session_length"]);
    String title = session["book_name"];
    String bookmark = session["page_number"];
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      leading: Container(
          padding: const EdgeInsets.only(right: 12.0),
          decoration: const BoxDecoration(
              border: Border(
                  right: BorderSide(width: 1.0, color: Constants.SECONDARY))),
          child: Column(
            children: [
              Text(
                "Date: " +
                    date.month.toString() +
                    "/" +
                    date.day.toString() +
                    "/" +
                    date.year.toString(),
                style: const TextStyle(color: Constants.BLACK),
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                  "Length: " +
                      twoDigits(dur.inHours) +
                      ":" +
                      twoDigits(dur.inMinutes) +
                      ":" +
                      twoDigits(dur.inSeconds),
                  style: const TextStyle(color: Constants.BLACK))
            ],
          )),
      title: Text(
        title,
        style: const TextStyle(color: Constants.BLACK),
      ),
      subtitle: Text(
        bookmark,
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: const Icon(Icons.menu_book, color: Constants.BLACK, size: 50),
    );
  }
}
