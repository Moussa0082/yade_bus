import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/screens/login/login.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
              child: Container(
                padding: const EdgeInsets.all(
                    20), // Ajouter un padding pour l'espace autour du contenu

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/security.png",
                        width: 200,
                        height:
                            200), // Ajuster la taille de l'image selon vos besoins
                    const SizedBox(
                        height:
                            20), // Ajouter un espace entre l'image et le texte
                    const Text(
                      "Vous devez vous connecter pour effectuer des tâche en tant qu'agent",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                        height:
                            20), // Ajouter un espace entre le texte et le bouton
                    ElevatedButton(
                      onPressed: () {
                        Future.microtask(() {});
                        Get.to(LoginPage(),
                            duration: const Duration(
                                seconds:
                                    1), //duration of transitions, default 1 sec
                            transition: Transition.leftToRight);
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            Colors.transparent),
                        elevation: WidgetStateProperty.all<double>(
                            0), // Supprimer l'élévation du bouton
                        overlayColor: WidgetStateProperty.all<Color>(
                            Colors.grey.withOpacity(
                                0.2)), // Couleur de l'overlay du bouton lorsqu'il est pressé
                        shape:
                            WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(
                                color: bleuFoncer), // Bordure autour du bouton
                          ),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          "Se connecter",
                          style: TextStyle(fontSize: 16, color: bleuFoncer),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}