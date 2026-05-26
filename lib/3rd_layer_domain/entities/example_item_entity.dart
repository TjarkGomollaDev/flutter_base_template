import 'package:uuid/uuid.dart';
import 'package:equatable/equatable.dart';

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
      : this(
          id: const Uuid().v1(),
          title: 'title',
          description: 'description',
        );

  @override
  List<Object?> get props => [id, title, description];
}
