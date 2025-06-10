import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mentor_form/theme/shadcn_theme.dart';

import '../screens/form_screen.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends HookConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Mentor Session PDF Generator',
      theme: shadcnTheme,
      home: const FormScreen(),
    );
  }
}
