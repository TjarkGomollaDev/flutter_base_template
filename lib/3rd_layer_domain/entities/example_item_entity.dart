import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class ExampleItemEntity extends Equatable {
  final String id;
  final String title;
  final String description;

  const ExampleItemEntity({
    required this.id,
    required this.title,
    required this.description,
  });

  ExampleItemEntity.newExampleItem()
    : this(id: const Uuid().v4(), title: 'title', description: 'description');

  @override
  List<Object?> get props => [id, title, description];
}
