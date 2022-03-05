import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:socsem_flutter/utils/resource.dart';
import 'package:twitter_login/twitter_login.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String?> signInwithGoogle(
      [bool link = false, AuthCredential? authCredential]) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      if (link) {
        await linkProviders(userCredential, authCredential!);
      }
      return userCredential.user!.displayName;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<UserCredential?> linkProviders(
      UserCredential userCredential, AuthCredential newCredential) async {
    return await userCredential.user!.linkWithCredential(newCredential);
  }

  Future<Resource?> signInWithTwitter() async {
    final twitterLogin = TwitterLogin(
      apiKey: "9kpqApnItCH7wRWRVtQkRAbnD",
      apiSecretKey: "7ShIvnvOP8BtttijvG5Hj6dOptirAfV2PFZ1qi17dALcoejqGo",
      redirectURI: 'socsem-auth://',
    );
    final authResult = await twitterLogin.login();

    switch (authResult.status) {
      case TwitterLoginStatus.loggedIn:
        final AuthCredential twitterAuthCredential =
            TwitterAuthProvider.credential(
                accessToken: authResult.authToken!,
                secret: authResult.authTokenSecret!);
        final userCredential =
            await _auth.signInWithCredential(twitterAuthCredential);
        return Resource(status: Status.Success);
      case TwitterLoginStatus.cancelledByUser:
        return Resource(status: Status.Cancelled);
      case TwitterLoginStatus.error:
        return Resource(status: Status.Error);
      default:
        return null;
    }
  }

  Future<String?> signInWithEmail(String? email, String? password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      return userCredential.user!.email;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }
}
