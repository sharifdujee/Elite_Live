import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInHelper {
  // final GoogleSignIn _googleSignIn = GoogleSignIn(
  //   scopes: [
  //     'email',
  //     'profile',
  //   ],
  // );

  // Future<Map<String, dynamic>?> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? account = await _googleSignIn.signIn();
  //     if (account == null) return null;

  //     // final GoogleSignInAuthentication auth = await account.authentication;

  //     return {
  //       'name': account.displayName,
  //       'email': account.email,
  //       'photoUrl': account.photoUrl
  //     };
  //   } catch (e) {
  //     return null;
  //   }
  // }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;
      if (user!= null){
        debugPrint("Google sign-in successful=========>>>>>>: ${user.displayName}, ${user.email}");

      }

      return user;
    } catch (e) {
      debugPrint("Error during Google sign-in: $e");
      return null;
    }
  }
}
