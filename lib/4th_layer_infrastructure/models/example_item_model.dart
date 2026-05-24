import 'package:flutter_base_template/3rd_layer_domain/entities/example_item_entity.dart';

class ExampleItemModel {
  final String id;
  final String title;
  final String description;

  const ExampleItemModel({
    required this.id,
    required this.title,
    required this.description,
  });

  factory ExampleItemModel.fromJson(Map<String, dynamic> json) {
    return ExampleItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  ExampleItemEntity toDomain() {
    return ExampleItemEntity(
      id: id,
      title: title,
      description: description,
    );
  }

  factory ExampleItemModel.fromDomain(ExampleItemEntity entity) {
    return ExampleItemModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
    );
  }
}
