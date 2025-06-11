/// Entry point for the Mentor Session PDF Generator app.
///
/// This file sets up the main application environment, initializes the
/// Riverpod provider scope, and defines the root widget.
library;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:mentor_form/theme/shadcn_theme.dart';

import '../screens/form_screen.dart';

/// Initializes Flutter binding and launches the app within a Riverpod provider scope.
///
/// `debugPaintSizeEnabled` is set to false to disable visual layout debugging outlines.
void main() {
  debugPaintSizeEnabled = false;
  runApp(ProviderScope(child: const MainApp()));
}

/// Root widget for the Mentor Session PDF Generator application.
///
/// Uses [HookConsumerWidget] to access Riverpod state management.
/// Applies a custom theme and displays the [FormScreen] as the home screen.
class MainApp extends HookConsumerWidget {
  const MainApp({super.key});

  /// Builds the [MaterialApp] with a custom theme and home screen.
  ///
  /// - `title`: Sets the app title shown in the task switcher.
  /// - `theme`: Applies the custom ShadCN theme.
  /// - `home`: Sets the initial screen to [FormScreen].
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Mentor Session PDF Generator',
      theme: shadcnTheme,
      home: const FormScreen(),
    );
  }
}
