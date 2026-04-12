import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/provider/AuthProvider.dart';

import '../agent/agent_home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Color myColor;
  late Size mediaSize;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberUser = false;

  @override
  Widget build(BuildContext context) {
    myColor = bleu;
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: myColor,
        image: DecorationImage(
          image: const AssetImage("assets/images/gr-p.png"),
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(myColor.withOpacity(0.2), BlendMode.dstATop),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Positioned(top: 80, child: _buildTop()),
          Positioned(bottom: 0, child: _buildBottom()),
        ]),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on_sharp,
            size: 100,
            color: Colors.white,
          ),
          Text(
            "YADE",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 40,
                letterSpacing: 2),
          )
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bienvenue",
          style: TextStyle(
              color: myColor, fontSize: 32, fontWeight: FontWeight.w500),
        ),
        _buildGreyText("Connectez vous avec vos identifiants"),
        const SizedBox(height: 60),
        _buildGreyText("Email"),
        _buildInputField(emailController),
        const SizedBox(height: 20),
        _buildGreyText("Password"),
        _buildInputField(passwordController, isPassword: true),
        const SizedBox(height: 10),
        _buildRememberForgot(),
        const SizedBox(height: 10),
        _buildLoginButton(),
        // const SizedBox(height: 20),
        // _buildOtherLogin(),
      ],
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _buildInputField(TextEditingController controller,
      {bool isPassword = false, bool obscureText = true}) {
    return StatefulBuilder(
      builder: (context, StateSetter setState) {
        // Variable pour gérer l'affichage ou le masquage du texte

        return TextField(
          controller: controller,
          decoration: InputDecoration(
            suffixIcon: isPassword
                ? GestureDetector(
                    onTap: () {
                      // Alterner l'état d'affichage du mot de passe
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    child: Icon(
                      !obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                  )
                : Icon(Icons
                    .done), // Icône différent si ce n'est pas un mot de passe
            labelText:
                isPassword ? 'Mot de passe' : 'Email', // Exemple d'étiquette
          ),
          obscureText: isPassword
              ? obscureText
              : isPassword, // Masquer le texte pour les champs de mot de passe
        );
      },
    );
  }

  Widget _buildRememberForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
                value: rememberUser,
                onChanged: (value) {
                  setState(() {
                    rememberUser = value!;
                  });
                }),
            _buildGreyText("Se souvenir de moi"),
          ],
        ),
        // TextButton(
        //     onPressed: () {}, child: _buildGreyText("Mot de pass oublié"))
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () async{
       final auth = Provider.of<AuthProvider>(context, listen: false);

try {
  await auth.login(emailController.text, passwordController.text);

  // Vérifie si un utilisateur est connecté (login réussi)
  if (auth.user != null) {
    Get.offAll(() => AgentMainPage());

    debugPrint("Email : ${emailController.text}");
    debugPrint("Password : ${passwordController.text}");
    print("Bienvenue ${auth.user?.prenom}");
  } else {
    print("Login échoué : utilisateur introuvable.");
  }
  } catch (e) {
    print("Erreur : $e");
  }
   
      },
      style: ElevatedButton.styleFrom(
        // shape: const StadiumBorder(),
        elevation: 20,
        // shadowColor: myColor,
        minimumSize: const Size.fromHeight(60),
      ),
      child: const Text("Connexion"),
    );
  }

  Widget _buildOtherLogin() {
    return Center(
      child: Column(
        children: [
          _buildGreyText("Or Login with"),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Tab(icon: Image.asset("assets/images/facebook.png")),
              Tab(icon: Image.asset("assets/images/twitter.png")),
              Tab(icon: Image.asset("assets/images/github.png")),
            ],
          )
        ],
      ),
    );
  }
}
