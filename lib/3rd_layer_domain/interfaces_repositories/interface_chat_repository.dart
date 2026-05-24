import 'package:flutter_base_template/3rd_layer_domain/entities/chat_entity.dart';
import 'package:flutter_base_template/3rd_layer_domain/entities/message_entity.dart';

abstract class InterfaceChatRepository {
  void saveData({required MessageEntity messageEntity, required String chatID});

  void initChatDocument({required ChatEntity chatEntity});

  Stream<List<MessageEntity>> streamChatMessages({required String chatID});

  Stream<List<ChatEntity>> streamChats({required List<String> chatIDs});
}
