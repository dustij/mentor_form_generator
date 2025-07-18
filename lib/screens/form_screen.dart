/// The main UI screen for submitting a mentor session form.
///
/// This screen includes a responsive form where users input session data,
/// and options to download or share a generated PDF summary.
/// It utilizes Riverpod for state management and Flutter Hooks for optimized widget lifecycle.
library;

import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mentor_form/models/submission.dart';
import 'package:mentor_form/xls/export_xls/export_xls_service.dart';
import 'package:share_plus/share_plus.dart';

import '../pdf/pdf_generator.dart';
import '../providers/providers.dart';
import '../widgets/consumer_text_form_field.dart';

/// Displays a responsive form layout with inputs for mentor name, student name,
/// session details, and notes.
///
/// Provides buttons to download or share a generated PDF summary of the session.
/// Uses [HookConsumerWidget] to access Riverpod providers and memoized hooks.
class FormScreen extends HookConsumerWidget {
  const FormScreen({super.key});

  Future<bool> _export(
    String mentorName,
    String studentName,
    String sessDetail,
    String notes,
    BuildContext context,
  ) async {
    try {
      final isSuccess = await ExportXlsService.exec(
        fileName: "mentor_submission_{id}",
        data: Submission(
          mentorName: mentorName,
          studentName: studentName,
          sessDetail: sessDetail,
          notes: notes,
        ),
      );
      return isSuccess;
    } catch (_) {
      return false;
    }
  }

  /// Handles the PDF generation and triggers platform-specific download behavior.
  Future<void> _download(
    String mentorName,
    String studentName,
    String sessionDetails,
    String notes,
    BuildContext context,
  ) async {
    final bytes = await generatePDF(
      mentorName,
      studentName,
      sessionDetails,
      notes,
    );

    final filename = 'Form Submission Summary.pdf';
    if (context.mounted) {
      downloadPdf(bytes, filename, context);
    }
  }

  /// Handles PDF generation and triggers the sharing intent using the SharePlus package.
  Future<void> _share(
    String mentorName,
    String studentName,
    String sessionDetails,
    String notes,
  ) async {
    final bytes = await generatePDF(
      mentorName,
      studentName,
      sessionDetails,
      notes,
    );

    // Create a shareable XFile from the generated PDF bytes
    final file = XFile.fromData(
      bytes,
      mimeType: 'application/pdf',
      name: 'Form Submission Summary.pdf',
    );

    // Define sharing parameters including the file and optional message
    final params = ShareParams(
      files: [file],
      text: 'Here is the session summary report.',
    );

    await SharePlus.instance.share(params);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Memoize the GlobalKey to persist the form state across rebuilds.
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);

