import 'package:flutter/material.dart';
import 'package:socsem_flutter/pages/leave_feedback_page.dart';
import 'package:socsem_flutter/pages/reading_log_page.dart';
import 'package:socsem_flutter/pages/reading_timer_page.dart';
import 'package:socsem_flutter/pages/sign_in_page.dart';
import 'package:socsem_flutter/pages/welcome_page.dart';

class Navigate {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => WelcomePage(),
    '/sign-in': (context) => SigninPage(),
    '/home': (context) => ReadingTimerPage(),
    '/log': (context) => ReadingLogPage(),
    '/feedback': (context) => LeaveFeedbackPage()
  };
}
