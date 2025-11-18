import 'dart:convert';

import 'package:persistencia_local/data/interfaces/persistence_strategy.dart';
import 'package:persistencia_local/model/task.dart';
import 'package:persistencia_local/view/widgets/task_list_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsStrategy implements PersistenceStrategy {
  static const String _key = 'tasks_list';

  @override
  String getName() => "SharedPreferences";

  @override
  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => Task.fromMap(e)).toList();
  }

  @override
  Future<void> saveTask(Task task) async {
    // SharedPrefs salva a lista inteira novamente. É ineficiente para grandes dados.
    // Nesta simulação, carregamos tudo, modificamos e salvamos tudo.
    List<Task> currentTasks = await loadTasks();
    int index = currentTasks.indexWhere((t) => t.id == task.id);

    if (index >= 0) {
      currentTasks[index] = task; // Atualiza
    } else {
      currentTasks.add(task); // Insere
    }

    _saveAll(currentTasks);
  }

  @override
  Future<void> deleteTask(String id) async {
    List<Task> currentTasks = await loadTasks();
    currentTasks.removeWhere((t) => t.id == id);
    _saveAll(currentTasks);
  }

  Future<void> _saveAll(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(tasks.map((t) => t.toMap()).toList());
    await prefs.setString(_key, jsonString);
  }
}