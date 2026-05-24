import 'package:mark_lxxxv/3rd_layer_domain/entities/ai_chat_entity.dart';

class AiChatModel {
  final String titel;
  final String chatID;
  final int timestamp;

  AiChatModel({
    required this.titel,
    required this.chatID,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'titel': titel,
      'chatID': chatID,
      'timestamp': timestamp,
    };
  }

  factory AiChatModel.fromMap(Map<String, dynamic> map) {
    return AiChatModel(
      titel: map['titel'] as String,
      chatID: map['chatID'] as String,
      timestamp: map['timestamp'] as int,
    );
  }

  AiChatEntity toDomain() {
    return AiChatEntity(
      titel: titel,
      chatID: chatID,
      timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp),
    );
  }

  factory AiChatModel.fromDomain(AiChatEntity aiChatEntity) {
    return AiChatModel(
      titel: aiChatEntity.titel,
      chatID: aiChatEntity.chatID,
      timestamp: aiChatEntity.timestamp.millisecondsSinceEpoch,
    );
  }
}
