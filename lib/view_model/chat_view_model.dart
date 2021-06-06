import 'dart:async';

import 'package:consultation_app/models/message_model.dart';
import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:consultation_app/locator.dart';

enum ChatViewState { Idle, Loaded, Busy }

class ChatViewModel with ChangeNotifier {
  List<Message> _allMessages;
  ChatViewState _state = ChatViewState.Idle;
  static final valuePerPage = 10;
  UserRepository _userRepository = locator<UserRepository>();
  final UserModel currentUser;
  final UserModel otherUser;
  Message _lastMessage;
  Message _firstMessage;
  bool _hasMore = true;
  bool _newMessageListener = false;
  StreamSubscription _streamSubscription;

  ChatViewModel({this.currentUser, this.otherUser}) {
    _allMessages = [];
    getMessageWithPagination(false);
  }

  List<Message> get messageList => _allMessages;

  ChatViewState get state => _state;

  bool get hasMoreLoading => _hasMore;

  set state(ChatViewState value) {
    _state = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  void getMessageWithPagination(bool newMessagesLoading) async {
    if (_allMessages.length > 0) {
      _lastMessage = _allMessages.last;
    }

    if (!newMessagesLoading) state = ChatViewState.Busy;

    var incomingMessages = await _userRepository.getMessageWithPagination(
        currentUser.userId, otherUser.userId, _lastMessage, valuePerPage);

    if (incomingMessages.length < valuePerPage) {
      _hasMore = false;
    }

    _allMessages.addAll(incomingMessages);

    if (_allMessages.length > 0) {
      _firstMessage = _allMessages.first;
    }

    state = ChatViewState.Loaded;

    if (_newMessageListener == false) {
      _newMessageListener = true;
      getNewMessageListener();
    }
  }

  Future<bool> saveMessage(Message message) async {
    return await _userRepository.saveMessage(message);
  }

  Future<void> getMoreMessage() async {
    if (_hasMore)
      getMessageWithPagination(true);
    else
      await Future.delayed(Duration(seconds: 2));
  }

  void getNewMessageListener() {
    _streamSubscription = _userRepository
        .getMessages(currentUser.userId, otherUser.userId)
        .listen((snapData) {
      if (snapData.isNotEmpty) {

        if (snapData[0].date != null) {
          if (_firstMessage == null) {
            _allMessages.insert(0, snapData[0]);
          } else if (_firstMessage.date.millisecondsSinceEpoch !=
              snapData[0].date.millisecondsSinceEpoch)
            _allMessages.insert(0, snapData[0]);
        }

        state = ChatViewState.Loaded;
      }
    });
  }
}
