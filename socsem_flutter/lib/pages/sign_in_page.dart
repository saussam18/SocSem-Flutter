import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:socsem_flutter/services/firebase_service.dart';
import 'package:socsem_flutter/utils/constants.dart' as Constants;
import 'package:socsem_flutter/utils/resource.dart';
import 'package:socsem_flutter/widgets/sign_in_button.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SigninPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SigninPage> {
  FirebaseService service = new FirebaseService();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isIos = Platform.isIOS;
  bool loading = true;

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
          SizedBox(height: size.height * .02),
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
          SizedBox(height: size.height * 0.02),
          buildGoogleOrAppleButton(context: context, size: size),
          SizedBox(height: size.height * .01),
          SignInButton(
              loginType: LoginType.Twitter,
              faIcon: FaIcon(FontAwesomeIcons.twitter)),
          SizedBox(height: size.height * 0.01),
          buildRowDivider(size: size),
          Padding(padding: EdgeInsets.only(bottom: size.height * 0.01)),
          buildEmailSignInForm(size: size, border: border)
        ])));
  }

  Widget buildGoogleOrAppleButton(
      {required BuildContext context, required Size size}) {
    return isIos
        ? SizedBox(
            width: size.width * 0.8,
            child: SignInWithAppleButton(
              onPressed: () async {
                service.signInWithApple();
              },
              height: size.height * 0.045,
              borderRadius: const BorderRadius.all(Radius.circular(3)),
            ))
        : SignInButton(
            faIcon: FaIcon(FontAwesomeIcons.google),
            loginType: LoginType.Google);
  }

  Widget buildEmailSignInForm(
      {required Size size, required OutlineInputBorder border}) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size.width * 0.8,
            child: TextFormField(
              style: const TextStyle(color: Constants.WHITE),
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: const TextStyle(color: Constants.WHITE),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                enabledBorder: border,
                focusedBorder: border,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Email Address';
                } else if (!value.contains('@')) {
                  return 'Please enter a valid email address!';
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          SizedBox(
            width: size.width * 0.8,
            child: TextFormField(
              style: const TextStyle(color: Constants.WHITE),
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: const TextStyle(color: Constants.WHITE),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
                enabledBorder: border,
                focusedBorder: border,
                suffixIcon: const Padding(
                  child: FaIcon(
                    FontAwesomeIcons.lock,
                    color: Constants.WHITE,
                    size: 15,
                  ),
                  padding: EdgeInsets.only(top: 15, left: 15),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Password';
                } else if (value.length < 6) {
                  return 'Password must be atleast 6 characters!';
                }
                return null;
              },
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: size.height * 0.01)),
          SizedBox(
            width: size.width * 0.8,
            child: loading
                ? OutlinedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          loading = false;
                        });
                        String? email = await service.signInWithEmail(
                            emailController.text, passwordController.text);
                        if (email != null) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, Constants.ROUTE_HOME, (route) => false);
                        }
                      }
                    },
                    child: const Text(Constants.SIGNIN),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Constants.BLACK),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Constants.SECONDARY),
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide.none)),
                  )
                : CircularProgressIndicator(),
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
        ],
      ),
    );
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
