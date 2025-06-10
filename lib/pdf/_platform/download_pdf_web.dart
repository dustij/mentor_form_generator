import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

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
