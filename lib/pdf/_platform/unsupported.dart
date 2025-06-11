/// Stub implementation of `downloadPdfPlatformSpecific` for unsupported platforms.
///
/// This file is used when the app is compiled for a platform where PDF downloading
/// is not supported, such as platforms without file I/O or download APIs.
/// It throws an [UnsupportedError] when invoked.
library;

import 'dart:typed_data';
import 'package:flutter/widgets.dart';

/// Throws [UnsupportedError] to indicate that PDF download is not available on this platform.
///
/// This is the default fallback for unsupported environments (e.g., web without download API).
Future<void> downloadPdfPlatformSpecific(
  Uint8List bytes,
  String filename,
  BuildContext context,
) async {
  throw UnsupportedError('PDF download is not supported on this platform.');
}
