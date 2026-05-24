part of 'ai_chat_bloc.dart';

@immutable
sealed class AiChatEvent {
  const AiChatEvent();
}

class AiChatEventUpdateTextfield extends AiChatEvent {
  final String textfield;
  const AiChatEventUpdateTextfield({required this.textfield});
}

class AiChatEventSendMessage extends AiChatEvent {}

class AiChatEventRequestSuccessful extends AiChatEvent {}

class _AiChatEventDeleteMessageInBloc extends AiChatEvent {
  final String aiMessageID;

  const _AiChatEventDeleteMessageInBloc({required this.aiMessageID});
}

class AiChatEventRegenerate extends AiChatEvent {
  final AiMessageEntity regnerateMessage;

  const AiChatEventRegenerate({required this.regnerateMessage});
}

class _AiChatEventStreamMessagesUpdated extends AiChatEvent {
  final List<AiMessageEntity> messages;
  const _AiChatEventStreamMessagesUpdated({required this.messages});
}

class AiChatEventOpenChat extends AiChatEvent {}
