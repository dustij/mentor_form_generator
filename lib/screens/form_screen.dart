import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mentor_form/pdf/_platform/download_pdf_mobile.dart';
import 'package:share_plus/share_plus.dart';

import '../pdf/pdf_generator.dart';
import '../providers/providers.dart';
import '../widgets/consumer_text_form_field.dart';

class FormScreen extends HookConsumerWidget {
  const FormScreen({super.key});

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

  Future<void> _share(
    String mentorName,
    String studentName,
    String sessionDetails,
    String notes,
  ) async {
    final filename = 'Form Submission Summary.pdf';
    final bytes = await generatePDF(
      mentorName,
      studentName,
      sessionDetails,
      notes,
    );

    // cross platform file
    final file = XFile.fromData(
      bytes,
      mimeType: 'application/pdf',
      name: '$filename.pdf',
    );

    if (kIsWeb) {
      // share via Web API (if applicable)
      final params = ShareParams(
        files: [file],
        text: 'Here is the Form Subission Summary PDF.',
      );

      await SharePlus.instance.share(params);
    } else {
      // share via native
      final params = ShareParams(
        files: [XFile(filepath!)],
        text: 'Here is the mentor form PDF.',
      );

      await SharePlus.instance.share(params);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Memoize GlobalKey so it’s created only once and reused on rebuilds.
    // Passing an empty dependency list ensures the same key persists,
    // preventing a new key from breaking the Form on each build().
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                      padding: const EdgeInsets.symmetric(
                        vertical: 28,
                        horizontal: 28,
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),

                            const SizedBox(height: 24),

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

                            const SizedBox(height: 40),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.download),
                                  label: const Text('Download'),
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
