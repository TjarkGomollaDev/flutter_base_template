import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mark_lxxxv/1st_layer_presentation/ai_chat/widgets/ai_chat_bubble.dart';
import 'package:mark_lxxxv/1st_layer_presentation/ai_chat/widgets/ai_chat_chip.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/core_label_icon_btn.dart';
import 'package:mark_lxxxv/2nd_layer_application/application/ai_chat/ai_chat_bloc.dart';
import 'package:mark_lxxxv/app_constants.dart';
import 'package:mark_lxxxv/core/extensions/build_context_extensions.dart';
import 'package:mark_lxxxv/core/extensions/theme_extensions.dart';

class AiChatBody extends StatefulWidget {
  const AiChatBody({super.key});

  @override
  State<AiChatBody> createState() => _AiChatBodyState();
}

class _AiChatBodyState extends State<AiChatBody> {
  late final ScrollController _scrollController;
  late final ValueNotifier<bool> _isAtBottomNotifier;
  bool start = true;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(
        () {
          bool isAtBottom =
              _scrollController.offset - 20 < _scrollController.position.minScrollExtent;
          if (_isAtBottomNotifier.value != isAtBottom) {
            _isAtBottomNotifier.value = isAtBottom;
          }
        },
      );
    _isAtBottomNotifier = ValueNotifier(true);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _isAtBottomNotifier.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        Future.delayed(Duration(milliseconds: 50), () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    return Stack(
      children: [
        // chat body
        Positioned.fill(
          left: AppConstants.PAGE_PADDING_HORIZONTAL,
          right: AppConstants.PAGE_PADDING_HORIZONTAL,
          top: AppConstants.LABEL_BTN_HEIGHT + AppConstants.SPACE_VERTICAL_XS * 2,
          child: BlocConsumer<AiChatBloc, AiChatState>(
            listenWhen: (previous, current) =>
                current.messages.length > previous.messages.length ||
                (previous.messages.isNotEmpty &&
                    current.messages.isNotEmpty &&
                    previous.messages.last != current.messages.last),
            listener: (context, state) {
              _scrollToBottom();
            },
            buildWhen: (previous, current) =>
                previous.messages != current.messages ||
                previous.toAnimateMessageID != current.toAnimateMessageID,
            builder: (context, state) {
              return Align(
                alignment: Alignment.topCenter,
                child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: state.messages.length,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    final aiMessageEntity = state.messages[state.messages.length - 1 - index];
                    return AiChatBubble(
                      aiMessageEntity: aiMessageEntity,
                      animation: !aiMessageEntity.isMyMessage &&
                          aiMessageEntity.messageID == state.toAnimateMessageID,
                      callbackSrollToBottom: _scrollToBottom,
                    );
                  },
                ),
              );
            },
          ),
        ),
        // recent chats list
        Positioned(
          top: MediaQuery.paddingOf(context).top + AppConstants.SPACE_VERTICAL_XS,
          left: 0,
          right: 0,
          child: SizedBox(
            height: AppConstants.LABEL_BTN_HEIGHT,
            child: ListView.builder(
              itemCount: chipsInfo.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return AiChatChip(
                  name: chipsInfo[index],
                  index: index,
                );
              },
            ),
          ),
        ),
        // scroll to bottom button
        Positioned(
          bottom: MediaQuery.paddingOf(context).bottom + AppConstants.SPACE_VERTICAL_S,
          left: 0,
          right: 0,
          child: ValueListenableBuilder(
            valueListenable: _isAtBottomNotifier,
            builder: (context, isAtBottom, child) {
              return AnimatedScale(
                scale: isAtBottom ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: CoreLabelIconBtn(
                  icon: Icons.arrow_downward_outlined,
                  color: themeData.colorPalette.primary,
                  iconColor: themeData.colorPalette.onPrimary,
                  boxShadow: themeData.shadowPalette.primaryBtnShadow,
                  callback: _scrollToBottom,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

const List<String> chipsInfo = [
  'Chat 1',
  'Chat 2',
  'Chat 3',
  'Chat 4',
  'Chat 5',
];
