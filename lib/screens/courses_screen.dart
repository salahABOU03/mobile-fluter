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
      appBar: AppBar(
        title: Text("Mes Cours - ${widget.moniteur.username}"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : courses.isEmpty
          ? const Center(child: Text("Aucun cours trouvé"))
          : ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return CourseCard(
            course: courses[index],
            onStatusChange: (status) =>
                updateStatus(courses[index].id, status),
          );
        },
      ),
    );
  }
}
