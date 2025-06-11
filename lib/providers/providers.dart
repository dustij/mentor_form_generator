/// Defines `StringNotifier` subclasses and Riverpod providers for form input fields.
///
/// Each provider represents a single form field (mentor name, student name, etc.)
/// and enables two-way data binding using Riverpod’s `AutoDisposeNotifier`.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

// Generated code lives in part
// to generate run: `flutter pub run build_runner build --delete-conflicting-outputs`
part 'providers.g.dart';

/// Abstract base class for form field notifiers that manage a single string value.
///
/// Provides a `setValue` method to update the state, and initializes with an empty string.
abstract class StringNotifier extends AutoDisposeNotifier<String> {
  void setValue(String val);

  @override
  String build() => '';
}

/// Riverpod provider for the Mentor Name field.
///
/// Extends [StringNotifier] to enable reactive updates and state disposal.
@riverpod
class MentorName extends _$MentorName implements StringNotifier {
  @override
  void setValue(String val) {
    state = val;
  }

  @override
  String build() => '';
}

/// Riverpod provider for the Student Name field.
///
/// Extends [StringNotifier] to enable reactive updates and state disposal.
@riverpod
class StudentName extends _$StudentName implements StringNotifier {
  @override
  void setValue(String val) {
    state = val;
  }

  @override
  String build() => '';
}

/// Riverpod provider for the Session Details field.
///
/// Extends [StringNotifier] to enable reactive updates and state disposal.
@riverpod
class SessionDetails extends _$SessionDetails implements StringNotifier {
  @override
  void setValue(String val) {
    state = val;
  }

  @override
  String build() => '';
}

/// Riverpod provider for the Notes field.
///
/// Extends [StringNotifier] to enable reactive updates and state disposal.
@riverpod
class Notes extends _$Notes implements StringNotifier {
  @override
  void setValue(String val) {
    state = val;
  }

  @override
  String build() => '';
}
