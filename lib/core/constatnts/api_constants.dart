class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://exercisedb.dev/api/v1';
  static const Map<String, String> headers = {};

  // ── Exercises ────────────────────────────────────────
  static const String exercises = '/exercises';
  static const String exerciseById = '/exercises'; // GET /exercises/{id}
  static const String exercisesSearch = '/exercises/search'; // GET ?q={name}

  // ── Body Parts ───────────────────────────────────────
  static const String bodyPartList = '/bodyparts';
  static const String exercisesByBodyPart =
      '/bodyparts'; // GET /bodyparts/{name}/exercises

  // ── Equipment ────────────────────────────────────────
  static const String equipmentList = '/equipments';
  static const String exercisesByEquipment =
      '/equipments'; // GET /equipments/{name}/exercises

  // ── Muscles ──────────────────────────────────────────
  static const String targetMuscleList = '/muscles';
  static const String exercisesByTarget =
      '/muscles'; // GET /muscles/{name}/exercises
}
