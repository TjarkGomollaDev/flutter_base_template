import 'package:logger/logger.dart';
import 'package:flutter_base_template/3rd_layer_domain/entities/example_item_entity.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_example_item_repository.dart';
import 'package:flutter_base_template/4th_layer_infrastructure/models/example_item_model.dart';
import 'package:flutter_base_template/core/network/api_client.dart';
import 'package:flutter_base_template/core/exceptions/api_exceptions.dart';
import 'package:flutter_base_template/core/exceptions/common_exceptions.dart';

class ExampleItemRepository implements InterfaceExampleItemRepository {
  // ignore: unused_field
  final ApiClient _apiClient;
  final Logger _logger;

  ExampleItemRepository({
    required ApiClient apiClient,
    required Logger logger,
  })  : _apiClient = apiClient,
        _logger = logger;

  @override
  Future<List<ExampleItemEntity>> getItems() async {
    try {
      // --- Exemplary API Call ---
      // final response = await _apiClient.get('/items');
      // final List<dynamic> data = response.data;
      // return data.map((json) => ExampleItemModel.fromJson(json).toDomain()).toList();

      // Simulate a network delay for mock data
      await Future.delayed(const Duration(seconds: 1));
      return [
        const ExampleItemModel(
                id: '1', title: 'Item 1', description: 'Description 1')
            .toDomain(),
        const ExampleItemModel(
                id: '2', title: 'Item 2', description: 'Description 2')
            .toDomain(),
      ];
    } on ApiException {
      // ApiException is already logged by the ApiClient interceptor.
      // Just rethrow it so the BLoC can handle it and show UI feedback.
      rethrow;
    } catch (e, stackTrace) {
      // Log unexpected errors (e.g., JSON parsing errors) at critical nodes
      _logger.e('Unexpected error while fetching items',
          error: e, stackTrace: stackTrace);
      throw ExceptionUnknown();
    }
  }

  @override
  Future<ExampleItemEntity> getItemById(String id) async {
    try {
      // --- Exemplary API Call ---
      // final response = await _apiClient.get('/items/$id');
      // return ExampleItemModel.fromJson(response.data).toDomain();

      // Simulate a network delay for mock data
      await Future.delayed(const Duration(seconds: 1));
      return ExampleItemModel(
              id: id, title: 'Item $id', description: 'Description $id')
          .toDomain();
    } on ApiException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.e('Unexpected error while fetching item by id: $id',
          error: e, stackTrace: stackTrace);
      throw ExceptionUnknown();
    }
  }
}
