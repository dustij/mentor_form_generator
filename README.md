# Mentor Session Form Generator

A cross-platform Flutter app for creating and exporting professionally formatted mentor session summaries as PDFs. The app features a clean, responsive UI and supports downloading or sharing the PDF on mobile, desktop, and web platforms.

## 📱 App Screenshots

<p align="center">
  <img src="examples/Screenshot%202025-06-13%20at%206.21.27 AM.png" alt="Web" height="400">
  <img src="examples/Screenshot%202025-06-13%20at%206.37.20 AM.png" alt="Mobile" height="400">
</p>

## 🖨️ PDF Output Preview

<p align="center">
  <img src="examples/Screenshot%202025-06-13%20at%206.47.24 AM.png" alt="PDF Output" height="400">
</p>

## 🚀 Getting Started

### Prerequisites

-   [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.10 or higher)
-   Dart enabled
-   Device or emulator (iOS, Android, macOS, Windows, or web)

### Run the App

Clone the repository and run:

```bash
flutter pub get
flutter run
```

To run on a specific platform:

```bash
flutter run -d chrome       # Web
flutter run -d macos        # macOS
flutter run -d windows      # Windows
flutter run -d ios          # iOS
flutter run -d android      # Android
```

---

## 🧠 Walkthrough

### `main.dart`

Entry point of the app. Initializes the Riverpod provider scope and sets the root widget (`MainApp`).

### `form_screen.dart`

Main UI screen. Displays a responsive form for mentor name, student name, session details, and notes. Users can generate a PDF to download or share. Uses Riverpod and Flutter Hooks for state management and lifecycle.

### `consumer_text_form_field.dart`

Reusable text field widget bound to a Riverpod `StringNotifier`. Automatically updates provider state as the user types.

### `providers.dart`

Defines state providers for each input field (mentor name, student name, session details, notes). Each uses a `StringNotifier` for reactive updates and automatic disposal.

### `pdf/pdf_generator.dart`

Generates the PDF layout using the Syncfusion PDF library. Includes:

-   Header with logo and title
-   Labeled body sections
-   Footer with contact info and page numbers
-   Platform-agnostic `downloadPdf()` helper

### `pdf/layout/pdf_theme.dart`

Loads and applies consistent fonts and styles (Roboto family) for PDF content.

### `pdf/layout/pdf_layout_spec.dart`

Defines exact layout values (margins, padding, font sizes, spacing) used across the PDF.

### `pdf/_platform/`

Platform-specific implementations of `downloadPdfPlatformSpecific()`:

-   `download_pdf_web.dart`: uses base64 + anchor for web download
-   `download_pdf_native.dart`: saves to filesystem and opens viewer on mobile/desktop
-   `unsupported.dart`: fallback that throws `UnsupportedError`
