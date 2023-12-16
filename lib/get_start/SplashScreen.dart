import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enlighten/Get_Start/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Home/HomePage.dart';
import 'first_time/SelectCategories.dart';


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var user_preferences = [];

  @override
  void initState() {
    super.initState();
    user_preferences.clear();
    print("user_preferences 1:${user_preferences}");
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
      splash: 'assets/Logos/logo.png',
      screenFunction: () async {
        String? value;
        final User? user = _firebaseAuth.currentUser;

        if (user != null) {
          final uid = user.uid;
          final DocumentSnapshot ds =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
         setState(() {
           value = (ds.data() as Map<String, dynamic>)['user state'];
           user_preferences = (ds.data() as Map<String, dynamic>)['user preferences'] ?? [];
         });
          print("user_preferences 2:${user_preferences}");
          if (value == 'new' || user_preferences.isEmpty) {
            return SelectCategories(id: 0, user_preferences: user_preferences,);
          } else if (value == 'old' && user_preferences.isNotEmpty) {
            return HomePage(user_preferences: user_preferences,);
          }
        }

        return welcome();
      },
      backgroundColor: HexColor('#ffffff'),
      splashTransition: SplashTransition.scaleTransition,
    );
  }
}
