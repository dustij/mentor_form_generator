/// Module: Export XLS Unsupported Platform
///
/// Stub implementation for XLS export on unsupported platforms.
/// Always throws an [UnsupportedError] to indicate lack of support.
///
/// **Usage:**
/// - This file is used when neither native nor web XLS export is available.
library;

import "package:flutter/foundation.dart";

/// Throws an [UnsupportedError] indicating XLS export is not supported.
///
/// Parameters:
/// - `bytes` (`Uint8List`): Ignored raw XLS content.
/// - `fileName` (`String`): Ignored desired filename.
///
/// Throws:
/// - [UnsupportedError] always.
///
/// Example:
/// ```dart
/// try {
///   await exportXlsPlatformSpecific(dataBytes, "report.xls");
/// } catch (e) {
///   // Handle unsupported platform
/// }
/// ```
Future<bool> exportXlsPlatformSpecific(Uint8List bytes, String fileName) async {
  throw UnsupportedError("Xls export is not supported by this platform.");
}
