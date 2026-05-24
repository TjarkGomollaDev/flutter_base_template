import 'package:flutter_base_template/3rd_layer_domain/entities/ai_message_entity.dart';

class AiMessageModel {
  final String message;
  final String messageID;
  final int timestamp;
  final bool isMyMessage;

  AiMessageModel({
    required this.message,
    required this.messageID,
    required this.timestamp,
    required this.isMyMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'messageID': messageID,
      'timestamp': timestamp,
      'isMyMessage': isMyMessage,
    };
  }

  factory AiMessageModel.fromMap(Map<String, dynamic> map) {
    return AiMessageModel(
      message: map['message'] as String,
      messageID: map['messageID'] as String,
      timestamp: map['timestamp'] as int,
      isMyMessage: map['isMyMessage'] as bool,
    );
  }

  AiMessageEntity toDomain() {
    return AiMessageEntity(
      message: message,
      messageID: messageID,
      timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp),
      isMyMessage: isMyMessage,
    );
  }

  factory AiMessageModel.fromDomain(AiMessageEntity aiMessageEntity) {
    return AiMessageModel(
      message: aiMessageEntity.message,
      messageID: aiMessageEntity.messageID,
      timestamp: aiMessageEntity.timestamp.millisecondsSinceEpoch,
      isMyMessage: aiMessageEntity.isMyMessage,
    );
  }

  Map<String, String> toOpenAi() {
    return {
      'role': isMyMessage ? 'user' : 'assistant',
      'content': message,
    };
  }
}
