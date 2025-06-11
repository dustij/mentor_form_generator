/// Web-specific implementation of `downloadPdfPlatformSpecific` for saving PDFs in the browser.
///
/// Uses an HTML anchor element to trigger a file download with a base64-encoded PDF data URI.
/// Only used when compiling for the web platform.
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

/// Initiates a PDF download in the browser using a data URI and anchor click.
///
/// Converts the [bytes] to a base64-encoded string, creates an `<a>` element with a
/// `data:application/pdf` URI, sets the `download` attribute to [filename],
/// and programmatically triggers a click to prompt the user to save the file.
///
/// This implementation uses `dart:html` via the `web` package to access DOM APIs.
Future<void> downloadPdfPlatformSpecific(
  Uint8List bytes,
  String filename,
  BuildContext context,
) async {
  final base64 = base64Encode(bytes);
  final anchor = web.document.createElement('a') as web.HTMLAnchorElement
    ..href = 'data:application/pdf;base64,$base64'
    ..download = filename;
  web.document.body!.appendChild(anchor);
  anchor.click();
  web.document.body!.removeChild(anchor);
}
