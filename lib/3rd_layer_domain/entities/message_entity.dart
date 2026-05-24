import 'package:uuid/uuid.dart';

import 'package:mark_lxxxv/core/enums/message_type.dart';

class MessageEntity {
  final String message;
  final MessageType messageType;
  final String messageID;
  final String senderID;
  final DateTime timeSent;
  final bool isSeen;

  const MessageEntity({
    required this.message,
    required this.messageType,
    required this.messageID,
    required this.senderID,
    required this.timeSent,
    required this.isSeen,
  });

  MessageEntity.newMessage({
    required String message,
    required MessageType messageType,
    required String senderID,
  }) : this(
          message: message,
          messageType: messageType,
          messageID: const Uuid().v1(),
          senderID: senderID,
          timeSent: DateTime.now(),
          isSeen: false,
        );
}
