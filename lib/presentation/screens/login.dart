import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/business_logic/cubits/phone_auth_cubit/phone_auth_cubit.dart';
import 'package:flutter_maps/presentation/widgets/login_widgets/country_flag_generation.dart';
import 'package:flutter_maps/presentation/widgets/login_widgets/phone_number_submission_listener.dart';
import 'package:flutter_maps/presentation/widgets/login_widgets/phone_text_into.dart';
import 'package:flutter_maps/presentation/widgets/progress_indicator.dart';
import 'package:flutter_maps/shared/constants/colors.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  //variables
   String? phoneNumber;
  final GlobalKey<FormState> _phoneFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _phoneFormKey,
            child: Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 88.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PhoneIntroText(),
                  const SizedBox(
                    height: 110.0,
                  ),
                   _buildPhoneNumberField(),
                  const SizedBox(
                    height: 80.0,
                  ),
                  _buildNextButton(context),
                   const PhoneNumberSubmissionListener(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildPhoneNumberField() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 4.0,
              vertical: 16.0,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: MyColors.lightGrey,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(
                  6.0,
                ),
              ),
            ),
            child: Text(
              CountryFlagGeneration.generateCountryFlag() + ' +2',
              style:
              const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(
          width: 16.0,
        ),
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 2.0,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: MyColors.blue,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(
                  6.0,
                ),
              ),
            ),
            child: TextFormField(
              autofocus: true,
              style: const TextStyle(
                  fontSize: 18.0,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              cursorColor: Colors.black,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your phone number!';
                } else if (value.length < 11) {
                  return 'The number you entered is too short!';
                }
                return null;
              },
              onSaved: (value) {
                phoneNumber = value!;
              },
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildNextButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          ShowProgressIndicator.showProgressIndicator(context);
          register(context);
        },
        child: const Text(
          'Next',
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
  //save user number to firebase to send him OTP code
  void register(BuildContext context){
    if(!_phoneFormKey.currentState!.validate()){
      Navigator.pop(context);
    }else{
      Navigator.pop(context);
      _phoneFormKey.currentState!.save();
      BlocProvider.of<PhoneAuthCubit>(context).submitPhoneNumber(phoneNumber!);


    }
  }

}
