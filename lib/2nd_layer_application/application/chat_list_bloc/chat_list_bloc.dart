import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_auth_repository.dart';
import 'package:meta/meta.dart';
import 'package:flutter_base_template/3rd_layer_domain/entities/chat_entity.dart';
import 'package:flutter_base_template/3rd_layer_domain/entities/user_contact_info_entity.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_chat_repository.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_user_repository.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final InterfaceAuthRepository _authRepository;
  final InterfaceUserRepository _userRepository;
  final InterfaceChatRepository _chatRepository;
  StreamSubscription<List<ChatEntity>>? _chatsSubscription;
  StreamSubscription<List<String>>? _chatIDsSubscription;

  ChatListBloc({
    required InterfaceAuthRepository authRepository,
    required InterfaceUserRepository userRepository,
    required InterfaceChatRepository chatRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        _chatRepository = chatRepository,
        super(ChatListState.initial()) {
    on<ChatListEventStreamChatIDsUpdated>(_onStreamChatIDsUpdated);
    on<ChatListEventStreamChatsUpdated>(_onStreamChatsUpdated);

    _chatIDsSubscription =
        _userRepository.streamChatIDs(userID: _authRepository.currentAuthUser.id).listen((chatIDs) {
      add(ChatListEventStreamChatIDsUpdated(chatIDs: chatIDs));
    });

    //_restart();
  }

  void _restart() {
    _chatsSubscription = _chatRepository.streamChats(chatIDs: state.chatIDs).listen((chats) {
      add(ChatListEventStreamChatsUpdated(chats: chats));
    });
  }

  void _onStreamChatIDsUpdated(
      ChatListEventStreamChatIDsUpdated event, Emitter<ChatListState> emit) {
    emit(state.copyWith(chatIDs: event.chatIDs));
    // every time the chatIDs changes, the _chatSubscription must be restarted, because the method paramter has changed
    _restart();
  }

  void _onStreamChatsUpdated(ChatListEventStreamChatsUpdated event, Emitter<ChatListState> emit) {
    emit(state.copyWith(chats: event.chats));
  }

  @override
  Future<void> close() {
    _chatIDsSubscription?.cancel();
    _chatsSubscription?.cancel();
    return super.close();
  }
}
