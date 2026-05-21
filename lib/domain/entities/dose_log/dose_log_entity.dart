import 'package:home_pharmacy_manager/domain/entities/entity.dart';

/// Status of a dose log entry
enum DoseStatus {
  /// Dose was taken as scheduled
  taken,
  
  /// Dose was skipped by user
  skipped,
  
  /// Dose was missed (no action on notification)
  missed,
  
  /// Dose is pending/scheduled
  pending,
  
  /// Dose was partially taken
  partial,
}

/// Source of the dose action
enum DoseActionSource {
  /// Action came from notification button
  notification,
  
  /// Action was manually entered in app
  manual,
  
  /// Action was automatic (e.g., auto-missed after timeout)
  automatic,
}

/// Represents a single dose event/log
class DoseLogEntity extends Entity {
  /// Reference to the schedule
  final String scheduleId;
  
  /// Reference to the medication
  final String medicationId;
  
  /// Reference to the user
  final String userId;
  
  /// Scheduled date and time for this dose
  final DateTime scheduledAt;
  
  /// Actual date and time when action was taken
  final DateTime? actedAt;
  
  /// Status of this dose
  final DoseStatus status;
  
  /// How the action was performed
  final DoseActionSource? actionSource;
  
  /// Actual dosage amount taken (may differ from scheduled)
  final double? actualDosageAmount;
  
  /// Notes added by user (e.g., "felt nauseous", "taken with food")
  final String? notes;
  
  /// Whether inventory was deducted
  final bool inventoryDeducted;
  
  /// Date when log was created
  final DateTime createdAt;
  
  /// Last update timestamp
  final DateTime updatedAt;

  const DoseLogEntity({
    required String id,
    required this.scheduleId,
    required this.medicationId,
    required this.userId,
    required this.scheduledAt,
    this.actedAt,
    this.status = DoseStatus.pending,
    this.actionSource,
    this.actualDosageAmount,
    this.notes,
    this.inventoryDeducted = false,
    required this.createdAt,
    required this.updatedAt,
  }) : super(id: id);

  @override
  List<Object?> get props => [
        id,
        scheduleId,
        medicationId,
        userId,
        scheduledAt,
        actedAt,
        status,
        actionSource,
        actualDosageAmount,
        notes,
        inventoryDeducted,
        createdAt,
        updatedAt,
      ];

  /// Check if dose is overdue
  bool get isOverdue {
    if (status != DoseStatus.pending) return false;
    return DateTime.now().isAfter(scheduledAt);
  }

  /// Check if dose was taken today
  bool get wasTakenToday {
    if (status != DoseStatus.taken) return false;
    if (actedAt == null) return false;
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return actedAt!.isAtSameMomentAs(today) || 
           (actedAt!.isAfter(today) && actedAt!.isBefore(now));
  }

  /// Get hours since scheduled time
  int? get hoursSinceScheduled {
    if (actedAt == null) return null;
    return actedAt!.difference(scheduledAt).inHours;
  }

  /// Get hours late (if acted after scheduled time)
  int? get hoursLate {
    if (actedAt == null) return null;
    final diff = actedAt!.difference(scheduledAt);
    return diff.inMinutes > 0 ? diff.inHours : null;
  }

  DoseLogEntity copyWith({
    String? id,
    String? scheduleId,
    String? medicationId,
    String? userId,
    DateTime? scheduledAt,
    DateTime? actedAt,
    DoseStatus? status,
    DoseActionSource? actionSource,
    double? actualDosageAmount,
    String? notes,
    bool? inventoryDeducted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DoseLogEntity(
      id: id ?? this.id,
      scheduleId: scheduleId ?? this.scheduleId,
      medicationId: medicationId ?? this.medicationId,
      userId: userId ?? this.userId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      actedAt: actedAt ?? this.actedAt,
      status: status ?? this.status,
      actionSource: actionSource ?? this.actionSource,
      actualDosageAmount: actualDosageAmount ?? this.actualDosageAmount,
      notes: notes ?? this.notes,
      inventoryDeducted: inventoryDeducted ?? this.inventoryDeducted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
