/// Module: Export XLS Web Implementation
///
/// Implements the web-specific XLS export by creating a downloadable link
/// using a base64-encoded data URL and triggering a click on an `AnchorElement`.
///
/// **Setup:**
/// - Ensure `universal_html` package is added in `pubspec.yaml`.
/// - No additional permissions required for web.
library;

import "dart:convert";
import "dart:typed_data";

import "package:universal_html/html.dart";

/// Exports the given XLS bytes for web by generating a download link.
///
/// Encodes `bytes` to base64, sets it as a data URL on an AnchorElement,
/// assigns the `download` attribute, and programmatically clicks to initiate download.
///
/// Parameters:
/// - `bytes` (`Uint8List`): The raw XLS file content.
/// - `fileName` (`String`): Desired filename for download (e.g., "report.xls").
///
/// Returns:
/// - `Future<bool>`: `true` if the download was successfully initiated, `false` otherwise.
///
/// **Example:**
/// ```dart
/// final success = await exportXlsPlatformSpecific(dataBytes, "sessions_report.xls");
/// if (!success) {
///   // handle error
/// }
/// ```
Future<bool> exportXlsPlatformSpecific(Uint8List bytes, String fileName) async {
  try {
    final base64 = base64Encode(bytes);
    AnchorElement(
        href: "data:application/octet-stream;charset-utf-16le;base64,$base64",
      )
      ..setAttribute("download", fileName)
      ..click();

    return true;
  } on Exception catch (_) {
    return false;
  }
}
