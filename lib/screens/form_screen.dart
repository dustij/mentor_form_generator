import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/providers.dart';
import '../pdf/pdf_generator.dart';
import '../widgets/consumer_text_form_field.dart';

class FormScreen extends HookConsumerWidget {
  const FormScreen({super.key});

  Future<void> _downloadPDF(
    String mentorName,
    String studentName,
    String sessionDetails,
    String notes,
  ) async {
    await generateAndDownloadPDF(
      mentorName,
      studentName,
      sessionDetails,
      notes,
    );
  }

  Future<void> _sharePDF(
    String mentorName,
    String studentName,
    String sessionDetails,
    String notes,
  ) async {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Memoize GlobalKey so it’s created only once and reused on rebuilds.
    // Passing an empty dependency list ensures the same key persists,
    // preventing a new key from breaking the Form on each build().
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);

    return Scaffold(
      appBar: AppBar(title: const Text('Mentor Session PDF Maker')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Card(
            elevation: 8,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Please complete this form',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),

                    const SizedBox(height: 24),

                    // _____ Mentor Name _____
                    ConsumerTextFormField(
                      provider: mentorNameProvider,
                      labelText: 'Mentor Name',
                      hintText: 'Enter mentor name',
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please enter mentor name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // _____ Student Name _____
                    ConsumerTextFormField(
                      provider: studentNameProvider,
                      labelText: 'Student Name',
                      hintText: 'Enter student name',
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please enter student name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // _____ Session Details _____
                    ConsumerTextFormField(
                      provider: sessionDetailsProvider,
                      labelText: 'Session Details',
                      hintText: 'Enter session details',
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please enter session details';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // _____ Notes _____
                    ConsumerTextFormField(
                      provider: notesProvider,
                      labelText: 'Notes',
                      hintText: 'Enter notes',
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please enter notes';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.download),
                          label: const Text('Download'),
                          onPressed: () async {
                            final isValid = formKey.currentState!.validate();
                            if (!isValid) return;

                            final mentorName = ref.read(mentorNameProvider);
                            final studentName = ref.read(studentNameProvider);
                            final sessDetail = ref.read(sessionDetailsProvider);
                            final notes = ref.read(notesProvider);

                            await _downloadPDF(
                              mentorName,
                              studentName,
                              sessDetail,
                              notes,
                            );
                          },
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.share),
                          label: const Text('Share'),
                          onPressed: () async {
                            final isValid = formKey.currentState!.validate();
                            if (!isValid) return;

                            final mentorName = ref.read(mentorNameProvider);
                            final studentName = ref.read(studentNameProvider);
                            final sessDetail = ref.read(sessionDetailsProvider);
                            final notes = ref.read(notesProvider);

                            await _sharePDF(
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
    );
  }
}
