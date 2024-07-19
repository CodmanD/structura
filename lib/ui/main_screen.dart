import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:struktura/ui/task_widget.dart';
import 'package:struktura/widgets/title_widget.dart';

final countTasks = StateProvider<int>((ref) => 0);

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> tasks = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_startAllTasks();
    _initTask();
  }

  _initTask() {
    for (int i = 0; i < 5; i++) {
      tasks.add(Flexible(child: TaskWidget(i + 1)));
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("----Build");

    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const CompleteWidget(),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: tasks,
          )),
    );
  }
}

