import 'package:uuid/uuid.dart';

class AiMessageEntity {
  final String message;
  final String messageID;
  final DateTime timestamp;
  final bool isMyMessage;

  const AiMessageEntity({
    required this.message,
    required this.messageID,
    required this.timestamp,
    required this.isMyMessage,
  });

  AiMessageEntity.newAiMessage({
    required String message,
    required bool isMyMessage,
  }) : this(
          message: message,
          messageID: const Uuid().v1(),
          timestamp: DateTime.now(),
          isMyMessage: isMyMessage,
        );

  AiMessageEntity updateMessageWithTimestamp(String message) {
    return AiMessageEntity(
      message: message,
      messageID: messageID,
      timestamp: DateTime.now(),
      isMyMessage: isMyMessage,
    );
  }

  AiMessageEntity updateMessageWithoutTimestamp(String message) {
    return AiMessageEntity(
      message: message,
      messageID: messageID,
      timestamp: timestamp,
      isMyMessage: isMyMessage,
    );
  }
}
