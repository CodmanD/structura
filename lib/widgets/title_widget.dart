
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:struktura/ui/main_screen.dart';

class CompleteWidget extends ConsumerWidget {
  const CompleteWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count=ref.watch(countTasks);
    return Text(count==5?"Все задачи выполнены":"In process",style: TextStyle(color: Colors.red));
  }
}