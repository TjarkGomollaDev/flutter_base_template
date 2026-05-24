import 'package:flutter_base_template/3rd_layer_domain/entities/ai_message_entity.dart';

abstract class InterfaceChatbotRepository {
  Future<String> chatbotRequest({required List<AiMessageEntity> context});
}
