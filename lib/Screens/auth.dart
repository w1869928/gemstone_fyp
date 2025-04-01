import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gemstone_fyp/Screens/login_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'HomePage.dart';

class Auth {
  final FirebaseAuth _firebaseAuth;

  Auth({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut(context) async {
    await _firebaseAuth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()),);
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Google Sign-In canceled"))
        );
        return;
      }
      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      final fireStore = FirebaseFirestore.instance;
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        FirebaseAuth.instance.authStateChanges().listen((User? user) async {
          final userDoc = fireStore.collection('Users').doc(user?.uid);
          final userSnapshot = await userDoc.get();

          if (!userSnapshot.exists) {
            await userDoc.set({
              'id': user?.uid,
              'name': gUser.displayName ?? 'Unknown',
              'email': user?.email ?? '',
              'lastLogin': DateTime.now().toIso8601String(),
              'createdAt': DateTime.now().toIso8601String(),
            });
          } else {
            await userDoc.update({
              'lastLogin': DateTime.now().toIso8601String(),
            });
          }
        });
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-in failed: ${e.message}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }
}