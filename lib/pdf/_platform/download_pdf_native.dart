/// Native implementation of `downloadPdfPlatformSpecific` for Android, iOS, and desktop platforms.
///
/// Saves the PDF file to the Downloads folder on Android, or the application’s documents directory
/// on iOS and desktop platforms (e.g., macOS: ~/Library/Containers/.../Documents).
/// Displays a snackbar with a button to open the saved PDF using a native file viewer.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

String? filepath;

/// Saves a PDF file to the local file system and shows a confirmation snackbar.
///
/// - On Android: saves to `/storage/emulated/0/Download`.
/// - On iOS and desktop: saves to the application’s documents directory
///   (not the user’s general Documents folder).
///
/// The snackbar includes an "Open" action that opens the file with a native viewer.
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
        content: Text('All done! Your session PDF is good to go.'),
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
