import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultation_app/common_widget/side_menu.dart';
import 'package:consultation_app/models/chats_model.dart';
import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/view_model/chat_view_model.dart';
import 'package:consultation_app/view_model/user_view_model.dart';
import 'package:consultation_app/screens/main_menu/messaging/messaging_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key key}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final FirebaseFirestore _firestoreDB = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    UserViewModel _viewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text("Mesajlar"),
      ),
      body: FutureBuilder<List<Chats>>(
        future: _viewModel.getAllConversations(_viewModel.user.userId),
        builder: (context, conversationList) {
          if (!conversationList.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var allConversations = conversationList.data;

            if (allConversations.length > 0) {
              return RefreshIndicator(
                onRefresh: _refreshChatList,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var snapshotChat = allConversations[index];
                    return GestureDetector(
                      onTap: () async {
                        DocumentSnapshot _getOtherUser = await _firestoreDB
                            .collection("users")
                            .doc(snapshotChat.messageReceiver)
                            .get();
                        Map<String, dynamic> _otherUserInfo =
                            _getOtherUser.data();
                        UserModel _otherUser =
                            UserModel.fromMap(_otherUserInfo);

                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                              create: (context) => ChatViewModel(
                                  currentUser: _viewModel.user,
                                  otherUser: _otherUser),
                              child: MessagingPage(),
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(snapshotChat.spokenUserName),
                          subtitle: Text(snapshotChat.lastMessage),
                          trailing: Text(snapshotChat.timeDifference),
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: NetworkImage(
                              snapshotChat.spokenUserProfileURL,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: allConversations.length,
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: _refreshChatList,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          color: Theme.of(context).primaryColor,
                          size: 120,
                        ),
                        Text(
                          "Henüz mesajlaşmanız yok",
                          style: TextStyle(
                            fontSize: 36,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future<Null> _refreshChatList() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1));
    return null;
  }
}
