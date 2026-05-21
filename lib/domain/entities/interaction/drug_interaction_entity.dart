import 'package:home_pharmacy_manager/domain/entities/entity.dart';

/// Severity level of drug interaction
enum InteractionSeverity {
  /// No known interaction
  none,
  
  /// Minor interaction, generally safe
  minor,
  
  /// Moderate interaction, monitor symptoms
  moderate,
  
  /// Severe interaction, avoid combination
  severe,
  
  /// Contraindicated - do not combine
  contraindicated,
}

/// Represents a potential drug-drug interaction
class DrugInteractionEntity extends Entity {
  /// First medication ID
  final String medicationId1;
  
  /// Second medication ID
  final String medicationId1Ref;
  
  /// First active ingredient involved
  final String ingredient1;
  
  /// Second active ingredient involved
  final String ingredient2;
  
  /// Severity level
  final InteractionSeverity severity;
  
  /// Description of the interaction
  final String description;
  
  /// Clinical effects of the interaction
  final String? clinicalEffects;
  
  /// Recommended management/action
  final String? management;
  
  /// Evidence level (A, B, C, D, X)
  final String? evidenceLevel;
  
  /// Source of interaction data
  final String? source;
  
  /// Date when this interaction was recorded
  final DateTime createdAt;

  const DrugInteractionEntity({
    required String id,
    required this.medicationId1,
    required this.medicationId1Ref,
    required this.ingredient1,
    required this.ingredient2,
    required this.severity,
    required this.description,
    this.clinicalEffects,
    this.management,
    this.evidenceLevel,
    this.source,
    required this.createdAt,
  }) : super(id: id);

  @override
  List<Object?> get props => [
        id,
        medicationId1,
        medicationId1Ref,
        ingredient1,
        ingredient2,
        severity,
        description,
        clinicalEffects,
        management,
        evidenceLevel,
        source,
        createdAt,
      ];

  /// Check if interaction is serious (severe or contraindicated)
  bool get isSerious {
    return severity == InteractionSeverity.severe ||
           severity == InteractionSeverity.contraindicated;
  }

  /// Get severity as display string
  String get severityDisplay {
    switch (severity) {
      case InteractionSeverity.none:
        return 'No Interaction';
      case InteractionSeverity.minor:
        return 'Minor';
      case InteractionSeverity.moderate:
        return 'Moderate';
      case InteractionSeverity.severe:
        return 'Severe';
      case InteractionSeverity.contraindicated:
        return 'Contraindicated';
    }
  }

  DrugInteractionEntity copyWith({
    String? id,
    String? medicationId1,
    String? medicationId1Ref,
    String? ingredient1,
    String? ingredient2,
    InteractionSeverity? severity,
    String? description,
    String? clinicalEffects,
    String? management,
    String? evidenceLevel,
    String? source,
    DateTime? createdAt,
  }) {
    return DrugInteractionEntity(
      id: id ?? this.id,
      medicationId1: medicationId1 ?? this.medicationId1,
      medicationId1Ref: medicationId1Ref ?? this.medicationId1Ref,
      ingredient1: ingredient1 ?? this.ingredient1,
      ingredient2: ingredient2 ?? this.ingredient2,
      severity: severity ?? this.severity,
      description: description ?? this.description,
      clinicalEffects: clinicalEffects ?? this.clinicalEffects,
      management: management ?? this.management,
      evidenceLevel: evidenceLevel ?? this.evidenceLevel,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
