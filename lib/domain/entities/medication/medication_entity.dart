import 'package:home_pharmacy_manager/domain/entities/entity.dart';

/// Type of medication schedule
enum MedicationType {
  /// Continuous medication for chronic conditions (e.g., hypertension, diabetes)
  /// Requires refill alerts and ongoing dose tracking
  chronic,

  /// Temporary medication with fixed start and end dates (e.g., antibiotics)
  /// Automatically stops after end date
  course,

  /// As-needed medication (PRN)
  /// Taken only when specific symptoms occur
  prn,
}

/// Frequency unit for medication dosing
enum FrequencyUnit {
  hourly,
  daily,
  weekly,
  monthly,
  onDemand,
}

/// Represents a medication in the home pharmacy inventory
class MedicationEntity extends Entity {
  final String name;
  final String? brandName;
  final String? genericName;
  final String? manufacturer;
  final String? barcode;
  final String? batchNumber;
  
  /// Active ingredients for drug interaction checking
  final List<String> activeIngredients;
  
  /// Current quantity in stock
  final int quantity;
  
  /// Unit of measurement (e.g., tablets, ml, mg)
  final String unit;
  
  /// Initial quantity when added to inventory
  final int initialQuantity;
  
  /// Expiration date
  final DateTime? expiryDate;
  
  /// Manufacturing date
  final DateTime? manufacturingDate;
  
  /// Storage instructions
  final String? storageInstructions;
  
  /// Dosage form (tablet, capsule, syrup, injection, etc.)
  final String? dosageForm;
  
  /// Strength (e.g., "500mg", "10ml")
  final String? strength;
  
  /// Notes about the medication
  final String? notes;
  
  /// Whether this medication requires prescription
  final bool requiresPrescription;
  
  /// Image path of the medication
  final String? imagePath;
  
  /// Date when medication was added to inventory
  final DateTime createdAt;
  
  /// Last update timestamp
  final DateTime updatedAt;

  const MedicationEntity({
    required String id,
    required this.name,
    this.brandName,
    this.genericName,
    this.manufacturer,
    this.barcode,
    this.batchNumber,
    this.activeIngredients = const [],
    this.quantity = 0,
    this.unit = 'tablets',
    required this.initialQuantity,
    this.expiryDate,
    this.manufacturingDate,
    this.storageInstructions,
    this.dosageForm,
    this.strength,
    this.notes,
    this.requiresPrescription = false,
    this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  }) : super(id: id);

  @override
  List<Object?> get props => [
        id,
        name,
        brandName,
        genericName,
        manufacturer,
        barcode,
        batchNumber,
        activeIngredients,
        quantity,
        unit,
        initialQuantity,
        expiryDate,
        manufacturingDate,
        storageInstructions,
        dosageForm,
        strength,
        notes,
        requiresPrescription,
        imagePath,
        createdAt,
        updatedAt,
      ];

  /// Check if medication is expired
  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  /// Check if medication is near expiry (within 30 days)
  bool get isNearExpiry {
    if (expiryDate == null) return false;
    final daysUntilExpiry = expiryDate!.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 30 && daysUntilExpiry >= 0;
  }

  /// Check if stock is low (less than 20% of initial quantity)
  bool get isLowStock {
    final threshold = (initialQuantity * 0.2).ceil();
    return quantity <= threshold;
  }

  /// Get days until expiry
  int? get daysUntilExpiry {
    if (expiryDate == null) return null;
    return expiryDate!.difference(DateTime.now()).inDays;
  }

  MedicationEntity copyWith({
    String? id,
    String? name,
    String? brandName,
    String? genericName,
    String? manufacturer,
    String? barcode,
    String? batchNumber,
    List<String>? activeIngredients,
    int? quantity,
    String? unit,
    int? initialQuantity,
    DateTime? expiryDate,
    DateTime? manufacturingDate,
    String? storageInstructions,
    String? dosageForm,
    String? strength,
    String? notes,
    bool? requiresPrescription,
    String? imagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MedicationEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      brandName: brandName ?? this.brandName,
      genericName: genericName ?? this.genericName,
      manufacturer: manufacturer ?? this.manufacturer,
      barcode: barcode ?? this.barcode,
      batchNumber: batchNumber ?? this.batchNumber,
      activeIngredients: activeIngredients ?? this.activeIngredients,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      initialQuantity: initialQuantity ?? this.initialQuantity,
      expiryDate: expiryDate ?? this.expiryDate,
      manufacturingDate: manufacturingDate ?? this.manufacturingDate,
      storageInstructions: storageInstructions ?? this.storageInstructions,
      dosageForm: dosageForm ?? this.dosageForm,
      strength: strength ?? this.strength,
      notes: notes ?? this.notes,
      requiresPrescription: requiresPrescription ?? this.requiresPrescription,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
