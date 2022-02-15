import 'dart:async';

import 'package:flutter/material.dart';
import 'package:socsem_flutter/widgets/button_widget.dart';

class ReadingTimerPage extends StatefulWidget {
  @override
  _ReadingTimerPageState createState() => _ReadingTimerPageState();
}

class _ReadingTimerPageState extends State<ReadingTimerPage> {
  Duration duration = Duration();
  Timer? timer;

  @override
  void initState() {
    super.initState();

    reset();
  }

  void reset() {
    setState(() => duration = Duration());
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }

    setState(() {
      timer?.cancel();
    });
  }

  void addTime() {
    final addSeconds = 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  void startTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(children: [
          const SizedBox(height: 200),
          buildTime(),
          const SizedBox(height: 80),
          buildButtons()
        ]),
      );

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours.remainder(60));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimeCard(time: hours, header: "HOURS"),
        const SizedBox(width: 8),
        buildTimeCard(time: minutes, header: "MINUTES"),
        const SizedBox(width: 8),
        buildTimeCard(time: seconds, header: "SECONDS"),
      ],
    );
  }

  Widget buildTimeCard({required String time, required String header}) =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Text(time,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 72))),
        const SizedBox(height: 24),
        Text(header)
      ]);

  Widget buildButtons() {
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
