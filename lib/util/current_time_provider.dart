import 'package:hooks_riverpod/hooks_riverpod.dart';

class CurrentTimeGetter {
  DateTime get() {
    return DateTime.now();
  }
}

final currentTimeGetterProvider = Provider((ref) => CurrentTimeGetter());
