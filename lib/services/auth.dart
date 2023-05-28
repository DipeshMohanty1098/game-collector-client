import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_collector/services/firebaseservice.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:developer';

class AuthService {
  final FirebaseAuth _auth;
  AuthService(this._auth);

  Stream<User> get authState => _auth.authStateChanges();

  Future<User> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication?.idToken,
        accessToken: googleSignInAuthentication?.accessToken);

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = await _auth.currentUser;
    assert(currentUser.uid == user.uid);

    final FirebaseService fbService = FirebaseService(firebaseUser: user);

    await fbService.registerUser(user.uid);

    return user;
  }

  Future signOutGoogle() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.remove('token');
    await _auth.signOut();
  }
}
