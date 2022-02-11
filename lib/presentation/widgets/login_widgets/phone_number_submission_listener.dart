import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/business_logic/cubits/phone_auth_cubit/phone_auth_cubit.dart';
import 'package:flutter_maps/presentation/widgets/progress_indicator.dart';
import 'package:flutter_maps/shared/constants/strings.dart';

class PhoneNumberSubmissionListener extends StatelessWidget {
  const PhoneNumberSubmissionListener({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listenWhen: (previousState, currentState) {
        return previousState != currentState;
      },
      listener: (context, state) {
        if (state is PhoneAuthLoadingState) {
          ShowProgressIndicator.showProgressIndicator(context);
        }
        if (state is PhoneAuthNumberSubmittedState) {
          Navigator.pop(context);
          Navigator.of(context)
              .pushReplacementNamed(otpScreen, arguments: state.phoneNumber);
        }
        if (state is PhoneAuthErrorState) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.black,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Container(),
    );
  }
}
