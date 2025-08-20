import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/course.dart';
import '../models/moniteur.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "http://localhost:8080/api/")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl = "http://localhost:8080/api/"}) {
    // ✅ Ajout du LogInterceptor pour debug
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
    ));

    return _ApiService(dio, baseUrl: baseUrl);
  }

  // ✅ login moniteur
  @POST("users/login")
  Future<Moniteur> login(@Body() Map<String, dynamic> body);

  // ✅ Récupérer les cours d’un moniteur
  @GET("courses/moniteur/{id}")
  Future<List<Course>> getCoursesForMoniteur(@Path("id") int moniteurId);

  // ✅ Mettre à jour uniquement le status d’un cours
  @PUT("courses/{id}/status")
  Future<Course> updateCourseStatus(
      @Path("id") int courseId, @Body() Map<String, dynamic> body);
}

// ✅ Exemple de test rapide
Future<void> testApi(ApiService api) async {
  try {
    final creds = {"username": "testUser", "password": "1234"};
    print("➡️ Test login avec : $creds");
    final moniteur = await api.login(creds);
    print("✅ Login réussi : ${moniteur.toString()}");

    final courses = await api.getCoursesForMoniteur(moniteur.id);
    print("📚 Cours récupérés : ${courses.length}");

    if (courses.isNotEmpty) {
      print("🔄 Test update status du premier cours");
      final updated = await api.updateCourseStatus(
          courses.first.id, {"status": "CONFIRMED"});
      print("✅ Nouveau status : ${updated.status}");
    }
  } catch (e, s) {
    print("❌ Erreur API : $e");
    print(s);
  }
}
