import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultation_app/models/message_model.dart';
import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/models/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MessagingPage extends StatefulWidget {
  final UserModel currentUser;
  final Map otherUser;

  MessagingPage({this.currentUser, this.otherUser});

  @override
  _MessagingPageState createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  var _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final _viewModel = Provider.of<UserViewModel>(context);
    UserModel _currentUser = widget.currentUser;
    Map _otherUser = widget.otherUser;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(widget.otherUser["profileURL"]),
            ),
            SizedBox(width: 10,),
            Text(_otherUser["nameSurname"]),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Message>>(
                stream: _viewModel.getMessages(
                    _currentUser.userId, _otherUser["userId"]),
                builder: (context, streamMessagesList) {
                  if (!streamMessagesList.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  List<Message> allMessages = streamMessagesList.data;
                  return ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      return _createChatBalloon(allMessages[index]);
                    },
                    itemCount: allMessages.length,
                  );
                },
              ),
            ),
            Container(
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
                            sender: _currentUser.userId,
                            receiver: _otherUser["userId"],
                            isFromCurrentUser: true,
                            message: _messageController.text,
                          );
                          var result = await _viewModel.saveMessage(_message);
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _createChatBalloon(Message snapMessage) {
    Color _receiverMessageColor = Colors.lightBlue;
    Color _senderMessageColor = Colors.green.shade300;

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
                  backgroundImage: NetworkImage(widget.otherUser["profileURL"]),
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
}
