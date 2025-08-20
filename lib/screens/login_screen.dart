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

    print("➡️ Credentials envoyés : $credentials");

    try {
      final moniteur = await api.login(credentials);
      print("✅ Réponse reçue : ${moniteur.toJson()}"); // ou juste moniteur.username

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CoursesScreen(moniteur: moniteur)),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        print("❌ Mot de passe ou username incorrect");
      } else {
        print("❌ Erreur réseau ou autre : ${e.message}");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nom ou numéro incorrect")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connexion Moniteur")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: nomController, decoration: const InputDecoration(labelText: "Nom")),
            const SizedBox(height: 10),
            TextField(controller: numeroController, decoration: const InputDecoration(labelText: "Numéro")),
            const SizedBox(height: 20),
            isLoading ? const CircularProgressIndicator() : ElevatedButton(onPressed: login, child: const Text("Se connecter")),
          ],
        ),
      ),
    );
  }
}
