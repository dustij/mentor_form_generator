/// Module: Export XLS Conditional Selector
///
/// Re-exports the appropriate platform-specific XLS export implementation:
/// - On web (JS): `_export_xls_web.dart`
/// - On native (IO): `_export_xls_native.dart`
/// - On other platforms: `_unsupported.dart`
///
/// This file acts as the single import point for `exportXlsPlatformSpecific`,
/// ensuring the correct implementation is available based on the target platform.
library;

/// Conditional export to select the correct XLS export implementation.
export "_unsupported.dart"
    if (dart.library.js) "_export_xls_web.dart"
    if (dart.library.io) "_export_xls_native.dart";
