import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/moniteur.dart';
import '../services/api_service.dart';
import 'courses_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController nomController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  bool isLoading = false;

  final api = ApiService(Dio());

  Future<void> login() async {
    setState(() => isLoading = true);

    final credentials = {
      "username": nomController.text,
      "password": numeroController.text,
    };

    try {
      final moniteur = await api.login(credentials);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CoursesScreen(moniteur: moniteur)),
      );
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.response?.statusCode == 401
                ? "Nom ou numéro incorrect"
                : "Erreur réseau : ${e.message}",
          ),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Dégradé aquatique en arrière-plan
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)], // bleu océan
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo aquatique
                    Image.asset(
                      "assets/images/logo.png", // 👉 place ton image ici
                      height: 100,
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      "Connexion Moniteur",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2193b0),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Champ Nom
                    TextField(
                      controller: nomController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person, color: Colors.blue),
                        labelText: "Nom",
                        filled: true,
                        fillColor: Colors.blue.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Champ Numéro (mot de passe caché ?)
                    TextField(
                      controller: numeroController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon:
                        const Icon(Icons.lock, color: Colors.blueAccent),
                        labelText: "Mot de passe",
                        filled: true,
                        fillColor: Colors.blue.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Bouton moderne
                    isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2193b0),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        "Se connecter",
                        style:
                        TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
