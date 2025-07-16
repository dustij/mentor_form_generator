/// Module: Export XLS Service
///
/// **Setup:**
/// - Add `syncfusion_flutter_xlsio` and the necessary platform exporter
///   dependencies (`path_provider`, `open_file`, `universal_html`) in
///   `pubspec.yaml`.
/// - Ensure asset permissions and file system access are configured
///   for native platforms.
library;

import "dart:typed_data";

import "package:mentor_form/models/submission.dart";
import "package:syncfusion_flutter_xlsio/xlsio.dart";

import "_internal/platform_export.dart";

class ExportXlsService {
  static Future<bool> exec({
    required String fileName,
    required Submission data,
  }) async {
    try {
      final workbook = Workbook();
      final sheet = workbook.worksheets[0];

      final Style style = workbook.styles.add('Style1');
      style.bold = true;
      style.borders.bottom.lineStyle = LineStyle.thin;
      style.borders.bottom.color = '#000000';
      style.borders.right.lineStyle = LineStyle.thin;
      style.borders.right.color = '#000000';

      for (int i = 0; i < data.headers.length; i++) {
        sheet.getRangeByName("${column(i)}1").setText(data.headers[i]);
        sheet.getRangeByName("${column(i)}1").cellStyle = style;
        sheet.getRangeByName("${column(i)}2").setText(data[i]);
      }

      final bytes = Uint8List.fromList(workbook.saveAsStream());

      workbook.dispose();

      fileName = fileName.endsWith(".xlsx") ? fileName : "$fileName.xlsx";
      final isSuccess = await exportXlsPlatformSpecific(bytes, fileName);
      return isSuccess;
    } catch (_) {
      return false;
    }
  }
}

/// Converts a zero-based column index to its Excel column letter.
///
/// Maps 0→"A", 1→"B", …, 25→"Z"; wraps around for indices ≥26.
///
/// **Parameters:**
/// - `index` (`int`): Zero-based column number.
///
/// **Returns:** `String` Excel column letter.
///
/// **Example:**
/// ```dart
/// column(0); // "A"
/// column(27); // "B" (wrap-around)
/// ```
String column(int index) {
  final letters = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z",
  ];
  final i = index % letters.length;
  return letters[i];
}
