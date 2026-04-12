import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/provider/AuthProvider.dart';
import 'package:yade_bus/screens/accueil.dart';
import 'package:yade_bus/screens/home.dart';
import 'package:yade_bus/screens/new_accueil.dart';
import 'package:yade_bus/widgets/nav_bar.dart';

import 'agent/agent_home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;
  late AnimationController _textController;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    // Logo animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _logoAnimation =
        CurvedAnimation(parent: _logoController, curve: Curves.easeIn);

    // Text animation
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _textAnimation =
        CurvedAnimation(parent: _textController, curve: Curves.easeIn);

    // Start the animations
    _logoController.forward().then((_) {
      _textController.forward();
    });

    checkFirstSeen();
  }

  Future checkFirstSeen() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.loadUserFromPrefs();

    if (auth.user != null) {
      Timer(const Duration(seconds: 2), () {
        Get.off(const AgentMainPage(), transition: Transition.leftToRight);
      });
    } else {
      Timer(const Duration(seconds: 2), () {
        Get.off(const BookingScreen(), transition: Transition.leftToRight);
        // Get.off(const NewAccueil(), transition: Transition.leftToRight);
        // Get.off(const Accueil(), transition: Transition.leftToRight);
      });
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/homebg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // FadeTransition(
          //   opacity: _logoAnimation,
          //   child: Image.asset(
          //     'assets/images/logo.png', // Add your logo in the assets
          //     height: 120, // Adjust size based on your logo
          //   ),
          // ),
          // const SizedBox(height: 20),
          // FadeTransition(
          //   opacity: _textAnimation,
          //   child: const Text(
          //     'Réservation de Billet',
          //     style: TextStyle(
          //       color: blanc,
          //       fontSize: 24,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 15),
          // FadeTransition(
          //   opacity: _textAnimation,
          //   child: const Text(
          //     'chez Yade',
          //     style: TextStyle(
          //       color: blanc,
          //       fontSize: 24,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
