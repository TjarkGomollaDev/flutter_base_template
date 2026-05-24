import 'package:mark_lxxxv/3rd_layer_domain/entities/ai_chat_entity.dart';
import 'package:mark_lxxxv/3rd_layer_domain/entities/ai_message_entity.dart';

abstract class InterfaceAiChatRepository {
  // init
  Future<void> initNewAiChat({required AiChatEntity aiChatEntity});
  // store data
  Future<void> storeMessageInAiChat(
      {required AiMessageEntity aiMessageEntity, required String aiChatID});
  Future<void> updateMessageInAiChat(
      {required AiMessageEntity aiMessageEntity, required String aiChatID});
  // delete data
  Future<void> deleteMessageInAiChat({required String aiMessageID, required String aiChatID});
  // stream data
  Stream<List<AiMessageEntity>> streamAiChatMessages({required String aiChatID});
}
