import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_home/models/user.dart';

class AuthService {
  late int ch;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Users? _userFormFirebaseUser(auth.User? user) {
    return user != null ? Users(uid: user.uid, email: user.email) : null;
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
    } catch (e) {}
  }

  Stream<Users?>? get user {
    return _auth.authStateChanges().map((_userFormFirebaseUser));
  }

  Future<Users?> signInwithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFormFirebaseUser(credential.user);
    } on auth.FirebaseAuthException catch (e) {
      print('this is error:$e');
      return null;
    }
  }

  Future<Users?> CreateUserwithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return _userFormFirebaseUser(credential.user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
