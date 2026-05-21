import 'package:dartz/dartz.dart';
import 'package:home_pharmacy_manager/core/failure/failure.dart';
import 'package:home_pharmacy_manager/domain/entities/medication/medication_entity.dart';

/// Result from barcode scan containing medication data
class ScanResult {
  final String barcode;
  final String? medicationName;
  final String? brandName;
  final String? genericName;
  final String? manufacturer;
  final List<String> activeIngredients;
  final String? dosageForm;
  final String? strength;
  final String? imageUrl;
  final Map<String, dynamic>? rawData;

  const ScanResult({
    required this.barcode,
    this.medicationName,
    this.brandName,
    this.genericName,
    this.manufacturer,
    this.activeIngredients = const [],
    this.dosageForm,
    this.strength,
    this.imageUrl,
    this.rawData,
  });

  /// Check if scan result has sufficient data to create a medication
  bool get hasValidData => 
      (medicationName != null && medicationName!.isNotEmpty) ||
      activeIngredients.isNotEmpty;

  /// Convert scan result to MedicationEntity
  MedicationEntity toMedicationEntity({
    required String id,
    int initialQuantity = 30,
    DateTime? expiryDate,
    String? notes,
  }) {
    return MedicationEntity(
      id: id,
      name: medicationName ?? 'Unknown',
      brandName: brandName,
      genericName: genericName,
      manufacturer: manufacturer,
      barcode: barcode,
      activeIngredients: activeIngredients,
      dosageForm: dosageForm,
      strength: strength,
      initialQuantity: initialQuantity,
      quantity: initialQuantity,
      expiryDate: expiryDate,
      notes: notes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

/// Result from OCR scan
class OcrScanResult {
  final String extractedText;
  final String? medicationName;
  final DateTime? expiryDate;
  final String? batchNumber;
  final Map<String, String>? additionalData;
  final double confidence;

  const OcrScanResult({
    required this.extractedText,
    this.medicationName,
    this.expiryDate,
    this.batchNumber,
    this.additionalData,
    this.confidence = 0.0,
  });

  /// Check if OCR result has valid medication name
  bool get hasMedicationName => 
      medicationName != null && medicationName!.isNotEmpty;

  /// Check if expiry date was detected
  bool get hasExpiryDate => expiryDate != null;
}

/// Repository interface for medication scanning operations
abstract class ScannerRepository {
  /// Scan barcode and fetch medication data from API
  /// Returns [ScanResult] on success, [Failure] on error
  Future<Either<Failure, ScanResult>> scanBarcode(String barcode);

  /// Perform OCR on image to extract medication information
  /// Returns [OcrScanResult] on success, [Failure] on error
  Future<Either<Failure, OcrScanResult>> performOCR(String imagePath);

  /// Search medication by name in local cache or API
  /// Returns list of matching medications
  Future<Either<Failure, List<ScanResult>>> searchMedicationByName(String query);

  /// Get medication details from external API by barcode
  /// Used when local database doesn't have the medication
  Future<Either<Failure, ScanResult>> fetchMedicationFromApi(String barcode);

  /// Validate barcode format
  bool isValidBarcode(String barcode);

  /// Clear scan cache
  Future<void> clearCache();
}
