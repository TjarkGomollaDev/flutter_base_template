import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mark_lxxxv/1st_layer_presentation/chat/chat_list/widgets/chat_container.dart';
import 'package:mark_lxxxv/2nd_layer_application/application/chat_list_bloc/chat_list_bloc.dart';
import 'package:mark_lxxxv/app_constants.dart';
import 'package:mark_lxxxv/app_theme.dart';
import 'package:mark_lxxxv/core/extensions/int_double_extensions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final double headerHeight = 60.0;
  final double searchBarHeight = 60.0;
  double _scrollOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Stack(
        children: [
          // ChatList
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollUpdateNotification) {
                setState(() {
                  _scrollOffset += notification.scrollDelta!;
                });
              }
              return true;
            },
            // Change to StreamBuilder?!
            // child: SizedBox(),
            child: BlocBuilder<ChatListBloc, ChatListState>(
              builder: (context, state) {
                final allChats = state.chats;
                return ListView.builder(
                  padding: EdgeInsets.only(top: topPadding + headerHeight * 2 + 50),
                  // length + 1 to add the placeholder sizedBox at the end
                  itemCount: allChats.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == allChats.length) {
                      return 90.heightSizedBox;
                    }
                    var chatContainerData = allChats[index];
                    return ChatContainer(
                      chatID: chatContainerData.chatID,
                      message: chatContainerData.lastMessage,
                      timeSent: chatContainerData.timeSent,
                      username: "Tjark",
                      countNewMessages: 2,
                    );
                  },
                );
              },
            ),
          ),
          // Search Bar
          Positioned(
            top: topPadding + headerHeight * 2 + 5 - _scrollOffset,
            left: 0,
            right: 0,
            child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppConstants.PAGE_PADDING_HORIZONTAL),
                child: TextField(
                  autocorrect: false,
                  textAlignVertical: TextAlignVertical.center,
                  cursorHeight: 20,
                  decoration: InputDecoration(
                    constraints: BoxConstraints.tightFor(height: 36),
                    hintText: 'Search',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(
                        left: AppConstants.SPACE_HORIZONTAL_L,
                        right: AppConstants.SPACE_HORIZONTAL_S,
                      ),
                      child: Icon(Icons.search_outlined),
                    ),
                  ),
                )),
          ),
          // Messages Container
          Positioned(
            top: headerHeight +
                topPadding -
                (_scrollOffset <= searchBarHeight ? 0 : _scrollOffset - searchBarHeight),
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.PAGE_PADDING_HORIZONTAL),
              child: Container(
                height: headerHeight,
                color: AppTheme.white,
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Messages',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.PAGE_PADDING_HORIZONTAL),
              alignment: Alignment.bottomCenter,
              height: topPadding + headerHeight,
              color: AppTheme.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: const Text(
                      "Edit",
                      style: TextStyle(
                        color: AppTheme.blueLight,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _scrollOffset >= searchBarHeight * 2 - 20 ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: const Text(
                      'Messages',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Icon(
                      MdiIcons.squareEditOutline,
                      color: AppTheme.blueLight,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
