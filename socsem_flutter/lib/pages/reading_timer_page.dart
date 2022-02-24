import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socsem_flutter/widgets/button_widget.dart';

class ReadingTimerPage extends StatefulWidget {
  @override
  _ReadingTimerPageState createState() => _ReadingTimerPageState();
}

class _ReadingTimerPageState extends State<ReadingTimerPage> {
  Duration duration = const Duration();
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // Reset on Page Load
    reset();
  }

  void reset() {
    setState(() => duration = const Duration());
  }

  void stopTimer({bool resets = true}) {
    // Stops and if Resets is true reset the timer
    if (resets) {
      reset();
    }

    // Stop the timer from continuing
    setState(() {
      timer?.cancel();
    });
  }

  // Increment Time
  void addTime() {
    const addSeconds = 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  void startTimer({bool resets = true}) {
    // If resets is true, reset the timer
    if (resets) {
      reset();
    }
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(children: [
        SizedBox(height: size.height * 0.20),
        Text(user!.email!),
        Text(user.displayName!),
        CircleAvatar(
          backgroundImage: NetworkImage(user.photoURL!),
          radius: 20,
        ),
        SizedBox(height: size.height * 0.20),
        buildTime(context),
        SizedBox(height: size.height * 0.10),
        buildButtons(context)
      ]),
    );
  }

  Widget buildTime(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours.remainder(60));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimeCard(context, time: hours, header: "HOURS"),
        SizedBox(width: size.width * 0.01),
        buildTimeCard(context, time: minutes, header: "MINUTES"),
        SizedBox(width: size.width * 0.01),
        buildTimeCard(context, time: seconds, header: "SECONDS"),
      ],
    );
  }

  Widget buildTimeCard(BuildContext context,
      {required String time, required String header}) {
    Size size = MediaQuery.of(context).size;
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Text(time,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 72))),
      SizedBox(height: size.height * 0.04),
      Text(header)
    ]);
  }

  Widget buildButtons(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = duration.inSeconds == 0;
    return isRunning || !isCompleted
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                text: isRunning ? 'STOP' : "RESUME",
                onClicked: () {
                  if (isRunning) {
                    stopTimer(resets: false);
                  } else {
                    startTimer(resets: false);
                  }
                },
              ),
              const SizedBox(width: 12),
              ButtonWidget(text: 'CANCEL', onClicked: stopTimer)
            ],
          )
        : ButtonWidget(
            text: 'START TIMER!',
            color: Colors.white,
            backgroundColor: Colors.black,
            onClicked: () {
              startTimer();
            });
  }
}
