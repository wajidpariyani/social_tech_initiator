import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_tech_initiator/src/utils/shared_prefs_utils.dart';

import '../../../routes.dart';
import '../../utils/utils.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState(isLogin: true));

  void toggleAuthMode() {
    emit(state.copyWith(
        isLogin: !state.isLogin, isFailure: false, isSuccess: false));
  }

  Future<void> authenticate(String email, String password,
      {String? username}) async {
    emit(state.copyWith(isLoading: true, isFailure: false, isSuccess: false));

    try {
      if (state.isLogin) {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } else {
        if (username == null || username.isEmpty) {
          emit(state.copyWith(
            isFailure: true,
            isLoading: false,
            failureMessage: "Username cannot be empty.",
          ));
          return;
        }

        bool isUsernameTaken = await checkIfUsernameExists(username);
        if (isUsernameTaken) {
          emit(state.copyWith(
            isFailure: true,
            isLoading: false,
            failureMessage: "Username is already taken. Try another.",
          ));
          return;
        }

        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        userCredential.user!.updateDisplayName(username);
        await storeUserInFireStore(username, email, userCredential.user!.uid);
      }

      SharedPrefsUtils.setBool("isLoggedIn", true);
      emit(state.copyWith(isSuccess: true, isLoading: false));
    } on FirebaseAuthException catch (e) {
      String errorMessage = handleFirebaseAuthError(e);
      emit(state.copyWith(
          isFailure: true, isLoading: false, failureMessage: errorMessage));
    } catch (e) {
      emit(state.copyWith(isFailure: true, isLoading: false));
      flutterPrint('An unexpected error occurred: $e');
    }
  }

  String? validateInput(String? value, String type) {
    if (value == null || value.isEmpty) return 'Please enter a $type';

    final regexMap = {
      'username': RegExp(r'^[a-zA-Z0-9_]{3,20}$'),
      'password': RegExp(
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'),
      'email': RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"),
    };

    return regexMap[type]?.hasMatch(value) == true
        ? null
        : 'Enter a valid $type';
  }

  CollectionReference get usersCollection =>
      FirebaseFirestore.instance.collection('users');

  Future<void> storeUserInFireStore(
      String username, String email, String uid) async {
    try {
      await usersCollection.doc(uid).set({
        'email': email,
        'uid': uid,
        'username': username,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      flutterPrint(e.toString());
    }
  }

  Future<bool> checkIfUsernameExists(String username) async {
    final querySnapshot = await usersCollection
        .where('username', isEqualTo: username)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  String handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return "No user found for that email.";
      case 'wrong-password':
      case 'invalid-credential':
        return "Wrong password provided/User not found.";
      case 'email-already-in-use':
        return "Email is already registered.";
      case 'weak-password':
        return "Password is too weak.";
      case 'too-many-requests':
        return "Too many attempts. Try again later.";
      case 'network-request-failed':
        return "No internet connection. Check your network.";
      case 'invalid-email':
        return "Enter a valid email address.";
      default:
        return e.message ?? "Authentication error occurred.";
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await SharedPrefsUtils.setBool('isLoggedIn', false);

      emit(AuthState(isLogin: true));

      Future.delayed(Duration.zero, () {
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.authScreen,
                (route) => false,
          );
        }
      });
    } catch (e) {
      flutterPrint("Logout failed: $e");
    }
  }
}
