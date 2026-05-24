import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/core_formatted_chat_text.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/core_label_btn.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/core_typewriter_text.dart';
import 'package:mark_lxxxv/2nd_layer_application/application/ai_chat/ai_chat_bloc.dart';
import 'package:mark_lxxxv/3rd_layer_domain/entities/ai_message_entity.dart';
import 'package:mark_lxxxv/app_constants.dart';
import 'package:mark_lxxxv/app_theme.dart';
import 'package:mark_lxxxv/core/extensions/build_context_extensions.dart';
import 'package:mark_lxxxv/core/extensions/int_double_extensions.dart';
import 'package:mark_lxxxv/core/extensions/theme_extensions.dart';

class AiChatBubble extends StatelessWidget {
  final AiMessageEntity aiMessageEntity;
  final bool animation;
  final VoidCallback callbackSrollToBottom;

  const AiChatBubble({
    super.key,
    required this.aiMessageEntity,
    required this.animation,
    required this.callbackSrollToBottom,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    final screenWidth = context.sizeOf.width;
    final aiAvatarSize = Size.square(32);
    return Align(
      alignment: aiMessageEntity.isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ai avatar
          if (!aiMessageEntity.isMyMessage)
            Container(
              width: aiAvatarSize.width,
              height: aiAvatarSize.height,
              margin: EdgeInsets.only(top: AppConstants.SPACE_VERTICAL_XS / 2),
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(color: themeData.colorPalette.gray3, width: 1.2),
                borderRadius: BorderRadius.circular(AppConstants.RADIUS_XXL),
              ),
              child: Image.asset(
                'assets/icons/chat-gpt.png',
                color: themeData.colorPalette.onPrimary,
              ),
            ),
          // message bubble
          Container(
            constraints: BoxConstraints(
              maxWidth: aiMessageEntity.isMyMessage
                  ? (screenWidth - 2 * AppConstants.PAGE_PADDING_HORIZONTAL) * 0.8
                  : (screenWidth - 2 * AppConstants.PAGE_PADDING_HORIZONTAL - aiAvatarSize.width) *
                      0.95,
            ),
            // space between massages
            margin: EdgeInsets.only(bottom: AppConstants.SPACE_VERTICAL_M),
            padding: aiMessageEntity.isMyMessage
                ? const EdgeInsets.symmetric(
                    horizontal: AppConstants.SPACE_HORIZONTAL_M,
                    vertical: AppConstants.SPACE_VERTICAL_XS,
                  )
                : aiMessageEntity.message.isEmpty
                    ? EdgeInsets.only(
                        left: AppConstants.SPACE_HORIZONTAL_M,
                        top: AppConstants.SPACE_VERTICAL_XS / 2,
                      )
                    : EdgeInsets.symmetric(vertical: AppConstants.SPACE_VERTICAL_XS).copyWith(
                        left: AppConstants.SPACE_HORIZONTAL_S,
                      ),
            decoration: BoxDecoration(
              color:
                  aiMessageEntity.isMyMessage ? themeData.colorPalette.gray5 : AppTheme.transparent,
              borderRadius: BorderRadius.circular(AppConstants.RADIUS_XL),
            ),
            // content
            child: aiMessageEntity.isMyMessage
                ? Text(
                    aiMessageEntity.message,
                    style: themeData.textTheme.bodyLarge,
                    textWidthBasis: TextWidthBasis.longestLine,
                  )
                : aiMessageEntity.message.isEmpty
                    ? Transform.scale(
                        scale: 1.4,
                        child: LottieBuilder.asset(
                          'assets/lottie/loading_light.json',
                          height: aiAvatarSize.height,
                        ),
                      )
                    : aiMessageEntity.message == 'error'
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hmmm... something went wrong.',
                                style: themeData.textTheme.bodyLarge,
                                textWidthBasis: TextWidthBasis.longestLine,
                              ),
                              AppConstants.SPACE_VERTICAL_XS.heightSizedBox,
                              CoreLabelBtn(
                                name: 'Try again',
                                textColor: themeData.colorPalette.error,
                                callback: () => context.read<AiChatBloc>().add(
                                      AiChatEventRegenerate(regnerateMessage: aiMessageEntity),
                                    ),
                              )
                            ],
                          )
                        : animation
                            ? CoreTypewriterText(
                                text: aiMessageEntity.message,
                                style: themeData.textTheme.bodyLarge,
                                onCharacterTyped: callbackSrollToBottom,
                                onAnimationEnd: () =>
                                    context.read<AiChatBloc>().add(AiChatEventRequestSuccessful()),
                              )
                            : CoreFormattedChatText(
                                text: aiMessageEntity.message,
                                style: themeData.textTheme.bodyLarge,
                              ),
          ),
        ],
      ),
    );
  }
}
