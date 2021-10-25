import 'package:aishop/providers/verification_provider.dart';
import 'package:aishop/styles/theme.dart';
import 'package:aishop/widgets/appbar/appbar.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    contxt = context;
    final VerificationProvider verficationProvider =
        Provider.of<VerificationProvider>(context);
    return Center(
      child: Container(
        color: lightblack,
        child: DefaultTextStyle(
          style: const TextStyle(fontSize: 40.0, color: white),
          child: AnimatedTextKit(
            animatedTexts: [
              WavyAnimatedText('Please check email for verification link'),
            ],
            isRepeatingAnimation: true,
            onTap: () {
              print("Tap Event");
            },
          ),
        ),
      ),
    );
  }
}
