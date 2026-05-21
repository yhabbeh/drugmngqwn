import 'package:equatable/equatable.dart';

/// Base Entity class for all domain entities
abstract class Entity extends Equatable {
  final String id;

  const Entity({required this.id});

  @override
  List<Object?> get props => [id];
}
