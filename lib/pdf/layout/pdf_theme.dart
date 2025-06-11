/// Defines reusable PDF text styles and a theming system for the generated PDF.
///
/// This file loads custom fonts from assets and constructs a [PdfTheme]
/// containing consistent styles for titles, labels, and paragraph text.
library;

import 'dart:typed_data' show Uint8List;

import 'package:flutter/services.dart' show rootBundle;

import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'pdf_layout_spec.dart';

/// A container for a text style used in the PDF.
///
/// Includes font, color brush, font size, and line height (leading).
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

/// A theming class that defines title, label, and paragraph text styles for PDFs.
///
/// Use [loadDefault] to initialize with preloaded Roboto fonts and standard layout specs.
class PdfTheme {
  final PdfTextStyle title;
  final PdfTextStyle label;
  final PdfTextStyle paragraph;

  const PdfTheme({
    required this.title,
    required this.label,
    required this.paragraph,
  });

  /// Loads the default [PdfTheme] using Roboto fonts and the layout spec.
  ///
  /// Fonts are loaded from the assets folder and used to style title, label, and paragraph text.
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

  /// Loads a font file from assets as a [Uint8List].
  ///
  /// The [name] should be the filename of a Roboto font variant located in `assets/fonts/Roboto/static/`.
  static Future<Uint8List> _loadFontData(String name) async {
    final data = await rootBundle.load('assets/fonts/Roboto/static/$name');
    return data.buffer.asUint8List();
  }
}
