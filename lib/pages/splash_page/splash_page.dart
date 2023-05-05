import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tmra/constants.dart';
import 'package:tmra/pages/intro_page/intro_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: kDurationSplash), () {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => const IntroPage()), (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    double dg =
        sqrt((widthScreen * widthScreen) + (heightScreen * heightScreen));
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Image.asset(
            splashImage,
            fit: BoxFit.fitHeight,
            height: double.infinity,
          ),
          FadeInUpBig(
            duration: Duration(milliseconds: kDurationSplash * 2 ~/ 3),
            child: Align(
              alignment: const Alignment(0, -0.3),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
                child: Image.asset(
                  ihredaLogo,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          FadeInRight(
            duration: Duration(milliseconds: kDurationSplash * 2 ~/ 3),
            child: Align(
              alignment: const Alignment(1, 1),
              child: SizedBox(
                height: dg * 0.12,
                width: double.infinity,
                child: Image.asset(
                  redimecLogo,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
