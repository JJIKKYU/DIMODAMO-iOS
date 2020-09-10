import 'package:flutter/material.dart';
import 'package:bmi_calculator/constants.dart';

class genderChild extends StatelessWidget {
  final String gender;
  final IconData genderIcon;

  genderChild({this.gender, this.genderIcon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          genderIcon,
          size: kIconSize,
        ),
        SizedBox(
          height: kSizedBoxHeight,
        ),
        Text('$gender', style: kTextStyle),
      ],
    );
  }
}
