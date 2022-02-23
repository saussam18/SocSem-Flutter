import 'package:flutter/material.dart';
import 'package:socsem_flutter/pages/reading_timer_page.dart';
import 'package:socsem_flutter/pages/welcome_page.dart';

class Navigate {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => ReadingTimerPage(),
    //'/sign-in': (context) => SignInPage(),
    '/home': (context) => ReadingTimerPage()
  };
}