    // Determine screen width to adjust layout for mobile vs tablet/desktop breakpoints.
    final width = MediaQuery.of(context).size.width;
    final small = width < 640;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: small ? 36 : 28,
              horizontal: small ? 0 : 28,
            ),
            child: GestureDetector(
              onTap: () {
                // Dismiss keyboard by unfocusing the current FocusNode
                FocusScope.of(context).unfocus();
              },
              // Ensures taps on empty space are detected
              behavior: HitTestBehavior.opaque,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Card(
                    elevation: 8,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: small ? 16 : 28,
                        horizontal: small ? 16 : 28,
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mentor Session Form',
                                  style:
                                      (small
                                              ? Theme.of(
                                                  context,
                                                ).textTheme.headlineSmall
                                              : Theme.of(
                                                  context,
                                                ).textTheme.headlineLarge)
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // _____ Mentor Name _____
                            ConsumerTextFormField(
                              provider: mentorNameProvider,
                              labelText: 'Mentor Name',
                              hintText: 'Enter mentor name',
                              isRequired: true,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Please enter mentor name';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // _____ Student Name _____
                            ConsumerTextFormField(
                              provider: studentNameProvider,
                              labelText: 'Student Name',
                              hintText: 'Enter student name',
                              isRequired: true,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Please enter student name';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // _____ Session Details _____
                            ConsumerTextFormField(
                              provider: sessionDetailsProvider,
                              labelText: 'Session Details',
                              hintText: 'Enter session details',
                              isRequired: true,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Please enter session details';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // _____ Notes _____
                            ConsumerTextFormField(
                              provider: notesProvider,
                              labelText: 'Notes',
                              hintText: 'Enter notes',
                              isRequired: true,
                              maxLines: 13,
                              keyboardType: TextInputType.multiline,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Please enter notes';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 28),

                            // _____ Button Box _____
                            small
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons.download),
                                        label: const Text('Download PDF'),
                                        onPressed: () async {
                                          final isValid = formKey.currentState!
                                              .validate();
                                          if (!isValid) return;

                                          final mentorName = ref.read(
                                            mentorNameProvider,
                                          );
                                          final studentName = ref.read(
                                            studentNameProvider,
                                          );
                                          final sessDetail = ref.read(
                                            sessionDetailsProvider,
                                          );
                                          final notes = ref.read(notesProvider);

                                          await _download(
                                            mentorName,
                                            studentName,
                                            sessDetail,
                                            notes,
                                            context,
                                          );
                                        },
                                      ),
                                      SizedBox(height: 12.0),
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons.table_view),
                                        label: const Text('Export to Excel'),
                                        onPressed: () async {
                                          final isValid = formKey.currentState!
                                              .validate();
                                          if (!isValid) return;

                                          final mentorName = ref.read(
                                            mentorNameProvider,
                                          );
                                          final studentName = ref.read(
                                            studentNameProvider,
                                          );
                                          final sessDetail = ref.read(
                                            sessionDetailsProvider,
                                          );
                                          final notes = ref.read(notesProvider);

                                          final isSuccess = await _export(
                                            mentorName,
                                            studentName,
                                            sessDetail,
                                            notes,
                                            context,
                                          );
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  isSuccess
                                                      ? "All done! Your Excel file is good to go."
                                                      : "Oops! Something went wrong...",
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      SizedBox(height: 12.0),
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons.share),
                                        label: const Text('Share'),
                                        onPressed: () async {
                                          final isValid = formKey.currentState!
                                              .validate();
                                          if (!isValid) return;

                                          final mentorName = ref.read(
                                            mentorNameProvider,
                                          );
                                          final studentName = ref.read(
                                            studentNameProvider,
                                          );
                                          final sessDetail = ref.read(
                                            sessionDetailsProvider,
                                          );
                                          final notes = ref.read(notesProvider);

                                          await _share(
                                            mentorName,
                                            studentName,
                                            sessDetail,
                                            notes,
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons.download),
                                        label: const Text('Download PDF'),
                                        onPressed: () async {
                                          final isValid = formKey.currentState!
                                              .validate();
                                          if (!isValid) return;

                                          final mentorName = ref.read(
                                            mentorNameProvider,
                                          );
                                          final studentName = ref.read(
                                            studentNameProvider,
                                          );
                                          final sessDetail = ref.read(
                                            sessionDetailsProvider,
                                          );
                                          final notes = ref.read(notesProvider);

                                          await _download(
                                            mentorName,
                                            studentName,
                                            sessDetail,
                                            notes,
                                            context,
                                          );
                                        },
                                      ),
                                      SizedBox(width: 16.0),
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons.table_view),
                                        label: const Text('Export to Excel'),
                                        onPressed: () async {
                                          final isValid = formKey.currentState!
                                              .validate();
                                          if (!isValid) return;

                                          final mentorName = ref.read(
                                            mentorNameProvider,
                                          );
                                          final studentName = ref.read(
                                            studentNameProvider,
                                          );
                                          final sessDetail = ref.read(
                                            sessionDetailsProvider,
                                          );
                                          final notes = ref.read(notesProvider);

                                          await _export(
                                            mentorName,
                                            studentName,
                                            sessDetail,
                                            notes,
                                            context,
                                          );
                                        },
                                      ),
                                      SizedBox(width: 16.0),
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons.share),
                                        label: const Text('Share'),
                                        onPressed: () async {
                                          final isValid = formKey.currentState!
                                              .validate();
                                          if (!isValid) return;

                                          final mentorName = ref.read(
                                            mentorNameProvider,
                                          );
                                          final studentName = ref.read(
                                            studentNameProvider,
                                          );
                                          final sessDetail = ref.read(
                                            sessionDetailsProvider,
                                          );
                                          final notes = ref.read(notesProvider);

                                          await _share(
                                            mentorName,
                                            studentName,
                                            sessDetail,
                                            notes,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
