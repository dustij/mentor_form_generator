/// Module: Export XLS Native Implementation
///
/// Implements the platform-specific XLS export for desktop and mobile.
/// Writes the provided bytes to a file in the application's support directory
/// and attempts to open it using the default handler.
///
/// **Setup:**
/// - Ensure `path_provider` and `open_file` packages are added in `pubspec.yaml`.
/// - Handle necessary platform permissions for file system access.
library;

import "dart:io";
import "dart:typed_data";

import "package:open_file/open_file.dart";
import "package:path_provider/path_provider.dart";

/// Exports the given XLS bytes to a file and opens it.
///
/// Writes `bytes` to a file named `fileName` in the application's support
/// directory, then opens it with the OS default viewer.
///
/// Parameters:
/// - `bytes` (`Uint8List`): The raw XLS file content.
/// - `fileName` (`String`): Desired name for the exported file (e.g., "report.xls").
///
/// Returns:
/// - `Future<bool>`: `true` if the file was successfully written and opened, `false` on error.
///
/// Example:
/// ```dart
/// final success = await exportXlsPlatformSpecific(dataBytes, "sessions_report.xls");
/// if (!success) {
///   // handle error
/// }
/// ```
Future<bool> exportXlsPlatformSpecific(Uint8List bytes, String fileName) async {
  try {
    final path = (await getApplicationSupportDirectory()).path;
    final filePath = Platform.isWindows
        ? "$path\\$fileName"
        : "$path/$fileName";
    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);

    OpenFile.open(filePath);

    return true;
  } on Exception catch (_) {
    return false;
  }
}
