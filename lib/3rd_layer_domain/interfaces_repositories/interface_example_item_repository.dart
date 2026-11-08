import 'package:flutter_base_template/3rd_layer_domain/entities/example_item_entity.dart';

abstract interface class InterfaceExampleItemRepository {
  Future<List<ExampleItemEntity>> getItems();
  Future<ExampleItemEntity> getItemById(String id);
}
