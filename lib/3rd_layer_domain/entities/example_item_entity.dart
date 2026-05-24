import 'package:uuid/uuid.dart';

class ExampleItemEntity {
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
}
