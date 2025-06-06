import 'package:riverpod_annotation/riverpod_annotation.dart';

// Generated code lives in part
// to generate run: `flutter pub run build_runner build --delete-conflicting-outputs`
part 'providers.g.dart';

abstract class StringNotifier extends AutoDisposeNotifier<String> {
  void setValue(String val);

  @override
  String build() => '';
}

@riverpod
class MentorName extends _$MentorName implements StringNotifier {
  @override
  void setValue(String val) {
    state = val;
  }

  @override
  String build() => '';
}

@riverpod
class StudentName extends _$StudentName implements StringNotifier {
  @override
  void setValue(String val) {
    state = val;
  }

  @override
  String build() => '';
}

@riverpod
class SessionDetails extends _$SessionDetails implements StringNotifier {
  @override
  void setValue(String val) {
    state = val;
  }

  @override
  String build() => '';
}

@riverpod
class Notes extends _$Notes implements StringNotifier {
  @override
  void setValue(String val) {
    state = val;
  }

  @override
  String build() => '';
}
