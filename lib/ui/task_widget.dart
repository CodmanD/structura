import 'dart:isolate';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main_screen.dart';

Future workTask(SendPort sendPort) async {
  Duration duration = Duration(seconds: 2 + Random().nextInt(20 - 2));
  sendPort.send("duration:${duration.inSeconds}");
  await Future.delayed(duration);
  sendPort.send("end");
}

class TaskWidget extends ConsumerStatefulWidget {
  const TaskWidget(this.id, {super.key});

  final int id;

  @override
  ConsumerState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends ConsumerState<TaskWidget>
    with TickerProviderStateMixin {
  AnimationController? controller;
  late String mess;
  int value = 20;
  String title = "";

  @override
  void initState() {
    super.initState();
    createTask();
  }

  Future createTask() async {
    ReceivePort receivePort = ReceivePort();

    Isolate isolate = await Isolate.spawn(workTask, receivePort.sendPort);

    receivePort.listen((message) {
      if (message.contains("duration")) {
        title = 'Задача №${widget.id} выполняется';
        List<String> mess = message.split(":");

        value = int.parse(mess[1]);
        // controller.duration = Duration(seconds: value);

        controller = AnimationController(
          vsync: this,
          duration: Duration(seconds: value),
        )..addListener(() {
            setState(() {});
          });
        controller!.forward(from: 0.0);
        ;
        setState(() {});
      }
      if (message.contains('end')) {
        setState(() {
          ref.watch(countTasks.notifier).update((count) => count + 1);
          title = 'Задача №${widget.id} выполнено';
        });
      }

      print(message); // Output: Result of the task
    });
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            child: Text(
              title,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          controller != null
              ? LinearProgressIndicator(
                  value: controller!.value,
                  semanticsLabel: 'Linear progress indicator',
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
