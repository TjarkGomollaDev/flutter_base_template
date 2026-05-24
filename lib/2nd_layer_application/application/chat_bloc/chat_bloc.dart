import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mark_lxxxv/3rd_layer_domain/entities/message_entity.dart';
import 'package:mark_lxxxv/3rd_layer_domain/interfaces_repositories/interface_chat_repository.dart';
import 'package:mark_lxxxv/core/datatypes/doubly_linked_list.dart';
import 'package:mark_lxxxv/core/enums/message_type.dart';
import 'package:mark_lxxxv/core/validators/input_auth_validators.dart';
import 'dart:async';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final InterfaceChatRepository _chatRepository;
  StreamSubscription<List<MessageEntity>>? _chatSubscription;

  ChatBloc({
    required InterfaceChatRepository chatRepository,
  })  : _chatRepository = chatRepository,
        super(ChatState.initial()) {
    on<ChatEventUpdateUserInputMessage>(_onUpdateUserInputMessage);
    on<ChatEventOpenChat>(_onOpenChat);
    on<_ChatEventStreamChatMessagesUpdated>(_onStreamChatMessagesUpdated);
    on<ChatEventCloseChat>(_onCloseChat);
    on<ChatEventSendTextMessage>(_onSendTextMessage);
  }

  void _onUpdateUserInputMessage(ChatEventUpdateUserInputMessage event, Emitter<ChatState> emit) {
    final bool validationMessage =
        InputAuthValidators.validateInputIsNotEmpty(input: event.message);
    emit(state.copyWith(
      userInput: event.message,
      isMessageValid: validationMessage,
    ));
  }

  void _onOpenChat(ChatEventOpenChat event, Emitter<ChatState> emit) {
    // message später aus SharedPreferences ziehen, damit beim Wechsel von Chats nicht die Messages gelöscht/überschrieben werden
    emit(
      state.copyWith(
        chatID: event.chatID,
        senderID: event.senderID,
        userInput: '',
        messages: DoublyLinkedList(),
      ),
    );
    _chatSubscription?.cancel();
    _chatSubscription = _chatRepository.streamChatMessages(chatID: state.chatID).listen(
      (newMessages) {
        add(_ChatEventStreamChatMessagesUpdated(newMessages: newMessages));
      },
    );
  }

  void _onStreamChatMessagesUpdated(
      _ChatEventStreamChatMessagesUpdated event, Emitter<ChatState> emit) {
    for (var message in event.newMessages) {
      state.messages.prepend(message);
    }

    // emit(state.copyWith(allMessages: newMessages));
    // state.allMessages.addAll(event.newMessages);
    // muss sich noch was überlegt werden, wie das behoben werden kann
    emit(state.copyWith(counter: state.counter + 1));
  }

  void _onCloseChat(ChatEventCloseChat event, Emitter<ChatState> emit) {
    _chatSubscription?.cancel();
    emit(ChatState.initial());
  }

  void _onSendTextMessage(ChatEventSendTextMessage event, Emitter<ChatState> emit) {
    // if input is valid try Send
    if (state.isMessageValid) {
      try {
        final messageEntity = MessageEntity.newMessage(
          message: state.userInput,
          messageType: MessageType.text,
          senderID: state.senderID,
        );
        _chatRepository.saveData(messageEntity: messageEntity, chatID: state.chatID);
        emit(state.copyWith(userInput: '', isMessageValid: false));
      } catch (_) {
        // Eventuell Fehlermeldung anzeigen in der UI ?
      }
    }
  }

  @override
  Future<void> close() {
    _chatSubscription?.cancel();
    return super.close();
  }
}

// TODO
// close Event um von der Streamsubscription zu unsubscriben auf zurück button legen
// das mit emit ausprobieren in stream updated
// braucht man beim listview.builder überhaupt das nur die letzten änderungen in die liste kommen ?