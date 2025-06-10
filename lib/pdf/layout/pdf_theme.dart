import 'dart:typed_data' show Uint8List;

import 'package:flutter/services.dart' show rootBundle;

import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'pdf_layout_spec.dart';

class PdfTextStyle {
  final PdfFont font;
  final PdfBrush brush;
  final double fontSize;
  final double lineHeight;

  const PdfTextStyle({
    required this.font,
    required this.brush,
    required this.fontSize,
    required this.lineHeight,
  });
}

class PdfTheme {
  final PdfTextStyle title;
  final PdfTextStyle label;
  final PdfTextStyle paragraph;

  const PdfTheme({
    required this.title,
    required this.label,
    required this.paragraph,
  });

  static Future<PdfTheme> loadDefault() async {
    final titleFont = PdfTrueTypeFont(
      await _loadFontData('Roboto-Bold.ttf'),
      PdfLayoutSpec.titleFontSize,
    );
    final labelFont = PdfTrueTypeFont(
      await _loadFontData('Roboto-Medium.ttf'),
      PdfLayoutSpec.bodyFontSize,
    );
    final paragraphFont = PdfTrueTypeFont(
      await _loadFontData('Roboto-Regular.ttf'),
      PdfLayoutSpec.bodyFontSize,
    );

    return PdfTheme(
      title: PdfTextStyle(
        font: titleFont,
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        fontSize: PdfLayoutSpec.titleFontSize,
        lineHeight: PdfLayoutSpec.titleLeading,
      ),
      label: PdfTextStyle(
        font: labelFont,
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        fontSize: PdfLayoutSpec.bodyFontSize,
        lineHeight: PdfLayoutSpec.bodyLeading,
      ),
      paragraph: PdfTextStyle(
        font: paragraphFont,
        brush: PdfSolidBrush(PdfColor(30, 30, 30)),
        fontSize: PdfLayoutSpec.bodyFontSize,
        lineHeight: PdfLayoutSpec.bodyLeading,
      ),
    );
  }

  static Future<Uint8List> _loadFontData(String name) async {
    final data = await rootBundle.load('assets/fonts/Roboto/static/$name');
    return data.buffer.asUint8List();
  }
}
