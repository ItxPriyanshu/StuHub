import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stuhub/providers/selected_subject_provider.dart';
import 'package:stuhub/providers/subjectProvider.dart';

class SubjectDropdown extends ConsumerWidget {
  const SubjectDropdown({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final subjects =
        ref.watch(subjectProvider);

    final selectedSubjectId =
        ref.watch(
          selectedSubjectProvider,
        );

    return subjects.when(
      data: (subjectList) {
        if (subjectList.isEmpty) {
          return const SizedBox();
        }

        final selectedSubject =
            selectedSubjectId == null
            ? subjectList.first
            : subjectList.firstWhere(
                (e) =>
                    e.id ==
                    selectedSubjectId,
                orElse:
                    () =>
                        subjectList
                            .first,
              );

        return Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 20,
          ),

          child: Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),

            decoration: BoxDecoration(
              color:
                  const Color(
                0xff121212,
              ),

              borderRadius:
                  BorderRadius.circular(
                20,
              ),
            ),

            child:
                DropdownButtonHideUnderline(
              child:
                  DropdownButton<String>(
                value:
                    selectedSubject.id,

                dropdownColor:
                    const Color(
                  0xff121212,
                ),

                icon: const Icon(
                  Icons
                      .keyboard_arrow_down,
                  color:
                      Colors.white,
                ),

                isExpanded: true,

                style:
                    GoogleFonts.manrope(
                  color:
                      Colors.white,
                  fontWeight:
                      FontWeight.bold,
                ),

                items:
                    subjectList.map((
                  subject,
                ) {
                  return DropdownMenuItem(
                    value:
                        subject.id,

                    child: Text(
                      subject.name,
                    ),
                  );
                }).toList(),

                onChanged: (
                  value,
                ) {
                  if (value == null) {
                    return;
                  }

                  ref
                      .read(
                        selectedSubjectProvider
                            .notifier,
                      )
                      .state = value;
                },
              ),
            ),
          ),
        );
      },

      loading:
          () => const Center(
        child:
            CircularProgressIndicator(),
      ),

      error: (e, _) {
        return Center(
          child: Text(
            e.toString(),
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
        );
      },
    );
  }
}