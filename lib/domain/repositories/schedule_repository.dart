import 'package:dartz/dartz.dart';
import 'package:home_pharmacy_manager/core/failure/failure.dart';
import 'package:home_pharmacy_manager/domain/entities/schedule/schedule_entity.dart';
import 'package:home_pharmacy_manager/domain/entities/dose_log/dose_log_entity.dart';

/// Filter options for querying schedules
class ScheduleFilter {
  final String? userId;
  final String? medicationId;
  final ScheduleStatus? status;
  final MedicationType? medicationType;
  final bool? isActiveOnly;
  final DateTime? startDate;
  final DateTime? endDate;

  const ScheduleFilter({
    this.userId,
    this.medicationId,
    this.status,
    this.medicationType,
    this.isActiveOnly,
    this.startDate,
    this.endDate,
  });
}

/// Repository interface for medication schedule and dose log operations
abstract class ScheduleRepository {
  // ==================== SCHEDULE OPERATIONS ====================

  /// Create a new medication schedule
  /// Returns the created [ScheduleEntity] on success, [Failure] on error
  Future<Either<Failure, ScheduleEntity>> createSchedule(ScheduleEntity schedule);

  /// Update an existing schedule
  /// Returns the updated [ScheduleEntity] on success, [Failure] on error
  Future<Either<Failure, ScheduleEntity>> updateSchedule(ScheduleEntity schedule);

  /// Delete a schedule by ID
  /// Returns true on success, [Failure] on error
  Future<Either<Failure, bool>> deleteSchedule(String scheduleId);

  /// Get a schedule by ID
  /// Returns [ScheduleEntity] on success, [Failure] on error
  Future<Either<Failure, ScheduleEntity>> getScheduleById(String scheduleId);

  /// Get all schedules with optional filtering
  /// Returns list of [ScheduleEntity] on success, [Failure] on error
  Future<Either<Failure, List<ScheduleEntity>>> getSchedules({
    ScheduleFilter? filter,
    int? limit,
    int? offset,
  });

  /// Get active schedules for a specific user
  /// Returns list of [ScheduleEntity] on success, [Failure] on error
  Future<Either<Failure, List<ScheduleEntity>>> getActiveSchedulesForUser(
    String userId,
  );

  /// Get schedules due for a specific date
  /// Returns list of [ScheduleEntity] on success, [Failure] on error
  Future<Either<Failure, List<ScheduleEntity>>> getSchedulesDueForDate(
    String userId,
    DateTime date,
  );

  /// Pause a schedule
  /// Returns the updated [ScheduleEntity] on success, [Failure] on error
  Future<Either<Failure, ScheduleEntity>> pauseSchedule(String scheduleId);

  /// Resume a paused schedule
  /// Returns the updated [ScheduleEntity] on success, [Failure] on error
  Future<Either<Failure, ScheduleEntity>> resumeSchedule(String scheduleId);

  /// Complete a schedule (for course medications)
  /// Returns the updated [ScheduleEntity] on success, [Failure] on error
  Future<Either<Failure, ScheduleEntity>> completeSchedule(String scheduleId);

  // ==================== DOSE LOG OPERATIONS ====================

  /// Log a dose as taken
  /// Inventory is deducted only when user confirms taking the dose
  /// Returns the created [DoseLogEntity] on success, [Failure] on error
  Future<Either<Failure, DoseLogEntity>> logDoseTaken({
    required String scheduleId,
    required String medicationId,
    required String userId,
    required DateTime scheduledAt,
    double? actualDosageAmount,
    DoseActionSource? actionSource,
    String? notes,
  });

  /// Log a dose as skipped
  /// Inventory is NOT deducted
  /// Returns the created [DoseLogEntity] on success, [Failure] on error
  Future<Either<Failure, DoseLogEntity>> logDoseSkipped({
    required String scheduleId,
    required String medicationId,
    required String userId,
    required DateTime scheduledAt,
    DoseActionSource? actionSource,
    String? notes,
  });

  /// Mark a dose as missed (no action on notification)
  /// Inventory is NOT deducted
  /// Returns the created/updated [DoseLogEntity] on success, [Failure] on error
  Future<Either<Failure, DoseLogEntity>> markDoseAsMissed({
    required String scheduleId,
    required String medicationId,
    required String userId,
    required DateTime scheduledAt,
  });

  /// Get dose logs for a specific schedule
  /// Returns list of [DoseLogEntity] on success, [Failure] on error
  Future<Either<Failure, List<DoseLogEntity>>> getDoseLogsForSchedule(
    String scheduleId, {
    DateTime? startDate,
    DateTime? endDate,
    DoseStatus? status,
    int? limit,
  });

  /// Get dose logs for a user within a date range
  /// Returns list of [DoseLogEntity] on success, [Failure] on error
  Future<Either<Failure, List<DoseLogEntity>>> getDoseLogsForUser(
    String userId, {
    required DateTime startDate,
    required DateTime endDate,
    List<DoseStatus>? statuses,
    int? limit,
  });

  /// Get pending doses that are overdue
  /// Returns list of [DoseLogEntity] on success, [Failure] on error
  Future<Either<Failure, List<DoseLogEntity>>> getOverdueDoses(String userId);

  /// Get today's dose logs for a user
  /// Returns list of [DoseLogEntity] on success, [Failure] on error
  Future<Either<Failure, List<DoseLogEntity>>> getTodayDoseLogs(String userId);

  /// Update a dose log entry
  /// Returns the updated [DoseLogEntity] on success, [Failure] on error
  Future<Either<Failure, DoseLogEntity>> updateDoseLog(DoseLogEntity doseLog);

  /// Delete a dose log entry
  /// Returns true on success, [Failure] on error
  Future<Either<Failure, bool>> deleteDoseLog(String doseLogId);

  /// Get adherence statistics for a user
  /// Returns map with adherence data on success, [Failure] on error
  Future<Either<Failure, Map<String, dynamic>>> getAdherenceStats({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });

  // ==================== BULK OPERATIONS ====================

  /// Generate dose logs for upcoming schedules
  /// Used by background service to pre-schedule notifications
  /// Returns number of dose logs created on success, [Failure] on error
  Future<Either<Failure, int>> generateUpcomingDoseLogs({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Auto-mark doses as missed after timeout period
  /// Called by background service
  /// Returns number of doses marked as missed on success, [Failure] on error
  Future<Either<Failure, int>> autoMarkMissedDoses({
    required String userId,
    required Duration timeoutPeriod,
  });

  /// Clean up old dose logs (archive or delete)
  /// Returns number of records affected on success, [Failure] on error
  Future<Either<Failure, int>> cleanupOldDoseLogs({
    required DateTime beforeDate,
    bool archiveInsteadOfDelete = true,
  });
}
