import 'dart:typed_data';
import 'package:flutter/widgets.dart';

Future<void> downloadPdfPlatformSpecific(
  Uint8List bytes,
  String filename,
  BuildContext context,
) async {
  throw UnsupportedError('PDF download is not supported on this platform.');
}
