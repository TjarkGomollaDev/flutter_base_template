// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_base_template/3rd_layer_domain/entities/ai_chat_entity.dart';
import 'package:flutter_base_template/3rd_layer_domain/entities/ai_message_entity.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_ai_chat_repository.dart';
import 'package:flutter_base_template/4th_layer_infrastructure/models/ai_chat_model.dart';
import 'package:flutter_base_template/4th_layer_infrastructure/models/ai_message_model.dart';
import 'package:flutter_base_template/core/errors/ai_chat_errors.dart';

class AiChatRepository implements InterfaceAiChatRepository {
  static const String _COLLECTION_AI_CHATS = 'aiChats';
  static const String _COLLECTION_AI_MESSAGES = 'aiMessages';
  static const String _FIELD_TIMESTAMP = 'timestamp';
  static const String _FIELD_MESSAGE = 'message';
  final FirebaseFirestore _firestore;

  AiChatRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  // init
  @override
  Future<void> initNewAiChat({required AiChatEntity aiChatEntity}) async {
    try {
      final aiChatModel = AiChatModel.fromDomain(aiChatEntity);
      await _firestore
          .collection(_COLLECTION_AI_CHATS)
          .doc(aiChatModel.chatID)
          .set(aiChatModel.toMap());
    } catch (_) {
      throw ErrorAiChatInitNew();
    }
  }

  // store message
  @override
  Future<void> storeMessageInAiChat(
      {required AiMessageEntity aiMessageEntity, required String aiChatID}) async {
    try {
      final aiMessageModel = AiMessageModel.fromDomain(aiMessageEntity);
      await _firestore
          .collection(_COLLECTION_AI_CHATS)
          .doc(aiChatID)
          .collection(_COLLECTION_AI_MESSAGES)
          .doc(aiMessageModel.messageID)
          .set(aiMessageModel.toMap());
      await _firestore.collection(_COLLECTION_AI_CHATS).doc(aiChatID).update({
        _FIELD_TIMESTAMP: aiMessageModel.timestamp,
      });
    } catch (_) {
      throw ErrorAiChatStoreMessage();
    }
  }

  // update message
  @override
  Future<void> updateMessageInAiChat(
      {required AiMessageEntity aiMessageEntity, required String aiChatID}) async {
    try {
      final aiMessageModel = AiMessageModel.fromDomain(aiMessageEntity);
      await _firestore
          .collection(_COLLECTION_AI_CHATS)
          .doc(aiChatID)
          .collection(_COLLECTION_AI_MESSAGES)
          .doc(aiMessageModel.messageID)
          .update({
        _FIELD_MESSAGE: aiMessageModel.message,
        _FIELD_TIMESTAMP: aiMessageModel.timestamp,
      });
      await _firestore.collection(_COLLECTION_AI_CHATS).doc(aiChatID).update({
        _FIELD_TIMESTAMP: aiMessageModel.timestamp,
      });
    } catch (_) {
      throw ErrorAiChatStoreMessage();
    }
  }

  // delete message
  @override
  Future<void> deleteMessageInAiChat(
      {required String aiMessageID, required String aiChatID}) async {
    try {
      await _firestore
          .collection(_COLLECTION_AI_CHATS)
          .doc(aiChatID)
          .collection(_COLLECTION_AI_MESSAGES)
          .doc(aiMessageID)
          .delete();
    } catch (_) {
      throw ErrorAiChatDeleteMessage();
    }
  }

  // stream messages
  @override
  Stream<List<AiMessageEntity>> streamAiChatMessages({required String aiChatID}) {
    return _firestore
        .collection(_COLLECTION_AI_CHATS)
        .doc(aiChatID)
        .collection(_COLLECTION_AI_MESSAGES)
        .orderBy(_FIELD_TIMESTAMP)
        .snapshots()
        .map((snapshot) {
      List<AiMessageEntity> aiMessages = [];
      for (var document in snapshot.docs) {
        final aiMessageEntity = AiMessageModel.fromMap(document.data()).toDomain();
        if (aiMessageEntity.message.isEmpty) {
          checkTimeout(aiMessageEntity: aiMessageEntity, aiChatID: aiChatID);
        }
        aiMessages.add(aiMessageEntity);
      }
      return aiMessages;
    });
  }

  // check timeout
  Future<void> checkTimeout(
      {required AiMessageEntity aiMessageEntity, required String aiChatID}) async {
    // timeout depends on the chat-gpt model
    await Future.delayed(Duration(seconds: 10));
    try {
      final snapshot = await _firestore
          .collection(_COLLECTION_AI_CHATS)
          .doc(aiChatID)
          .collection(_COLLECTION_AI_MESSAGES)
          .doc(aiMessageEntity.messageID)
          .get();
      final message = AiMessageModel.fromMap(snapshot.data()!);
      if (message.message.isEmpty) {
        final aiMessageEntityError = aiMessageEntity.updateMessageWithTimestamp('error');
        updateMessageInAiChat(aiMessageEntity: aiMessageEntityError, aiChatID: aiChatID);
      }
    } catch (_) {}
  }
}
