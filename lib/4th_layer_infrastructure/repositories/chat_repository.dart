import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_base_template/3rd_layer_domain/entities/chat_entity.dart';
import 'package:flutter_base_template/3rd_layer_domain/entities/message_entity.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_chat_repository.dart';
import 'package:flutter_base_template/4th_layer_infrastructure/models/chat_model.dart';
import 'package:flutter_base_template/4th_layer_infrastructure/models/message_model.dart';
import 'package:flutter_base_template/core/enums/message_type.dart';
import 'package:flutter_base_template/core/errors/chat_errors.dart';

class ChatRepository implements InterfaceChatRepository {
  final FirebaseFirestore _firestore;

  ChatRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  @override
  void saveData({
    required MessageEntity messageEntity,
    required String chatID,
  }) {
    try {
      final messageModel = MessageModel.fromDomain(messageEntity);

      if (messageModel.messageType == MessageType.text.type) {
        _saveText(messageModel: messageModel, chatID: chatID);
      } else {
        _saveFile(messageModel: messageModel);
      }
    } catch (_) {
      throw ErrorChatGeneral();
    }
  }

  void _saveText({
    required MessageModel messageModel,
    required String chatID,
  }) {
    // save message to firebase
    _saveToMessagesCollection(messageModel: messageModel, chatID: chatID);

    // update last Message (ChatModel)
    _updateChatsCollection(
      messageModel: messageModel,
      chatID: chatID,
    );
  }

  void _saveFile({
    required MessageModel messageModel,
  }) {}

  void _saveToMessagesCollection(
      {required MessageModel messageModel, required String chatID}) async {
    await _firestore
        .collection('chats')
        .doc(chatID)
        .collection('messages')
        .doc(messageModel.messageID)
        .set(messageModel.toMap());
  }

  void _updateChatsCollection({
    required MessageModel messageModel,
    required String chatID,
  }) async {
    await _firestore.collection('chats').doc(chatID).update({
      'lastMessage': messageModel.message,
      'timeSent': messageModel.timeSent,
    });
  }

  @override
  void initChatDocument({required ChatEntity chatEntity}) async {
    final ChatModel chatModel = ChatModel.fromDomain(chatEntity);
    await _firestore.collection('chats').doc(chatModel.chatID).set(chatModel.toMap());
  }

  @override
  Stream<List<MessageEntity>> streamChatMessages({required String chatID}) {
    return _firestore
        .collection('chats')
        .doc(chatID)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((snapshot) {
      List<MessageEntity> messages = [];
      for (var changes in snapshot.docChanges) {
        if (changes.doc.data() != null) {
          final message = MessageModel.fromMap(changes.doc.data()!).toDomain();
          messages.add(message);
        }
      }
      return messages;
    });
  }

  //! whereIn auf 10 oder 30 elemente begrenzt, demnach die chatIDs in 10er/30er chunks aufteilen und mehrmals etwas aus
  //! der db holen
  @override
  Stream<List<ChatEntity>> streamChats({required List<String> chatIDs}) {
    // if the list is empty the whereIn condition doesn't work, to prevent this an empty Stream is
    if (chatIDs.isEmpty) {
      return const Stream.empty();
    }
    return _firestore
        .collection("chats")
        .where("chatID", whereIn: chatIDs)
        .snapshots()
        .map((snapshot) {
      List<ChatEntity> chats = [];
      for (var doc in snapshot.docs) {
        final chat = ChatModel.fromMap(doc.data()).toDomain();
        chats.add(chat);
      }
      return chats;
    });
  }
}

// Future<void> einbauen

/*
List<List<T>> splitList<T>(List<T> list, int chunkSize) {
  List<List<T>> chunks = [];
  for (var i = 0; i < list.length; i += chunkSize) {
    var end = (i + chunkSize < list.length) ? i + chunkSize : list.length;
    chunks.add(list.sublist(i, end));
  }
  return chunks;
}


Stream<List<ChatEntity>> getChatsStream({required List<String> chatIDs}) {
  // Split the IDs into chunks of 10
  List<List<String>> chunks = splitList(chatIDs, 10);

  // Map each chunk to a stream and merge them
  return Stream.fromIterable(chunks).asyncMap((chunk) {
    return _firestore.collection("chats")
        .where("chatID", whereIn: chunk)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .where((doc) => doc.data() != null)
              .map((doc) => ChatModel.fromMap(doc.data()!).toDomain())
              .toList();
        });
  }).flatMap((stream) => stream);
}


*/