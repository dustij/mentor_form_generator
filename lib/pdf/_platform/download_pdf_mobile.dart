import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

String? filepath;

Future<void> downloadPdfPlatformSpecific(
  Uint8List bytes,
  String filename,
  BuildContext context,
) async {
  final directory = await getTemporaryDirectory();
  filepath = '${directory.path}/$filename';
  final file = File(filepath!);
  await file.writeAsBytes(bytes);

  if (context.mounted) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("PDF saved at: $filepath")));
  }
}
