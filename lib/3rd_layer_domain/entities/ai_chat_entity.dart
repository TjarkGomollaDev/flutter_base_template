import 'package:uuid/uuid.dart';

class AiChatEntity {
  final String titel;
  final String chatID;
  final DateTime timestamp;

  const AiChatEntity({
    required this.titel,
    required this.chatID,
    required this.timestamp,
  });

  AiChatEntity.newAiChat()
      : this(
          titel: 'New Chat',
          chatID: const Uuid().v1(),
          timestamp: DateTime.now(),
        );
}
