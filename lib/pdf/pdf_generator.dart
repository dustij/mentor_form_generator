import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:web/web.dart' as web;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'pdf_theme.dart';
import 'pdf_layout_spec.dart';

Future<void> generateAndDownloadPDF(
  String mentorName,
  String studentName,
  String sessionDetails,
  String notes,
) async {
  PdfDocument document = PdfDocument();
  document.pageSettings.margins.all = PdfLayoutSpec.margin;

  final page = document.pages.add();

  final pageWidth = page.getClientSize().width;
  final pageHeight = page.getClientSize().height;

  final theme = await PdfTheme.loadDefault();
  final bitmap = PdfBitmap(await _readImageData('CSC_logo_500x173.png'));

  var y = 0.0;
  var textElement = PdfTextElement(text: '');

  // Header
  final header = PdfPageTemplateElement(
    Rect.fromLTWH(0, 0, pageWidth, PdfLayoutSpec.headerHeight),
  );

  header.graphics.drawImage(
    bitmap,
    Rect.fromLTWH(0, 0, PdfLayoutSpec.logoWidth, PdfLayoutSpec.logoHeight),
  );

  textElement = PdfTextElement(
    text: 'Form Submission Summary',
    font: theme.title.font,
  );

  y = PdfLayoutSpec.logoHeight + PdfLayoutSpec.titlePaddingTop;
  header.graphics.drawString(
    'Form Submission Summary',
    theme.title.font,
    bounds: Rect.fromLTWH(0, y, pageWidth, PdfLayoutSpec.headerHeight),
  );

  y = header.bounds.bottom - PdfLayoutSpec.titleDividerPaddingBottom;
  header.graphics.drawLine(
    PdfPen(PdfColor(0, 0, 0), width: PdfLayoutSpec.titleDividerThickness),
    Offset(0, y),
    Offset(pageWidth, y),
  );

  document.template.top = header;

  // Mentor Name
  y = 0;
  textElement.text = 'Mentor Name:';
  textElement.font = theme.label.font;

  var layoutResult = textElement.draw(
    page: page,
    bounds: Rect.fromLTWH(0, y, PdfLayoutSpec.labelWidth, 0),
  );

  textElement.text = mentorName;
  textElement.font = theme.paragraph.font;

  layoutResult = textElement.draw(
    page: page,
    bounds: Rect.fromLTWH(
      layoutResult!.bounds.right,
      y,
      PdfLayoutSpec.fieldWidth,
      0,
    ),
  );

  // Divider
  y = layoutResult!.bounds.bottom + PdfLayoutSpec.bodyGap;
  page.graphics.drawLine(
    PdfPen(PdfColor(204, 204, 204), width: PdfLayoutSpec.bodyDividerThickness),
    Offset(0, y),
    Offset(pageWidth, y),
  );

  // Student Name
  y += PdfLayoutSpec.bodyGap;
  textElement.text = 'Student Name:';
  textElement.font = theme.label.font;

  layoutResult = textElement.draw(
    page: page,
    bounds: Rect.fromLTWH(0, y, PdfLayoutSpec.labelWidth, 0),
  );

  textElement.text = studentName;
  textElement.font = theme.paragraph.font;

  layoutResult = textElement.draw(
    page: page,
    bounds: Rect.fromLTWH(
      layoutResult!.bounds.right,
      y,
      PdfLayoutSpec.fieldWidth,
      0,
    ),
  );

  // Divider
  y = layoutResult!.bounds.bottom + PdfLayoutSpec.bodyGap;
  page.graphics.drawLine(
    PdfPen(PdfColor(204, 204, 204), width: PdfLayoutSpec.bodyDividerThickness),
    Offset(0, y),
    Offset(pageWidth, y),
  );

  // Session Details
  y += PdfLayoutSpec.bodyGap;
  textElement.text = 'Session Details:';
  textElement.font = theme.label.font;

  layoutResult = textElement.draw(
    page: page,
    bounds: Rect.fromLTWH(0, y, PdfLayoutSpec.labelWidth, 0),
  );

  textElement.text = sessionDetails;
  textElement.font = theme.paragraph.font;

  layoutResult = textElement.draw(
    page: page,
    bounds: Rect.fromLTWH(
      layoutResult!.bounds.right,
      y,
      PdfLayoutSpec.fieldWidth,
      0,
    ),
  );

  // Divider
  y = layoutResult!.bounds.bottom + PdfLayoutSpec.bodyGap;
  page.graphics.drawLine(
    PdfPen(PdfColor(204, 204, 204), width: PdfLayoutSpec.bodyDividerThickness),
    Offset(0, y),
    Offset(pageWidth, y),
  );

  // Notes
  y += PdfLayoutSpec.bodyGap;
  textElement.text = 'Notes:';
  textElement.font = theme.label.font;

  layoutResult = textElement.draw(
    page: page,
    bounds: Rect.fromLTWH(0, y, PdfLayoutSpec.labelWidth, 0),
  );

  final notesTextBounds = Rect.fromLTWH(
    layoutResult!.bounds.right,
    y,
    PdfLayoutSpec.fieldWidth,
    pageHeight - PdfLayoutSpec.footerHeight - PdfLayoutSpec.headerHeight - y,
  );

  final notesTextPaginationBounds = Rect.fromLTWH(
    layoutResult.bounds.right,
    0,
    pageWidth - PdfLayoutSpec.labelWidth,
    pageHeight - PdfLayoutSpec.footerHeight - PdfLayoutSpec.headerHeight,
  );

  final PdfLayoutFormat format = PdfLayoutFormat(
    layoutType: PdfLayoutType.paginate,
    breakType: PdfLayoutBreakType.fitPage,
    paginateBounds: notesTextPaginationBounds,
  );

  textElement.text = notes;
  textElement.font = theme.paragraph.font;

  layoutResult = textElement.draw(
    page: page,
    bounds: notesTextBounds,
    format: format,
  );
  // Footer
  y = pageHeight - PdfLayoutSpec.footerHeight;
  final footer = PdfPageTemplateElement(
    Rect.fromLTWH(0, y, pageWidth, PdfLayoutSpec.footerHeight),
  );

  y = PdfLayoutSpec.footerDividerPaddingTop;
  footer.graphics.drawLine(
    PdfPen(PdfColor(0, 0, 0)),
    Offset(0, y),
    Offset(pageWidth, y),
  );

  final pageNumber = PdfPageNumberField(font: theme.paragraph.font);
  final count = PdfPageCountField(font: theme.paragraph.font);

  PdfCompositeField compositeField = PdfCompositeField(
    font: theme.paragraph.font,
    text: '{0} of {1}',
    fields: <PdfAutomaticField>[pageNumber, count],
  );

  y += PdfLayoutSpec.footerGapToPageNum;
  compositeField.draw(footer.graphics, Offset(0, y));

  y -= PdfLayoutSpec.footerGapToPageNum;
  y += PdfLayoutSpec.footerGapToInfo;
  footer.graphics.drawString(
    '2518 Ridge Ct, Suite 208\nLawrence, KS 66046\nwww.supportivecommunities.org',
    theme.paragraph.font,
    bounds: Rect.fromLTWH(PdfLayoutSpec.pageNumBoxWidth, y, 0, 0),
  );

  document.template.bottom = footer;

  // Save and dispose
  final bytes = await document.saveAsBytes();
  document.dispose();

  if (kIsWeb) {
    _downloadPDF(bytes, 'Form Submission Summary.pdf');
  }
}

Future<void> _downloadPDF(Uint8List bytes, String filename) async {
  final base64 = base64Encode(bytes);
  final anchor = web.document.createElement('a') as web.HTMLAnchorElement
    ..href = 'data:application/pdf;base64,$base64'
    ..download = filename;
  web.document.body!.appendChild(anchor);
  anchor.click();
  web.document.body!.removeChild(anchor);
}

Future<Uint8List> _readImageData(String name) async {
  final data = await rootBundle.load('assets/images/$name');
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}
