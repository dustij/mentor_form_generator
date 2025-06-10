// This stub provides a fallback implementation for downloadPdf
//
// If you try to access a web-specific API (like `dart:js_interop`) on native platforms,
// the app will crash.
//
// To prevent this, we use an "umbrella" import file that conditionally selects the
// appropriate implementation using platform-specific imports.
//
// See: download_pdf_web.dart and download_pdf_mobile.dart for platform support.
// Also see: https://codewithandrea.com/tips/dart-conditional-imports/

export 'unsupported.dart'
    if (dart.library.js) 'download_pdf_web.dart'
    if (dart.library.io) 'download_pdf_mobile.dart';
