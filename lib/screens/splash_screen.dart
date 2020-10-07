import 'package:flutter/material.dart';

import 'root page/root_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
      
  //create ref to animation controller
  AnimationController _splashScreenAnimationController;

  //create ref to animation
  Animation<double> _splashScreenFadeAnimation;

  @override
  void initState() {
    super.initState();

    //defined animation controller
    _splashScreenAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 4000));

    //defined tween animation
    _splashScreenFadeAnimation = Tween<double>(begin: 0, end: 1)
        .animate(_splashScreenAnimationController);

    //start splash animation
    _splashScreenAnimationController.forward();
    navigateToRootPage();
  }

  //navigate to root page
  Future<bool> navigateToRootPage() async {
    await Future.delayed(Duration(milliseconds: 5000));
    return Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) {
      return RootPage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FadeTransition(
          opacity: _splashScreenFadeAnimation,
          child: Image.asset("assets/images/splash_screen/splashScreen.png")),
    );
  }
}
