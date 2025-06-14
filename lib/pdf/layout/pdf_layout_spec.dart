/// Defines layout constants for consistent spacing and sizing in the generated PDF.
///
/// Values are measured in points and used throughout the PDF to control margins,
/// font sizes, padding, dividers, and the positioning of header, body, and footer elements.

/// A specification class containing static layout values for the PDF document.
///
/// Organized into sections:
/// - Global: shared margins
/// - Header: logo, title, spacing, and divider styles
/// - Body: label width, font sizing, and divider thickness
/// - Footer: spacing and element sizes for the footer and page numbering
library;

class PdfLayoutSpec {
  // Global
  static const double margin = 72.0;

  // Header
  static const double headerHeight = 140.0;
  static const double logoWidth = 104.0;
  static const double logoHeight = 36.0;
  static const double titleFontSize = 24.0;
  static const double titleLeading = 32.0;
  static const double titlePaddingTop = 36.0;
  static const double titlePaddingBottom = 18.0;
  static const double titleDividerThickness = 2.0;
  static const double titleDividerPaddingBottom = 18.0;

  // Body
  static const double bodyGap = 18.0;
  static const double labelWidth = 150.0;
  static const double fieldWidth = 301.28;
  static const double bodyFontSize = 12.0;
  static const double bodyLeading = 14.4;
  static const double bodyDividerThickness = 0.5;

  // Footer
  static const double footerHeight = 77.374;
  static const double footerDividerPaddingTop = 18.0;
  static const double footerGapToInfo = 18.0;
  static const double footerInfoHeight = 41.374;
  static const double footerGapToPageNum = 31.561;
  static const double pageNumBoxWidth = 274.779;
}
