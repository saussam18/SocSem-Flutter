import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: library_prefixes
import 'package:socsem_flutter/utils/constants.dart' as Constants;

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    User? result = FirebaseAuth.instance.currentUser;
    return Scaffold(
        backgroundColor: Constants.PRIMARY,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: Constants.STATUS_BAR_COLOR,
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Image.asset('assets/images/logo.png'),
                  RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: Constants.INTRO1,
                            style: TextStyle(
                              color: Constants.WHITE,
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0,
                            )),
                        TextSpan(
                            text: Constants.INTROEMPHASIS,
                            style: TextStyle(
                                color: Constants.SECONDARY,
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0)),
                        TextSpan(
                            text: Constants.INTRO2,
                            style: TextStyle(
                                color: Constants.WHITE,
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0)),
                      ])),
                  SizedBox(height: size.height * 0.01),
                  const Text(
                    Constants.INTROSUB,
                    style: TextStyle(color: Constants.WHITE),
                  ),
                  SizedBox(height: size.height * 0.1),
                  SizedBox(
                    width: size.width * 0.8,
                    child: OutlinedButton(
                      onPressed: () {
                        result == null
                            ? Navigator.pushNamed(
                                context, Constants.ROUTE_SIGNIN)
                            : Navigator.pushReplacementNamed(
                                context, Constants.ROUTE_HOME);
                      },
                      child: Text(Constants.START),
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Constants.SECONDARY),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Constants.WHITE),
                          side: MaterialStateProperty.all<BorderSide>(
                              BorderSide.none)),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.8,
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text(
                        Constants.SIGNIN,
                        style: TextStyle(color: Constants.BLACK),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Constants.WHITE),
                          side: MaterialStateProperty.all<BorderSide>(
                              BorderSide.none)),
                    ),
                  )
                ]))));
  }
}
