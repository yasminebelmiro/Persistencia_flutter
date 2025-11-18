import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:persistencia_local/data/interfaces/persistence_strategy.dart';
import 'package:persistencia_local/model/task.dart';
import 'package:persistencia_local/view/widgets/task_list_tab.dart';

class FileStrategy implements PersistenceStrategy {
  @override
  String getName() => "File (JSON)";

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File(p.join(directory.path, 'tasks.json'));
  }

  @override
  Future<List<Task>> loadTasks() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) return [];

      final content = await file.readAsString();
      if (content.isEmpty) return [];

      final List<dynamic> jsonList = jsonDecode(content);
      return jsonList.map((e) => Task.fromMap(e)).toList();
    } catch (e) {
      print("Erro ao ler arquivo: $e");
      return [];
    }
  }

  @override
  Future<void> saveTask(Task task) async {
    // Assim como SharedPrefs, em arquivos simples geralmente reescrevemos tudo
    List<Task> currentTasks = await loadTasks();
    int index = currentTasks.indexWhere((t) => t.id == task.id);

    if (index >= 0) {
      currentTasks[index] = task;
    } else {
      currentTasks.add(task);
    }
    await _saveAll(currentTasks);
  }
  @override
  Future<void> deleteTask(String id) async {
    List<Task> currentTasks = await loadTasks();
    currentTasks.removeWhere((t) => t.id == id);
    await _saveAll(currentTasks);
  }

  Future<void> _saveAll(List<Task> tasks) async {
    final file = await _getFile();
    final String jsonString = jsonEncode(tasks.map((t) => t.toMap()).toList());
    await file.writeAsString(jsonString);
  }
}