import 'package:mark_lxxxv/3rd_layer_domain/entities/chat_entity.dart';

class ChatModel {
  final String chatID;
  final List<String> members;
  final String lastMessage;
  final int timeSent;
  final List<String>? typingMembers;

  ChatModel({
    required this.chatID,
    required this.members,
    required this.lastMessage,
    required this.timeSent,
    required this.typingMembers,
  });

  Map<String, dynamic> toMap() {
    return {
      'chatID': chatID,
      'members': members,
      'lastMessage': lastMessage,
      'timeSent': timeSent,
      'typingMembers': typingMembers,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      chatID: map['chatID'] as String,
      members: List<String>.from(map['members']),
      lastMessage: map['lastMessage'] as String,
      timeSent: map['timeSent'] as int,
      typingMembers: map['typingMembers'] != null ? List<String>.from(map['typingMembers']) : null,
    );
  }

  ChatEntity toDomain() {
    return ChatEntity(
      chatID: chatID,
      members: members,
      lastMessage: lastMessage,
      timeSent: DateTime.fromMillisecondsSinceEpoch(timeSent),
      typingMembers: typingMembers,
    );
  }

  factory ChatModel.fromDomain(ChatEntity chatEntity) {
    return ChatModel(
      chatID: chatEntity.chatID,
      members: chatEntity.members,
      lastMessage: chatEntity.lastMessage,
      timeSent: chatEntity.timeSent.millisecondsSinceEpoch,
      typingMembers: chatEntity.typingMembers,
    );
  }
}
