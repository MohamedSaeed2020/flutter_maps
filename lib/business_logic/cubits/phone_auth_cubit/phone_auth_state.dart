part of 'phone_auth_cubit.dart';

@immutable
abstract class PhoneAuthState {}

class PhoneAuthInitialState extends PhoneAuthState {}
class PhoneAuthLoadingState extends PhoneAuthState {}
class PhoneAuthNumberSubmittedState extends PhoneAuthState {
  final String phoneNumber;

  PhoneAuthNumberSubmittedState(this.phoneNumber);
}
class PhoneAuthErrorState extends PhoneAuthState {
  final String error;

  PhoneAuthErrorState(this.error);
}
class PhoneAuthOtpVerifiedState extends PhoneAuthState {}
