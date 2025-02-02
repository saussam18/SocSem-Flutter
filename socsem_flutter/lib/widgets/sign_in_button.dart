import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:socsem_flutter/services/firebase_service.dart';
// ignore: library_prefixes
import 'package:socsem_flutter/utils/constants.dart' as Constants;
import 'package:socsem_flutter/utils/resource.dart';

class SignInButton extends StatefulWidget {
  final FaIcon faIcon;
  final LoginType loginType;
  final bool signin;

  const SignInButton(
      {Key? key,
      required this.faIcon,
      required this.loginType,
      required this.signin})
      : super(key: key);

  @override
  _SignInButtonState createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  bool isLoading = false;
  FirebaseService service = FirebaseService();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return !isLoading
        ? SizedBox(
            width: size.width * 0.8,
            child: OutlinedButton.icon(
              icon: widget.faIcon,
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await loginWithProviders();
                setState(() {
                  isLoading = false;
                });
              },
              label: widget.signin
                  ? Text(
                      widget.loginType == LoginType.Google
                          ? Constants.SIGNINGOOGLE
                          : Constants.SIGNINTWITTER,
                      style: const TextStyle(
                          color: Constants.BLACK, fontWeight: FontWeight.bold),
                    )
                  : Text(
                      widget.loginType == LoginType.Google
                          ? Constants.SIGNUPGOOGLE
                          : Constants.SIGNUPTWITTER,
                      style: const TextStyle(
                          color: Constants.BLACK, fontWeight: FontWeight.bold),
                    ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Constants.WHITE),
                  side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
            ),
          )
        : const CircularProgressIndicator();
  }

  void showMessage(FirebaseAuthException e) {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text(e.message!),
            actions: [
              TextButton(
                child: const Text("Ok"),
                onPressed: () async {
                  Navigator.of(builderContext).pop();
                  if (e.code == 'account-exists-with-different-credential') {
                    List<String> emailList = await FirebaseAuth.instance
                        .fetchSignInMethodsForEmail(e.email!);
                    if (emailList.first == "google.com") {
                      await service.signInwithGoogle(true, e.credential);
                      Navigator.pushNamedAndRemoveUntil(
                          context, Constants.ROUTE_HOME, (route) => false);
                    }
                  }
                },
              )
            ],
          );
        });
  }

  Future<void> loginWithProviders() async {
    String? displayName;
    Resource? result = Resource(status: Status.Error);
    try {
      switch (widget.loginType) {
        case LoginType.Google:
          displayName = (await service.signInwithGoogle());
          break;
        case LoginType.Twitter:
          result = await service.signInWithTwitter();
          break;
      }
      if (result!.status == Status.Success || displayName != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, Constants.ROUTE_HOME, (route) => false);
      }
    } on Exception catch (e) {
      if (e is FirebaseAuthException) {
        //print(e);
        showMessage(e);
      }
    }
  }
}
