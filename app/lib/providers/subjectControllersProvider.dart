import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

class subjectControllersNotifier extends Notifier<List<TextEditingController>> {
  @override
  List<TextEditingController> build() {
    return [TextEditingController()];
  }

  void addSubject() {
    state = [...state, TextEditingController()];
  }

  void removeSubject(int index) async {
    state[index].dispose();

    final update = [...state];
    update.removeAt(index);

    state = update;
  }

  void reset() {
    for(final controller in state){
      controller.dispose();
    }
    state = [TextEditingController()];
  }
}

final subjectControllerProvider =
    NotifierProvider<subjectControllersNotifier, List<TextEditingController>>(
      subjectControllersNotifier.new,
    );
