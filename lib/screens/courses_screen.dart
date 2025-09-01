import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/course.dart';
import '../models/moniteur.dart';
import '../services/api_service.dart';
import '../widgets/course_card.dart';

class CoursesScreen extends StatefulWidget {
  final Moniteur moniteur;
  const CoursesScreen({super.key, required this.moniteur});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final api = ApiService(Dio());
  List<Course> courses = [];
  bool isLoading = true;

  Future<void> fetchCourses() async {
    try {
      courses = await api.getCoursesForMoniteur(widget.moniteur.id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Erreur lors du chargement des cours")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateStatus(int courseId, String status) async {
    try {
      await api.updateCourseStatus(courseId, {"status": status});
      await fetchCourses(); // 🔄 rechargement des cours
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Impossible de mettre à jour le cours")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Ajout du Drawer (navigation à gauche)
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.teal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: Text(
                widget.moniteur.username,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              // 🔴 Supprimé l'email, remplacé par le rôle
              accountEmail: Text("Rôle : ${widget.moniteur.role}"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  widget.moniteur.username.isNotEmpty
                      ? widget.moniteur.username[0].toUpperCase()
                      : "?",
                  style: const TextStyle(fontSize: 28, color: Colors.blue),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text("Mes cours"),
              onTap: () {
                Navigator.pop(context); // ferme le drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Mes informations"),
              onTap: () {
                // 👉 Tu peux afficher plus de détails ici si nécessaire
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("👤 Moniteur : ${widget.moniteur.username}")),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Déconnexion"),
              onTap: () {
                Navigator.pushReplacementNamed(context, "/login");
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(
        title: Text("Mes Cours - ${widget.moniteur.username}"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE0F7FA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : courses.isEmpty
            ? const Center(child: Text("Aucun cours trouvé"))
            : ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            return CourseCard(
              course: courses[index],
              onStatusChange: (status) =>
                  updateStatus(courses[index].id, status),
            );
          },
        ),
      ),
    );
  }
}
