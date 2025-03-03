// This class represents the Attendance entity.
// It holds the core business model without any external dependencies.

class Attendance {
  final String date; // Add a date field
  final String employeeName; // Name of the employee
  final String checkIn; // Check-in time of the employee
  final String checkOut; // Check-out time of the employee
  final String status; // Status of the employee (Present/Absent)

  // Constructor to initialize the Attendance entity with required data
  const Attendance({
    required this.employeeName,
    required this.checkIn,
    required this.checkOut,
    required this.status,
    required this.date, // Initialize date in the constructor
  });

  // CopyWith method to update properties
  Attendance copyWith({
    String? employeeName,
    String? checkIn,
    String? checkOut,
    String? status,
    String? date, // Add date to the copyWith method
  }) {
    return Attendance(
      employeeName: employeeName ?? this.employeeName,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      status: status ?? this.status,
      date: date ?? this.date, // Set date if provided
    );
  }

  // Overriding equality operator to compare two Attendance objects.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Attendance &&
        other.employeeName == employeeName &&
        other.checkIn == checkIn &&
        other.checkOut == checkOut &&
        other.status == status;
  }

  // Generating hash code based on object properties.
  @override
  int get hashCode => employeeName.hashCode ^ checkIn.hashCode ^ checkOut.hashCode ^ status.hashCode;

  // Converts Attendance object to string format for debugging purposes.
  @override
  String toString() {
    return 'Attendance(employeeName: $employeeName, checkIn: $checkIn, checkOut: $checkOut, status: $status)';
  }
}

