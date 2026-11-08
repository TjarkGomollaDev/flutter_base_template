import 'package:flutter_base_template/3rd_layer_domain/entities/example_item_entity.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_example_item_repository.dart';
import 'package:flutter_base_template/4th_layer_infrastructure/models/example_item_model.dart';
import 'package:flutter_base_template/core/exceptions/api_exceptions.dart';
import 'package:flutter_base_template/core/exceptions/common_exceptions.dart';
import 'package:flutter_base_template/core/network/api_client.dart';
import 'package:logger/logger.dart';

class ExampleItemRepository implements InterfaceExampleItemRepository {
  // Kept ready for replacing the mock implementation with real API requests.
  // ignore: unused_field
  final ApiClient _apiClient;
  final Logger _logger;

  ExampleItemRepository({required this._apiClient, required this._logger});

  @override
  Future<List<ExampleItemEntity>> getItems() async {
    try {
      await Future<void>.delayed(const Duration(seconds: 1));
      return [
        const ExampleItemModel(
          id: '1',
          title: 'Item 1',
          description: 'Description 1',
        ).toDomain(),
        const ExampleItemModel(
          id: '2',
          title: 'Item 2',
          description: 'Description 2',
        ).toDomain(),
      ];
    } on ApiException {
      // Rethrow without logging because ApiClient already logs transport errors.
      rethrow;
    } catch (e, stackTrace) {
      _logger.e(
        'Unexpected error while fetching items',
        error: e,
        stackTrace: stackTrace,
      );
      throw ExceptionUnknown();
    }
  }

  @override
  Future<ExampleItemEntity> getItemById(String id) async {
    try {
      await Future<void>.delayed(const Duration(seconds: 1));
      return ExampleItemModel(
        id: id,
        title: 'Item $id',
        description: 'Description $id',
      ).toDomain();
    } on ApiException {
      // Rethrow without logging because ApiClient already logs transport errors.
      rethrow;
    } catch (e, stackTrace) {
      _logger.e(
        'Unexpected error while fetching item by id: $id',
        error: e,
        stackTrace: stackTrace,
      );
      throw ExceptionUnknown();
    }
  }
}
