import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/user.dart';

class UserService {
  final firebase_auth.FirebaseAuth _auth =
      firebase_auth.FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Map<String, dynamic> data = {};

  firebase_auth.User? get currentUser => _auth.currentUser;

  Stream<firebase_auth.User?> get authStateChanges =>
      _auth.authStateChanges();

  // ============================================================
  // FIREBASE AUTHENTICATION
  // ============================================================

  Future<firebase_auth.UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<firebase_auth.UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> updateUserDisplayName(String name) async {
    final firebase_auth.User? user = _auth.currentUser;

    if (user == null) return;

    await user.updateDisplayName(name);
  }

  Future<void> updatePassword(String password) async {
    final firebase_auth.User? user = _auth.currentUser;

    if (user == null) return;

    await user.updatePassword(password);
  }

  Future<void> updateUsername(String username) async {
    final firebase_auth.User? user = _auth.currentUser;

    if (user == null) return;

    await user.updateDisplayName(username.trim());
  }

  Future<void> deleteAccount(
    String email,
    String password,
  ) async {
    final firebase_auth.User? user = _auth.currentUser;

    if (user == null) return;

    final credential =
        firebase_auth.EmailAuthProvider.credential(
      email: email.trim(),
      password: password,
    );

    await user.reauthenticateWithCredential(credential);
    await user.delete();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  Future<void> updateUserPhotoUrl(String photoUrl) async {
    final firebase_auth.User? user = _auth.currentUser;

    if (user == null) return;

    await user.updatePhotoURL(photoUrl);
  }

  Future<void> reauthenticate(
    String email,
    String password,
  ) async {
    final firebase_auth.User? user = _auth.currentUser;

    if (user == null) return;

    final credential =
        firebase_auth.EmailAuthProvider.credential(
      email: email.trim(),
      password: password,
    );

    await user.reauthenticateWithCredential(credential);
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final firebase_auth.User? user = _auth.currentUser;

    if (user == null) return;

    final credential =
        firebase_auth.EmailAuthProvider.credential(
      email: user.email ?? '',
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);

    await user.updatePassword(newPassword);
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final firebase_auth.User? user = _auth.currentUser;

    if (user == null) return;

    final credential =
        firebase_auth.EmailAuthProvider.credential(
      email: user.email ?? '',
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);

    await user.updatePassword(newPassword);
  }

  Future<firebase_auth.UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // ============================================================
  // CREATE FIREBASE ACCOUNT
  // ============================================================

  Future<firebase_auth.UserCredential> createAccount({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String username,
    required String age,
    required String contactNo,
  }) async {
    final result =
        await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    if (result.user != null) {
      await result.user!.updateDisplayName(
        username.trim(),
      );
    }

    return result;
  }

  // ============================================================
  // FIRESTORE USER PROFILE
  // ============================================================

  Future<void> saveUserToFirestore({
    required String uid,
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    String image = '',
  }) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .set(
      {
        'uid': uid,
        'username': username,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'image': image,
        'createdAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  // ============================================================
  // GET ALL FIRESTORE USERS
  // Used by the Chat List
  // ============================================================

  Stream<QuerySnapshot<Map<String, dynamic>>>
      getFirestoreUsers() {
    return _firestore
        .collection('users')
        .orderBy('firstName')
        .snapshots();
  }

  // ============================================================
  // GET ONE FIRESTORE USER
  // ============================================================

  Future<DocumentSnapshot<Map<String, dynamic>>>
      getFirestoreUser(String uid) async {
    return await _firestore
        .collection('users')
        .doc(uid)
        .get();
  }

  // ============================================================
  // DUMMYJSON LOGIN
  // ============================================================

  Future<Map<String, dynamic>> loginUser(
    String username,
    String password,
  ) async {
    final response = await post(
      Uri.parse('$host/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': 60,
      }),
    );

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);

      await saveUserData(data);

      return data;
    } else {
      throw Exception(response.body);
    }
  }

  // ============================================================
  // SAVE USER DATA
  // ============================================================

  Future<void> saveUserData(
    Map<String, dynamic> userData,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final user = User.fromJson(userData);

    final firebaseUid =
        (userData['firebaseUid'] ??
                userData['uid'] ??
                '')
            .toString();

    final safeId =
        int.tryParse(
              userData['id']?.toString() ?? '',
            ) ??
            0;

    await prefs.setInt('id', safeId);
    await prefs.setString(
      'username',
      user.username,
    );
    await prefs.setString(
      'email',
      user.email,
    );
    await prefs.setString(
      'firstName',
      user.firstName,
    );
    await prefs.setString(
      'lastName',
      user.lastName,
    );
    await prefs.setString(
      'gender',
      user.gender,
    );
    await prefs.setString(
      'image',
      user.image,
    );
    await prefs.setString(
      'accessToken',
      user.accessToken,
    );
    await prefs.setString(
      'refreshToken',
      user.refreshToken,
    );
    await prefs.setString(
      'firebaseUid',
      firebaseUid,
    );

    await prefs.setString(
      'loginType',
      userData['loginType'] ?? 'dummyjson',
    );

    if (userData.containsKey('token')) {
      await prefs.setString(
        'token',
        userData['token'] ?? '',
      );
    } else if (user.accessToken.isNotEmpty) {
      await prefs.setString(
        'token',
        user.accessToken,
      );
    }
  }

  // ============================================================
  // GET SAVED USER DATA
  // ============================================================

  Future<Map<String, dynamic>> getUserData() async {
    final prefs =
        await SharedPreferences.getInstance();

    return {
      'id': prefs.getInt('id') ?? 0,
      'username':
          prefs.getString('username') ?? '',
      'email':
          prefs.getString('email') ?? '',
      'firstName':
          prefs.getString('firstName') ?? '',
      'lastName':
          prefs.getString('lastName') ?? '',
      'gender':
          prefs.getString('gender') ?? '',
      'image':
          prefs.getString('image') ?? '',
      'accessToken':
          prefs.getString('accessToken') ?? '',
      'refreshToken':
          prefs.getString('refreshToken') ?? '',
      'firebaseUid':
          prefs.getString('firebaseUid') ?? '',
      'token':
          prefs.getString('token') ??
          prefs.getString('accessToken') ??
          '',
      'loginType':
          prefs.getString('loginType') ??
          'dummyjson',
    };
  }

  // ============================================================
  // GET USER MODEL
  // ============================================================

  Future<User> getUser() async {
    final userData = await getUserData();

    return User.fromJson(userData);
  }

  // ============================================================
  // CHECK LOGIN
  // ============================================================

  Future<bool> isLoggedIn() async {
    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString('accessToken') ??
        prefs.getString('token');

    return token != null && token.isNotEmpty;
  }

  // ============================================================
  // GET BACKEND USER BY ID
  // ============================================================

  Future<Map<String, dynamic>> getUserById(
    int userId,
  ) async {
    final response = await get(
      Uri.parse('$host/users/$userId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> logout() async {
    try {
      await _auth.signOut();

      final prefs =
          await SharedPreferences.getInstance();

      await prefs.clear();
    } catch (e) {
      throw Exception(
        'Failed to log out: $e',
      );
    }
  }
}