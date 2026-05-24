import 'package:flutter/material.dart';
import 'package:mark_lxxxv/app_constants.dart';
import 'package:mark_lxxxv/app_theme.dart';
import 'package:mark_lxxxv/core/extensions/int_double_extensions.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height chat tile
      height: 70,
      // space between the chat tiles
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          // profile picture
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/backgrounds/Maurice.jpeg',
              width: 55,
              height: 55,
              fit: BoxFit.cover,
            ),
          ),
          AppConstants.SPACE_HORIZONTAL_M.widthSizedBox,
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppTheme.grayLight5)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // username
                      const Text(
                        'Tjark Gomolla',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      // time last message
                      const Text(
                        'Monday',
                        style: TextStyle(color: AppTheme.grayLight1),
                      ),
                      AppConstants.SPACE_HORIZONTAL_S.widthSizedBox,
                      // arrow icon -> open the chat
                      const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: AppTheme.grayLight3,
                        size: 16,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // last message
                      const Expanded(
                        child: Text(
                          'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.',
                          style: TextStyle(color: AppTheme.grayLight1, fontSize: 15),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      AppConstants.SPACE_HORIZONTAL_M.widthSizedBox,
                      //count messages
                      ClipOval(
                        child: Container(
                          height: 20,
                          width: 20, //! Switch case für höhere Zahlen bis 999+
                          color: AppTheme.blueLight,
                          child: const Center(
                            child: Text(
                              '5',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
