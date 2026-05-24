import 'package:flutter_base_template/3rd_layer_domain/entities/example_item_entity.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_example_item_repository.dart';
import 'package:flutter_base_template/4th_layer_infrastructure/models/example_item_model.dart';

class ExampleItemRepository implements InterfaceExampleItemRepository {
  @override
  Future<List<ExampleItemEntity>> getItems() async {
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 1));
    return [
      const ExampleItemModel(id: '1', title: 'Item 1', description: 'Description 1'),
      const ExampleItemModel(id: '2', title: 'Item 2', description: 'Description 2'),
    ];
  }

  @override
  Future<ExampleItemEntity> getItemById(String id) async {
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 1));
    return ExampleItemModel(id: id, title: 'Item $id', description: 'Description $id');
  }
}
