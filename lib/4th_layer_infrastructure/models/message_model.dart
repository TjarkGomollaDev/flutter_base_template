import 'package:mark_lxxxv/3rd_layer_domain/entities/message_entity.dart';
import 'package:mark_lxxxv/core/enums/message_type.dart';

class MessageModel {
  final String message;
  final String messageType;
  final String messageID;
  final String senderID;
  final int timeSent;
  final bool isSeen;

  MessageModel({
    required this.message,
    required this.messageType,
    required this.messageID,
    required this.senderID,
    required this.timeSent,
    required this.isSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'messageType': messageType,
      'messageID': messageID,
      'senderID': senderID,
      'timeSent': timeSent,
      'isSeen': isSeen,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      message: map['message'] as String,
      messageType: map['messageType'] as String,
      messageID: map['messageID'] as String,
      senderID: map['senderID'] as String,
      timeSent: map['timeSent'] as int,
      isSeen: map['isSeen'] as bool,
    );
  }

  MessageEntity toDomain() {
    return MessageEntity(
      message: message,
      messageType: messageType.toEnum(),
      messageID: messageID,
      senderID: senderID,
      timeSent: DateTime.fromMillisecondsSinceEpoch(timeSent),
      isSeen: isSeen,
    );
  }

  factory MessageModel.fromDomain(MessageEntity messageEntity) {
    return MessageModel(
      message: messageEntity.message,
      messageType: messageEntity.messageType.type,
      messageID: messageEntity.messageID,
      senderID: messageEntity.senderID,
      timeSent: messageEntity.timeSent.millisecondsSinceEpoch,
      isSeen: messageEntity.isSeen,
    );
  }
}
