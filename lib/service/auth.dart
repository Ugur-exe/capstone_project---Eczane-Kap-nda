import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// * Giriş yapmak için kullanıcı adı ve şifre ile giriş yapar.
  Future<User> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
      } else if (e.code == 'wrong-password') {}
      return Future.error(e);
    }
  }

  /// * Kullanıcıyı kaydeder.
  Future<User> createPerson(
    String name,
    String surname,
    int tc,
    String email,
    String password,
    List address,
    double latitude,
    double longitude,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await _firestore.collection('users').doc(userCredential.user!.email).set({
        'name': name,
        'surname': surname,
        'tc': tc,
        'email': email,
        'password': password,
        'address': address,
        'latitude': latitude,
        'longitude': longitude
      });
      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
      } else if (e.code == 'email-already-in-use') {}
      return Future.error(e);
    }
  }

  signOut() async {
    await _auth.signOut();
  }
}
