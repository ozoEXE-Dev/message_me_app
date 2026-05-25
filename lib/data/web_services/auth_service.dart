import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  FirebaseAuth authService = FirebaseAuth.instance;

  Future signInWithEmailAndPassword(String email, String password) async {
    await authService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future signOut() async {
    await authService.signOut();
  }

  Future signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;

    googleSignIn.initialize(
      serverClientId:
          "your serverClientId. i didn't put mine because of security",
    );

    final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();

    if (googleUser == null) {
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    await authService.signInWithCredential(credential);
  }

  Future signUp(String email, String password) async {
    await authService.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future sendPasswordResetEmail(String email) async {
    await authService.sendPasswordResetEmail(email: email);
  }

  Future<bool> isUserVerified() async {
    return authService.currentUser != null &&
        authService.currentUser!.emailVerified;
  }

  Future sendEmailVerification() async {
    await authService.currentUser!.sendEmailVerification();
  }

  String getCurrentUserEmail() {
    return authService.currentUser!.email!;
  }

  String getCurrentUserUID() {
    return authService.currentUser!.uid;
  }

  Future<bool> isUserProfileCompleted() async {
    if (authService.currentUser == null) {
      return false;
    }
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(authService.currentUser!.uid)
        .get();
    return doc.exists;
  }
}
