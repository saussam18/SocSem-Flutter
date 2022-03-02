import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:socsem_flutter/services/firebase_service.dart';
import 'package:socsem_flutter/utils/constants.dart' as Constants;
import 'package:socsem_flutter/utils/resource.dart';
import 'package:socsem_flutter/widgets/sign_in_button.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    OutlineInputBorder border = const OutlineInputBorder(
        borderSide: BorderSide(color: Constants.WHITE, width: 3.0));
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Constants.PRIMARY,
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('assets/images/logo.png'),
          RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(children: <TextSpan>[
                TextSpan(
                    text: Constants.SIGNINTITLE,
                    style: TextStyle(
                      color: Constants.WHITE,
                      fontWeight: FontWeight.bold,
                      fontSize: 26.0,
                    )),
              ])),
          SizedBox(height: size.height * 0.01),
          const Text(
            Constants.SIGNINSUBTITLE,
            style: TextStyle(color: Constants.WHITE),
          ),
          SizedBox(height: size.height * 0.01),
          SignInButton(
              loginType: LoginType.Google,
              faIcon: FaIcon(FontAwesomeIcons.google)),
          SignInButton(
              loginType: LoginType.Twitter,
              faIcon: FaIcon(FontAwesomeIcons.twitter)),
          SizedBox(height: size.height * 0.01),
          buildRowDivider(size: size),
          Padding(padding: EdgeInsets.only(bottom: size.height * 0.01)),
          SizedBox(
            width: size.width * 0.8,
            child: TextField(
                style: const TextStyle(color: Constants.WHITE),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: const TextStyle(color: Constants.WHITE),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                  enabledBorder: border,
                  focusedBorder: border,
                )),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          SizedBox(
            width: size.width * 0.8,
            child: TextField(
              style: const TextStyle(color: Constants.WHITE),
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: const TextStyle(color: Constants.WHITE),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
                enabledBorder: border,
                focusedBorder: border,
                suffixIcon: const Padding(
                  child: FaIcon(
                    FontAwesomeIcons.eye,
                    color: Constants.WHITE,
                    size: 15,
                  ),
                  padding: EdgeInsets.only(top: 15, left: 15),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: size.height * 0.01)),
          SizedBox(
            width: size.width * 0.8,
            child: OutlinedButton(
              onPressed: () async {},
              child: const Text(Constants.SIGNIN),
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Constants.BLACK),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Constants.SECONDARY),
                  side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
            ),
          ),
          RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: Constants.SIGNINREDIRECT,
                      style: TextStyle(
                        color: Constants.WHITE,
                      )),
                  TextSpan(
                      text: Constants.SIGNINREDIRECTSIGNUP,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.SECONDARY,
                      )),
                ],
              ))
        ])));
  }

  Widget buildRowDivider({required Size size}) {
    return SizedBox(
      width: size.width * 0.8,
      child: Row(children: <Widget>[
        Expanded(child: Divider(color: Constants.WHITE)),
        Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: Text(
              "Or",
              style: TextStyle(color: Constants.WHITE),
            )),
        Expanded(child: Divider(color: Constants.WHITE)),
      ]),
    );
  }
}
