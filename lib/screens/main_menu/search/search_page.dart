import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultation_app/common_widget/side_menu.dart';
import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/tools/app_localizations.dart';
import 'package:consultation_app/screens/main_menu/profile/other_users_profile.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<UserModel> allSearchedUser = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.white),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 15),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _searchController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey.shade200),
                  border: InputBorder.none,
                  hintText:
                      AppLocalizations.of(context).translate("search_text"),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                      });
                    },
                    icon: Icon(Icons.clear),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  allSearchedUser = [];
                });
              },
            ),
          ],
        ),
        body: searchedData());
  }

  Widget searchedData() {
    return FutureBuilder<List<UserModel>>(
      future: getData(_searchController.text),
      builder: (context, searchedList) {
        if (!searchedList.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          allSearchedUser = searchedList.data;
          if (allSearchedUser.length > 0) {
            return RefreshIndicator(
              onRefresh: _refreshSearchList,
              child: ListView.builder(
                itemCount: allSearchedUser.length,
                itemBuilder: (context, index) {
                  var snapshotUser = allSearchedUser[index];
                  return Card(
                    child: ListTile(
                      onTap: () {

                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => OtherUserProfile(
                              otherUser: snapshotUser,
                            ),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(snapshotUser.profileURL),
                        backgroundColor: Colors.white,
                      ),
                      title: Text(
                        snapshotUser.nameSurname,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      subtitle: Text(
                        snapshotUser.aboutUser,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Rank",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(snapshotUser.rank.toString())
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return _noSearchedUser(context);
          }
        }
      },
    );
  }

  Widget _noSearchedUser(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshSearchList,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_outlined,
                  color: Theme.of(context).primaryColor,
                  size: 120,
                ),
                Text(
                  AppLocalizations.of(context).translate("search_text"),
                  style: TextStyle(fontSize: 36),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<UserModel>> getData(String queryString) async {
    final FirebaseFirestore _firestoreDB = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await _firestoreDB
        .collection("users")
        .where("nameSurname", isGreaterThanOrEqualTo: queryString)
        .get();

    List<UserModel> searchedUsers = [];

    for (DocumentSnapshot searchedUser in snapshot.docs) {
      UserModel _user = UserModel.fromMap(searchedUser.data());
      searchedUsers.add(_user);
    }

    return searchedUsers;
  }

  Future<void> _refreshSearchList() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1));
    return null;
  }
}
