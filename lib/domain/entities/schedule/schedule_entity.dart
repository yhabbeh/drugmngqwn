import 'package:home_pharmacy_manager/domain/entities/entity.dart';
import 'package:home_pharmacy_manager/domain/entities/medication/medication_entity.dart';

/// Days of the week for scheduling
enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

/// Status of a dose schedule
enum ScheduleStatus {
  active,
  paused,
  completed,
  cancelled,
}

/// Represents a medication schedule/dosing regimen
class ScheduleEntity extends Entity {
  /// Reference to the medication
  final String medicationId;
  
  /// Reference to the user profile
  final String userId;
  
  /// Type of medication (chronic, course, prn)
  final MedicationType medicationType;
  
  /// Start date of the schedule
  final DateTime startDate;
  
  /// End date (null for chronic/ongoing medications)
  final DateTime? endDate;
  
  /// Time(s) of day to take medication
  final List<TimeOfDay> doseTimes;
  
  /// Days of week to take medication (for weekly schedules)
  final List<DayOfWeek> daysOfWeek;
  
  /// Dosage amount per intake (e.g., 2 tablets, 5ml)
  final double dosageAmount;
  
  /// Frequency unit (daily, weekly, etc.)
  final FrequencyUnit frequencyUnit;
  
  /// Frequency value (e.g., every 2 days = 2)
  final int frequencyValue;
  
  /// Special instructions (e.g., "take with food", "on empty stomach")
  final String? instructions;
  
  /// Current status of the schedule
  final ScheduleStatus status;
  
  /// Whether to send notifications for this schedule
  final bool enableNotifications;
  
  /// Notification type (standard or full-screen alarm)
  final bool isCriticalDose;
  
  /// Date when schedule was created
  final DateTime createdAt;
  
  /// Last update timestamp
  final DateTime updatedAt;

  const ScheduleEntity({
    required String id,
    required this.medicationId,
    required this.userId,
    required this.medicationType,
    required this.startDate,
    this.endDate,
    required this.doseTimes,
    this.daysOfWeek = const [
      DayOfWeek.monday,
      DayOfWeek.tuesday,
      DayOfWeek.wednesday,
      DayOfWeek.thursday,
      DayOfWeek.friday,
      DayOfWeek.saturday,
      DayOfWeek.sunday,
    ],
    this.dosageAmount = 1.0,
    this.frequencyUnit = FrequencyUnit.daily,
    this.frequencyValue = 1,
    this.instructions,
    this.status = ScheduleStatus.active,
    this.enableNotifications = true,
    this.isCriticalDose = false,
    required this.createdAt,
    required this.updatedAt,
  }) : super(id: id);

  @override
  List<Object?> get props => [
        id,
        medicationId,
        userId,
        medicationType,
        startDate,
        endDate,
        doseTimes,
        daysOfWeek,
        dosageAmount,
        frequencyUnit,
        frequencyValue,
        instructions,
        status,
        enableNotifications,
        isCriticalDose,
        createdAt,
        updatedAt,
      ];

  /// Check if schedule is currently active
  bool get isActive {
    if (status != ScheduleStatus.active) return false;
    
    final now = DateTime.now();
    
    // Check if within date range
    if (endDate != null && now.isAfter(endDate!)) {
      return false;
    }
    
    return now.isAtSameMomentAs(startDate) || now.isAfter(startDate);
  }

  /// Check if schedule is for a course medication that has ended
  bool get isCourseCompleted {
    if (medicationType != MedicationType.course) return false;
    if (endDate == null) return false;
    return DateTime.now().isAfter(endDate!);
  }

  /// Get next scheduled dose time
  DateTime? getNextDoseTime() {
    if (!isActive || doseTimes.isEmpty) return null;
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    for (final time in doseTimes) {
      final doseDateTime = today.add(
        Duration(hours: time.hour, minutes: time.minute),
      );
      
      if (doseDateTime.isAfter(now)) {
        return doseDateTime;
      }
    }
    
    // If no more doses today, return first dose tomorrow
    if (doseTimes.isNotEmpty) {
      final firstTime = doseTimes.first;
      final tomorrow = today.add(const Duration(days: 1));
      return tomorrow.add(
        Duration(hours: firstTime.hour, minutes: firstTime.minute),
      );
    }
    
    return null;
  }

  ScheduleEntity copyWith({
    String? id,
    String? medicationId,
    String? userId,
    MedicationType? medicationType,
    DateTime? startDate,
    DateTime? endDate,
    List<TimeOfDay>? doseTimes,
    List<DayOfWeek>? daysOfWeek,
    double? dosageAmount,
    FrequencyUnit? frequencyUnit,
    int? frequencyValue,
    String? instructions,
    ScheduleStatus? status,
    bool? enableNotifications,
    bool? isCriticalDose,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ScheduleEntity(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      userId: userId ?? this.userId,
      medicationType: medicationType ?? this.medicationType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      doseTimes: doseTimes ?? this.doseTimes,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      dosageAmount: dosageAmount ?? this.dosageAmount,
      frequencyUnit: frequencyUnit ?? this.frequencyUnit,
      frequencyValue: frequencyValue ?? this.frequencyValue,
      instructions: instructions ?? this.instructions,
      status: status ?? this.status,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      isCriticalDose: isCriticalDose ?? this.isCriticalDose,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// TimeOfDay is not Equatable by default, so we extend it
extension TimeOfDayExtension on TimeOfDay {
  @override
  bool operator ==(Object other) {
    if (other is TimeOfDay) {
      return hour == other.hour && minute == other.minute;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(hour, minute);
}
