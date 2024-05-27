import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '/models/respuestas.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'respuestas.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE respuestas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        texto TEXT
      )
      ''',
    );
  }

  Future<void> addRespuestasAutomaticas() async {
    List<String> respuestasPreEscritas = [
      'Sí, definitivamente.',
      'Es cierto.',
      'Es decididamente así.',
      'Sin duda.',
      'Sí, absolutamente.',
      'Puedes confiar en ello.',
      'Como yo lo veo, sí.',
      'Más probablemente sí que no.',
      'Las señales apuntan a sí.',
      'Respuesta borrosa, intenta de nuevo.',
      'Pregunta de nuevo más tarde.',
      'Mejor no decirte ahora.',
      'No se puede predecir ahora.',
      'Concéntrate y pregunta de nuevo.',
      'No cuentes con ello.',
      'Mi respuesta es no.',
      'Mis fuentes dicen que no.',
      'Muy dudoso.',
      'No cuentes con eso.',
      'Definitivamente no.'
    ];

    for (var respuesta in respuestasPreEscritas) {
      insertRespuesta(Respuesta(texto: respuesta));
    }
  }

  Future<int> insertRespuesta(Respuesta respuesta) async {
    final db = await database;
    return await db!.insert('respuestas', respuesta.toMap());
  }

  Future<void> deleteAllRespuestas() async {
    final db = await database;
    await db!.delete('respuestas');
  }

  Future<List<Respuesta>> getRespuestas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('respuestas');

    return List.generate(maps.length, (i) {
      return Respuesta(
        id: maps[i]['id'],
        texto: maps[i]['texto'],
      );
    });
  }
}
