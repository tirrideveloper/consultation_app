import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultation_app/common_widget/side_menu.dart';
import 'package:consultation_app/models/app_localizations.dart';
import 'package:consultation_app/models/user_view_model.dart';
import 'package:consultation_app/screens/main_menu/profile/other_users_profile.dart';
import 'package:consultation_app/screens/main_menu/profile/profile_page.dart';
import 'package:consultation_app/screens/main_menu/search/get_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  QuerySnapshot snapshotData;
  bool isExecuted = false;

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
    UserViewModel _viewModel =
        Provider.of<UserViewModel>(context, listen: false);
    Widget searchedData() {
      return ListView.builder(
        itemCount: snapshotData.docs.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () {
              if ((snapshotData.docs[index].data() as Map)["userName"] ==
                  _viewModel.user.userName) {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
                );
              } else {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => OtherUserProfile(
                      otherUser: (snapshotData.docs[index].data() as Map),
                    ),
                  ),
                );
              }
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                (snapshotData.docs[index].data() as Map)["profileURL"],
              ),
              backgroundColor: Colors.white,
            ),
            title: Text(
              (snapshotData.docs[index].data() as Map)["nameSurname"],
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            subtitle: Text(
              (snapshotData.docs[index].data() as Map)["aboutUser"],
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                    (snapshotData.docs[index].data() as Map)["rank"].toString())
              ],
            ),
          );
        },
      );
    }

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
                hintText: AppLocalizations.of(context).translate("search_text"),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isExecuted = false;
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
          GetBuilder<DataController>(
              init: DataController(),
              builder: (val) {
                return IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      val.queryData(_searchController.text).then((value) {
                        snapshotData = value;
                        setState(() {
                          isExecuted = true;
                        });
                      });
                      FocusScope.of(context).unfocus();
                    });
              }),
        ],
      ),
      body: isExecuted
          ? searchedData()
          : Container(
              child: Center(
                child: Text("Searching screen"),
              ),
            ),
    );
  }
}
