import 'package:flutter_base_template/3rd_layer_domain/entities/example_item_entity.dart';

class ExampleItemModel extends ExampleItemEntity {
  const ExampleItemModel({
    required super.id,
    required super.title,
    required super.description,
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
}
