import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

String? filepath;

Future<void> downloadPdfPlatformSpecific(
  Uint8List bytes,
  String filename,
  BuildContext context,
) async {
  Directory? directory;

  if (Platform.isAndroid) {
    // Android Download folder
    directory = Directory('/storage/emulated/0/Download');
  } else {
    // iOS: app-specific folder
    directory = await getApplicationDocumentsDirectory();
  }

  final savePath = '${directory.path}/$filename';
  final file = File(savePath);
  await file.writeAsBytes(bytes);

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF saved at: $savePath'),
        action: SnackBarAction(
          label: 'Open',
          onPressed: () {
            OpenFile.open(savePath);
          },
        ),
      ),
    );
  }
}
