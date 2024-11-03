import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/screens/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
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
    _logoAnimation = CurvedAnimation(parent: _logoController, curve: Curves.easeIn);

    // Text animation
    _textController = AnimationController(
      vsync: this,
      duration:const Duration(seconds: 1),
    );
    _textAnimation = CurvedAnimation(parent: _textController, curve: Curves.easeIn);

    // Start the animations
    _logoController.forward().then((_) {
      _textController.forward();
    });

    // Navigate to the home screen after a delay
    Timer( const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    });
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
      backgroundColor: Colors.white, // Main color of the app
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _logoAnimation,
              child: Image.asset(
                'assets/images/logo.png', // Add your logo in the assets
                height: 120, // Adjust size based on your logo
              ),
            ),
           const SizedBox(height: 20),
            FadeTransition(
              opacity: _textAnimation,
              child: const Text(
                'Réservation de Billet',
                style:  TextStyle(
                  color: bleu,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
           const SizedBox(height: 15),
            FadeTransition(
              opacity: _textAnimation,
              child: const Text(
                'chez DjaamYadee',
                style:  TextStyle(
                  color: bleu,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


 
}