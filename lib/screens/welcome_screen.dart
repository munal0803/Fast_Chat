import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'login_screen.dart';
import 'login_screen.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'Welcome_Screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  AnimationController controller;
  Animation animation;
  @override
  void initState()
  {
    super.initState();
    controller=AnimationController(
   duration: Duration(seconds:4),
      vsync:this,

    );
    animation = CurvedAnimation(parent:controller,curve: Curves.elasticInOut);
    animation=ColorTween(begin:Colors.white,end:Colors.greenAccent).animate(controller);

    controller.forward();
    // animation.addStatusListener((status) {
    //   if(status==AnimationStatus.completed){
    //     controller.reverse(from:1.0);
    //   }else if(status==AnimationStatus.dismissed){
    //     controller.forward();
    //   }
    // });



    controller.addListener(() {
   setState(() {

   });
    });

  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag:'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height:60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text:['Flash Chat'],

                  textStyle: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                elevation: 5.0,
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: () {
                    //Go to login screen.
                   Navigator.pushNamed(context,LoginScreen.id );
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Log In',style: TextStyle(
                    color: Colors.white,
                  ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30.0),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () {
                    //Go to registration screen.
                  Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Register',style: TextStyle(
                    color: Colors.white,
                  ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
