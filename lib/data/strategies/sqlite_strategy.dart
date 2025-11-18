import 'package:persistencia_local/data/interfaces/persistence_strategy.dart';
import 'package:persistencia_local/model/task.dart';
import 'package:persistencia_local/view/widgets/task_list_tab.dart';
import 'package:sqflite/sqflite.dart';

class SqliteStrategy implements PersistenceStrategy {
  static Database? _database;

  @override
  String getName() => "SQLite";

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'tasks.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id TEXT PRIMARY KEY,
            title TEXT,
            done INTEGER
          )
        ''');
      },
    );
  }

  @override
  Future<List<Task>> loadTasks() async {
    final db = await database;
    // Mapeia coluna 'done' para 'isDone' no map se necessário,
    // mas nosso fromMap já trata int vs bool.
    final List<Map<String, dynamic>> maps = await db.query('tasks');

    // Ajuste manual para chave se o banco usar nomes diferentes,
    // mas aqui usamos os mesmos do modelo.
    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        title: maps[i]['title'],
        isDone: maps[i]['done'] == 1,
      );
    });
  }

  @override
  Future<void> saveTask(Task task) async {
    final db = await database;
    // SQLite suporta Insert OR Replace, o que facilita o UPSERT
    await db.insert(
      'tasks',
      {
        'id': task.id,
        'title': task.title,
        'done': task.isDone ? 1 : 0
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteTask(String id) async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}