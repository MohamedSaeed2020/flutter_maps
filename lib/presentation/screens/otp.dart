import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/business_logic/cubits/phone_auth_cubit/phone_auth_cubit.dart';
import 'package:flutter_maps/presentation/widgets/otp_widgets/otp_verification_into_text.dart';
import 'package:flutter_maps/presentation/widgets/otp_widgets/phone_number_verification_listener.dart';
import 'package:flutter_maps/presentation/widgets/progress_indicator.dart';
import 'package:flutter_maps/shared/constants/colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

// ignore: must_be_immutable
class OtpScreen extends StatelessWidget {
  final String phoneNumber;
  late String otpCode;


   OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 88.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OtpVerificationIntoText(phoneNumber:phoneNumber),
                const SizedBox(
                  height: 88.0,
                ),
                pinCodeTextFieldGeneration(context),
                const SizedBox(
                  height: 60.0,
                ),
                verificationButton(context),
                const PhoneNumberVerificationListener(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget pinCodeTextFieldGeneration(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      onChanged: (String code) {
        debugPrint('Changed: $code');
      },
      onCompleted: (String submittedCode) {
        otpCode = submittedCode;
        debugPrint('Completed otpCode: $otpCode');
      },
      beforeTextPaste: (String? text) {
        debugPrint('Text Pasted: $text');
        return false;
      },
      obscureText: false,
      autoFocus: true,
      cursorColor: Colors.black,
      keyboardType: TextInputType.phone,
      animationType: AnimationType.scale,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5.0),
        fieldHeight: 50.0,
        fieldWidth: 40.0,
        borderWidth: 1.0,
        activeFillColor: MyColors.lightBlue,
        inactiveFillColor: Colors.white,
        selectedFillColor: Colors.white,
        activeColor: MyColors.blue,
        inactiveColor: MyColors.blue,
        selectedColor: MyColors.blue,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.white,
      enableActiveFill: true,
    );
  }
  Widget verificationButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          ShowProgressIndicator.showProgressIndicator(context);
          _login(context);
        },
        child: const Text(
          'Verify',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        style: ElevatedButton.styleFrom(
          maximumSize: const Size(110, 50),
          primary: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              6.0,
            ),
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context) {
    BlocProvider.of<PhoneAuthCubit>(context).submitOtp(otpCode);
  }


}
