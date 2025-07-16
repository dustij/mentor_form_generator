class Submission {
  final String mentorName;
  final String studentName;
  final String sessDetail;
  final String notes;

  Submission({
    required this.mentorName,
    required this.studentName,
    required this.sessDetail,
    required this.notes,
  });

  List<String> get headers => [
    "Mentor Name",
    "Student Name",
    "Session Details",
    "Notes",
  ];

  String operator [](int i) {
    return switch (i) {
      0 => mentorName,
      1 => studentName,
      2 => sessDetail,
      3 => notes,

      int() => throw UnimplementedError(),
    };
  }
}
