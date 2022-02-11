import 'package:flutter/material.dart';
import 'package:flutter_maps/shared/constants/colors.dart';

class OtpVerificationIntoText extends StatelessWidget {
  final String phoneNumber;
  const OtpVerificationIntoText({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verify your phone number',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 2.0,
          ),
          child: RichText(
            text: TextSpan(
              text: 'Enter your 6 digits code numbers sent to you at ',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: phoneNumber,
                  style: const TextStyle(
                    color: MyColors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
