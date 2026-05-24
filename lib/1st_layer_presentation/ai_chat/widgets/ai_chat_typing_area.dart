import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets.dart/core_label_icon_btn.dart';
import 'package:flutter_base_template/2nd_layer_application/application/ai_chat/ai_chat_bloc.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/app_theme.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';
import 'package:flutter_base_template/core/extensions/theme_extensions.dart';

class AiChatTypingArea extends StatelessWidget {
  const AiChatTypingArea({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    final themeData = context.theme;
    return ClipRRect(
      child: BackdropFilter(
        filter: AppConstants.BLUR_FILTER,
        child: Container(
          color: themeData.colorPalette.primary.withAlpha(191),
          child: SafeArea(
            minimum: EdgeInsets.only(bottom: AppConstants.SAFE_AREA_MIN_PADDING_BTM),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.PAGE_PADDING_HORIZONTAL,
              ).copyWith(top: AppConstants.SPACE_VERTICAL_XS),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autocorrect: false,
                      textAlignVertical: TextAlignVertical.center,
                      style: themeData.textTheme.bodyLarge,
                      cursorHeight: AppConstants.CURSOR_HEIGHT,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        enabledBorder: AppTheme.disabledBorderRound,
                        focusedBorder: AppTheme.disabledBorderRound,
                        hintText: 'Message',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(
                            left: AppConstants.SPACE_HORIZONTAL_M,
                            right: AppConstants.SPACE_HORIZONTAL_S,
                          ),
                          child: Icon(
                            Icons.add,
                            size: AppConstants.INPUT_FIELD_ICON_SIZE,
                            color: themeData.colorPalette.onPrimary,
                          ),
                        ),
                        suffixIcon: BlocBuilder<AiChatBloc, AiChatState>(
                          buildWhen: (previous, current) => previous.flag != current.flag,
                          builder: (context, state) {
                            if (state.flag == AiChatFlag.readyToSent) {
                              // send button
                              return Padding(
                                padding: const EdgeInsets.only(
                                  left: AppConstants.SPACE_HORIZONTAL_S,
                                  right: AppConstants.SPACE_HORIZONTAL_M -
                                      (AppConstants.LABEL_BTN_HEIGHT -
                                              AppConstants.INPUT_FIELD_ICON_SIZE) /
                                          2,
                                ),
                                child: CoreLabelIconBtn(
                                  icon: Icons.arrow_forward,
                                  color: themeData.colorPalette.onPrimary,
                                  iconColor: themeData.colorPalette.primary,
                                  callback: () {
                                    controller.clear();
                                    FocusScope.of(context).unfocus();
                                    context.read<AiChatBloc>().add(AiChatEventSendMessage());
                                  },
                                ),
                              );
                            } else if (state.flag == AiChatFlag.submitting) {
                              // pause button
                              return Padding(
                                padding: const EdgeInsets.only(
                                  left: AppConstants.SPACE_HORIZONTAL_S,
                                  right: AppConstants.SPACE_HORIZONTAL_M -
                                      (AppConstants.LABEL_BTN_HEIGHT -
                                              AppConstants.INPUT_FIELD_ICON_SIZE) /
                                          2,
                                ),
                                child: CoreLabelIconBtn(
                                  icon: Icons.pause_outlined,
                                  color: themeData.colorPalette.onPrimary,
                                  iconColor: themeData.colorPalette.primary,
                                  callback: () {},
                                ),
                              );
                            } else {
                              // mic button
                              return GestureDetector(
                                onTap: () =>
                                    context.read<AiChatBloc>().add(AiChatEventSendMessage()),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: AppConstants.SPACE_HORIZONTAL_S,
                                    right: AppConstants.SPACE_HORIZONTAL_M,
                                  ),
                                  child: Icon(
                                    Icons.mic_outlined,
                                    size: AppConstants.INPUT_FIELD_ICON_SIZE,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      controller: controller,
                      onChanged: (value) => context
                          .read<AiChatBloc>()
                          .add(AiChatEventUpdateTextfield(textfield: value)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
