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
      Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            child: const IntroPage(),
            inheritTheme: true,
            ctx: context),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Image.asset(
            splashImage,
            fit: BoxFit.fitHeight,
            height: double.infinity,
          ),
          FadeInLeft(
            duration: Duration(milliseconds: kDurationSplash * 2 ~/ 3),
            child: Align(
              alignment: const Alignment(-0.9, -0.9),
              child: Image.asset(
                researchLogo,
                fit: BoxFit.contain,
                height: MediaQuery.of(context).size.height * 0.1,
              ),
            ),
          ),
          FadeInRight(
            duration: Duration(milliseconds: kDurationSplash * 2 ~/ 3),
            child: Align(
              alignment: const Alignment(1, 1),
              child: Image.asset(
                redimecLogo,
                fit: BoxFit.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
