import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultation_app/models/message_model.dart';
import 'package:consultation_app/view_model/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MessagingPage extends StatefulWidget {
  @override
  _MessagingPageState createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  var _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    final _chatModel = Provider.of<ChatViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(_chatModel.otherUser.profileURL),
            ),
            SizedBox(
              width: 10,
            ),
            Text(_chatModel.otherUser.nameSurname),
          ],
        ),
      ),
      body: _chatModel.state == ChatViewState.Busy
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                children: [
                  _buildMessagesList(),
                  _buildEnterNewMessage(),
                ],
              ),
            ),
    );
  }

  Widget _buildMessagesList() {
    return Consumer<ChatViewModel>(
      builder: (context, chatModel, child) {
        return Expanded(
          child: ListView.builder(
            reverse: true,
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (chatModel.hasMoreLoading &&
                  chatModel.messageList.length == index) {
                return _newMessagesLoading();
              } else
                return _createChatBalloon(chatModel.messageList[index]);
            },
            itemCount: chatModel.hasMoreLoading == true
                ? chatModel.messageList.length + 1
                : chatModel.messageList.length,
          ),
        );
      },
    );
  }

  Widget _buildEnterNewMessage() {
    final _chatModel = Provider.of<ChatViewModel>(context);
    return Container(
      color: Colors.transparent,
      height: 60,
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              cursorColor: Color(0xff1616ff),
              style: TextStyle(fontSize: 16, color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 5, 8, 0),
                fillColor: Colors.green.shade100,
                filled: true,
                hintText: "Mesajınızı yazın",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green.shade300,
                  Colors.green.shade100,
                ],
              ),
            ),
            child: IconButton(
              icon: Icon(Icons.send),
              color: Colors.white,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () async {
                if (_messageController.text.trim().length > 0) {
                  Message _message = Message(
                    sender: _chatModel.currentUser.userId,
                    receiver: _chatModel.otherUser.userId,
                    isFromCurrentUser: true,
                    message: _messageController.text,
                  );
                  var result = await _chatModel.saveMessage(_message);
                  if (result) {
                    _messageController.clear();
                    _scrollController.animateTo(0.0,
                        duration: Duration(milliseconds: 10),
                        curve: Curves.easeOut);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _createChatBalloon(Message snapMessage) {
    Color _receiverMessageColor = Colors.lightBlue;
    Color _senderMessageColor = Colors.green.shade300;
    final _chatModel = Provider.of<ChatViewModel>(context, listen: false);

    var _currentTime = "";
    final now = DateTime.now();
    String formatter = DateFormat('Hm').format(now);

    try {
      _currentTime = _showTime(snapMessage.date ?? formatter);
    } catch (e) {}

    var _isCurrentUser = snapMessage.isFromCurrentUser;
    if (_isCurrentUser) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _senderMessageColor,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(snapMessage.message),
                  ),
                ),
                Text(_currentTime)
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage:
                      NetworkImage(_chatModel.otherUser.profileURL),
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _receiverMessageColor,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(
                      snapMessage.message,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(_currentTime)
              ],
            ),
          ],
        ),
      );
    }
  }

  String _showTime(Timestamp date) {
    var _formatter = DateFormat.Hm();
    var _formattedDate = _formatter.format(date.toDate());
    return _formattedDate;
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      getMoreMessage();
    }
  }

  Future<void> getMoreMessage() async {
    final _chatView = Provider.of<ChatViewModel>(context, listen: false);
    if (_isLoading == false) {
      _isLoading = true;
      await _chatView.getMoreMessage();
      _isLoading = false;
    }
  }

  _newMessagesLoading() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
