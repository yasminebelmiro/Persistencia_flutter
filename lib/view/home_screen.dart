import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistencia_local/data/strategies/file_strategy.dart';
import 'package:persistencia_local/data/strategies/shared_prefs_strategys.dart';
import 'package:persistencia_local/data/strategies/sqlite_strategy.dart';
import 'package:persistencia_local/view/widgets/task_list_tab.dart';
import 'package:persistencia_local/viewmodel/task_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Criamos 3 Tabs, cada uma com seu próprio Provider e Estratégia
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MyTasks Multi-Persistência'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.settings), text: "SharedPrefs"),
              Tab(icon: Icon(Icons.file_present), text: "File (JSON)"),
              Tab(icon: Icon(Icons.storage), text: "SQLite"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Aba 1: Shared Preferences
            ChangeNotifierProvider(
              create: (_) => TaskViewModel(SharedPrefsStrategy()),
              child: const TaskListScreen(),
            ),
            // Aba 2: File System
            ChangeNotifierProvider(
              create: (_) => TaskViewModel(FileStrategy()),
              child: const TaskListScreen(),
            ),
            // Aba 3: SQLite
            ChangeNotifierProvider(
              create: (_) => TaskViewModel(SqliteStrategy()),
              child: const TaskListScreen(),
            ),
          ],
        ),
      ),
    );
  }
}