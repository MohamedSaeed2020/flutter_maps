import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  //variables
  late String verificationId;
  late String phoneNumber;

  PhoneAuthCubit() : super(PhoneAuthInitialState());

  Future<void> submitPhoneNumber(String phoneNumber) async {
    this.phoneNumber=phoneNumber;
    emit(PhoneAuthLoadingState());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2$phoneNumber',
      timeout: const Duration(seconds: 30),
      codeSent: codeSent,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }
  void codeSent(String verificationId, int? resendToken) {
    debugPrint('codeSent');
    this.verificationId = verificationId;
    emit(PhoneAuthNumberSubmittedState(phoneNumber));
  }
  Future<void> verificationCompleted(PhoneAuthCredential credential) async {
    debugPrint('verificationCompleted');
    await signIn(credential);
  }
  void codeAutoRetrievalTimeout(String verificationId) {
    debugPrint('codeAutoRetrievalTimeout');
  }
  void verificationFailed(FirebaseAuthException error) {
    emit(PhoneAuthErrorState(error.toString()));
    debugPrint('verificationFailed: ${error.toString()}');
  }
  submitOtp(String otpCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otpCode,
    );
    await signIn(credential);
  }
  Future<void> signIn(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(PhoneAuthOtpVerifiedState());
    } catch (error) {
      emit(PhoneAuthErrorState(error.toString()));
    }
  }
  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }
  User? getUserInfo(){
    User? user=FirebaseAuth.instance.currentUser;
    return user;
  }
}
