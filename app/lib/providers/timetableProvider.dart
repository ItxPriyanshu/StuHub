import 'package:riverpod/legacy.dart';

class TimetableSetupNotifier extends StateNotifier<Map<String, Map<int, int>>> {
  TimetableSetupNotifier() : super({});

  void initializeSubject(String subjectId) {
    if (state.containsKey(subjectId)) return;

    final newState = Map<String, Map<int, int>>.from(state);
    newState[subjectId] = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0};
    state = newState;
  }

  void increment(String subjectId, int day) {
    final current = Map<int, int>.from(state[subjectId]!);

    current[day] = current[day]! + 1;

    final newState = Map<String, Map<int, int>>.from(state);
    newState[subjectId] = current;
    state = newState;
  }

  void decrement(String subjectId, int day) {
    final current = Map<int, int>.from(state[subjectId]!);

    if (current[day]! > 0) {
      current[day] = current[day]! - 1;
    }

    final newState = Map<String, Map<int, int>>.from(state);
    newState[subjectId] = current;
    state = newState;
  }

  void loadExisting(Map<String,Map<int,int>> data){
    state = data;
  }


  void clear(){
    state = {};
  }
}

final timetableSetupProvider =
    StateNotifierProvider<TimetableSetupNotifier, Map<String, Map<int, int>>>(
      (ref) => TimetableSetupNotifier(),
    );
