import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle, Rect, Offset;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:web/web.dart' as web;
import 'package:flutter/foundation.dart' show kIsWeb;

/// !!!!!!!!!!!!!!!!!!
/// This file is not used and will be deleted
/// !!!!!!!!!!!!!!!!!!

Future<void> generateAndDownloadPDF(
  String mentorName,
  String studentName,
  String sessionDetails,
  String notes,
) async {
  PdfDocument document = PdfDocument();

  final double pageWidth = document.pageSettings.size.width;
  final double pageHeight = document.pageSettings.size.height;

  document.pageSettings.margins.all = 72;

  // will set margins manually
  // half inch margins (72 points x 0.5 inches = 36 points)
  final margin = 36.0;

  // fonts
  final titleFont = PdfTrueTypeFont(await _loadFontData('Roboto-Bold.ttf'), 20);
  final headerFont = PdfTrueTypeFont(
    await _loadFontData('Roboto-Medium.ttf'),
    16,
  );
  final bodyFont = PdfTrueTypeFont(
    await _loadFontData('Roboto-Regular.ttf'),
    12,
  );

  // logo byte data
  Uint8List logoData;
  try {
    logoData = await _readImageData('CSC_logo_500x173.png');
  } catch (_) {
    logoData = Uint8List(0);
  }

  // header template
  final PdfPageTemplateElement header = PdfPageTemplateElement(
    Rect.fromLTWH(0, 0, pageWidth, margin + 50),
  );

  // brand color top border
  header.graphics.drawRectangle(
    bounds: Rect.fromLTWH(0, 0, pageWidth, margin / 2),
    brush: PdfSolidBrush(PdfColor(62, 140, 148)),
  );

  // logo top-right
  if (logoData.isNotEmpty) {
    header.graphics.drawImage(
      PdfBitmap(logoData),
      Rect.fromLTWH(pageWidth - 144 - margin, margin, 144, 50),
    );
  }

  // Create a date/time field
  final dateField =
      PdfDateTimeField(
          font: headerFont,
          brush: PdfSolidBrush(PdfColor(128, 128, 128)),
        )
        ..date = DateTime.now()
        ..dateFormatString = 'EEEE, MM.dd.yyyy';

  // Create a composite field
  final PdfCompositeField headerComposite = PdfCompositeField(
    font: titleFont,
    brush: PdfSolidBrush(PdfColor(0, 0, 0)),
    text: 'Form Submission Summary\n{0}',
    fields: <PdfAutomaticField>[dateField],
  );

  // Draw the composite field inside the header
  headerComposite.draw(header.graphics, Offset(margin, margin));

  // footer template
  final PdfPageTemplateElement footer = PdfPageTemplateElement(
    Rect.fromLTWH(0, pageHeight - 60, pageWidth, 60),
  );

  footer.graphics.drawRectangle(
    bounds: Rect.fromLTWH(0, 60 - 8, pageWidth, 8),
    brush: PdfSolidBrush(PdfColor(62, 140, 148)),
  );

  document.template.top = header;
  document.template.bottom = footer;

  final page = document.pages.add();

  PdfTextElement textElement = PdfTextElement(
    text:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi quis imperdiet felis, ac tincidunt nisi. Curabitur malesuada odio et dolor gravida, sit amet commodo massa volutpat. Mauris molestie hendrerit interdum. Mauris ac quam egestas, ornare magna id, pulvinar neque. Donec ullamcorper euismod bibendum. Donec in pellentesque nulla. Morbi bibendum placerat odio, ut pretium erat. In in magna placerat nisi sollicitudin venenatis ut ac libero. Duis porttitor a tellus eget tempor. Curabitur pellentesque lacus non tincidunt consectetur. Nullam quis ullamcorper eros, sed consequat nunc. Integer eu dolor quis diam dapibus cursus non eget felis. Donec auctor volutpat gravida. Phasellus justo urna, ultricies id commodo et, porta ornare neque. Suspendisse potenti. Fusce molestie quam sit amet elementum euismod.',
    font: bodyFont,
  );

  PdfLayoutResult layoutResult = textElement.draw(
    page: page,
    bounds: Rect.fromLTWH(
      0,
      150,
      document.pageSettings.width,
      page.getClientSize().height,
    ),
  )!;

  textElement.text = 'Top 5 sales stores';
  textElement.font = PdfStandardFont(
    PdfFontFamily.helvetica,
    14,
    style: PdfFontStyle.bold,
  );

  //Draw the header text on page, below the paragraph text with a height gap of 20 and maintain the position in PdfLayoutResult
  layoutResult = textElement.draw(
    page: page,
    bounds: Rect.fromLTWH(90, layoutResult.bounds.bottom + 20, 0, 0),
  )!;

  textElement.text =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi quis imperdiet felis, ac tincidunt nisi. Curabitur malesuada odio et dolor gravida, sit amet commodo massa volutpat. Mauris molestie hendrerit interdum. Mauris ac quam egestas, ornare magna id, pulvinar neque. Donec ullamcorper euismod bibendum. Donec in pellentesque nulla. Morbi bibendum placerat odio, ut pretium erat. In in magna placerat nisi sollicitudin venenatis ut ac libero. Duis porttitor a tellus eget tempor. Curabitur pellentesque lacus non tincidunt consectetur. Nullam quis ullamcorper eros, sed consequat nunc. Integer eu dolor quis diam dapibus cursus non eget felis. Donec auctor volutpat gravida. Phasellus justo urna, ultricies id commodo et, porta ornare neque. Suspendisse potenti. Fusce molestie quam sit amet elementum euismod.';
  textElement.font = bodyFont;

  layoutResult = textElement.draw(
    page: page,
    bounds: Rect.fromLTWH(
      layoutResult.bounds.left,
      layoutResult.bounds.bottom + 18,
      page.getClientSize().width,
      0,
    ),
  )!;

  // page.graphics.drawString(
  //   "Topeka Public Library",
  //   bodyFont,
  //   bounds: Rect.fromLTWH(
  //     100,
  //     500,
  //     document.pageSettings.width,
  //     bodyFont.height,
  //   ),
  // );

  Uint8List bytes = await document.saveAsBytes();
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

Future<Uint8List> _loadFontData(String name) async {
  final data = await rootBundle.load('assets/fonts/Roboto/static/$name');
  return data.buffer.asUint8List();
}
