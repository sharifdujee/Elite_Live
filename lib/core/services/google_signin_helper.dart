import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInHelper {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) return null;

      // final GoogleSignInAuthentication auth = await account.authentication;

      return {
        'name': account.displayName,
        'email': account.email,
        'photoUrl': account.photoUrl
      };
    } catch (e) {
      return null;
    }
  }
}
