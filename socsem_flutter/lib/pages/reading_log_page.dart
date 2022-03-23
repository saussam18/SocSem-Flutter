import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socsem_flutter/utils/constants.dart' as Constants;

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
                  Navigator.pushReplacementNamed(context, Constants.ROUTE_HOME);
                })),
        body: StreamBuilder<DocumentSnapshot>(
            stream: firestoreInstance
                .collection("reading_sessions")
                .doc(firebaseUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              var sessions = snapshot.data?.get("sessions");
              return ListView.builder(
                  itemCount: sessions.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return buildCard(sessions[index]);
                  });
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
                  "Session Length: " +
                      dur.inHours.toString() +
                      ":" +
                      dur.inMinutes.toString() +
                      ":" +
                      dur.inSeconds.toString(),
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
      trailing: const Icon(Icons.book, color: Constants.BLACK, size: 30),
    );
  }
}
