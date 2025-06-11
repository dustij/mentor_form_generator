/// Handles the creation and layout of the mentor session PDF document.
///
/// This file defines [generatePDF], which constructs a professionally formatted PDF
/// using the Syncfusion PDF library. It includes a header, labeled fields,
/// responsive layout for multi-page content, and a footer with page numbers and contact info.
/// Also includes [downloadPdf] to trigger platform-specific saving/sharing,
/// and [_readImageData] to load assets.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:mentor_form/pdf/_platform/platform_download.dart';

import 'layout/pdf_layout_spec.dart';
import 'layout/pdf_theme.dart';

/// Generates a formatted PDF document summarizing a mentor session.
///
/// Layout includes:
/// - Header with logo and title
/// - Labeled sections for mentor name, student name, session details, and notes
/// - Dividers between each section
/// - Footer with page count and organization contact info
///
/// Returns the PDF document as a [Uint8List].
Future<Uint8List> generatePDF(
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

  double y;
  PdfTextElement textElement = PdfTextElement(text: '');

  // Header
  final header = PdfPageTemplateElement(
    Rect.fromLTWH(0, 0, pageWidth, PdfLayoutSpec.headerHeight),
  );

  header.graphics.drawImage(
    bitmap,
    Rect.fromLTWH(0, 0, PdfLayoutSpec.logoWidth, PdfLayoutSpec.logoHeight),
  );

  y = 0;
  textElement.text = 'Form Submission Summary';
  textElement.font = theme.title.font;

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

  return bytes;
}

/// Platform-agnostic method to trigger file download using platform-specific logic.
///
/// Delegates to `downloadPdfPlatformSpecific` defined in `_platform/platform_download.dart`.
Future<void> downloadPdf(
  Uint8List bytes,
  String filename,
  BuildContext context,
) async {
  return downloadPdfPlatformSpecific(bytes, filename, context);
}

/// Loads an image from the asset bundle for use in the PDF.
///
/// The [name] parameter should match the filename in the assets/images directory.
/// Returns the image data as a [Uint8List].
Future<Uint8List> _readImageData(String name) async {
  final data = await rootBundle.load('assets/images/$name');
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}
