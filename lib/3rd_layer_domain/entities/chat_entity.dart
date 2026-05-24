import 'package:uuid/uuid.dart';

class ChatEntity {
  final String chatID;
  final List<String> members;
  final String lastMessage;
  final DateTime timeSent;
  final List<String>? typingMembers;

  const ChatEntity({
    required this.chatID,
    required this.members,
    required this.lastMessage,
    required this.timeSent,
    required this.typingMembers,
  });

  ChatEntity.newChat({
    required List<String> members,
  }) : this(
          chatID: const Uuid().v1(),
          members: members,
          lastMessage: 'New Chat was created',
          timeSent: DateTime.now(),
          typingMembers: null,
        );
}
