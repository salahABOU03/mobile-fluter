import 'package:flutter/material.dart';
import '../models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final Function(String) onStatusChange;

  const CourseCard({super.key, required this.course, required this.onStatusChange});

  Color getStatusColor(String status) {
    switch (status) {
      case "PLANIFIE": return Colors.orange;
      case "TERMINE": return Colors.green;
      case "ANNULE": return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        title: Text(course.activity),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Date: ${course.date}"),
            Text("Statut: ${course.status}", style: TextStyle(color: getStatusColor(course.status))),
            Text("Client: ${course.client['nom'] ?? ''}"),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: onStatusChange,
          itemBuilder: (context) => [
            const PopupMenuItem(value: "ACCEPTE", child: Text("Accepter")),
            const PopupMenuItem(value: "REFUSE", child: Text("Refuser")),
          ],
        ),
      ),
    );
  }
}
