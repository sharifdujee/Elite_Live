import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../utils/constants/app_urls.dart';

class GoogleSignInHelper {
  static final GoogleSignInHelper instance = GoogleSignInHelper._internal();

  GoogleSignInHelper._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /*Future<User?> signInWithGoogle() async {
    debugPrint("🔄 Initiating Google sign-in process...======>>>>>>>>");
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; // User cancelled
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

      if (user != null) {
        debugPrint(
          "✅ Google sign-in successful: ${user.displayName}, ${user.email}",
        );
        var userInfo = {
          'email': user.email ?? '',
          'firstName': user.displayName ?? '',
          'photoUrl': user.photoURL ?? '',
        };

        final response = await NetworkCaller().postRequest(AppUrls.googleAuth, body: userInfo);
        if (response.isSuccess) {
          
        } else {
          debugPrint("❌ Backend Google auth failed.");
        }
      }

      return user;
    } catch (e) {
      debugPrint("❌ Error during Google sign-in: $e");
      return null;
    }
  }*/

  Future<Map<String, dynamic>?> signInWithGoogle() async {
    debugPrint("🔄 Initiating Google sign-in process...======>>>>>>>>");
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User cancelled

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        debugPrint("✅ Google sign-in successful: ${user.displayName}, ${user.email}");

        // Return a simple map
        return {
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'photoUrl': user.photoURL ?? '',
        };
      }
    } catch (e) {
      debugPrint("❌ Error during Google sign-in: $e");
    }
    return null;
  }

}
