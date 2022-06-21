// ignore_for_file: file_names
// ignore_for_file: camel_case_types, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workersform/accountDetails.dart';
import 'package:workersform/bookAWorker.dart';
import 'package:workersform/bookingModel.dart';
import 'package:workersform/bottomnav.dart';
import 'package:workersform/dashboard.dart';
import 'package:workersform/workerscategories.dart';

class OrderHistoryDetails extends StatefulWidget {
  final String documentId;
  OrderHistoryDetails({Key? key, required this.documentId}) : super(key: key);

  @override
  State<OrderHistoryDetails> createState() => _OrderHistoryDetailsState();
}

class _OrderHistoryDetailsState extends State<OrderHistoryDetails> {
  var size, height, width;

  bool isLoading = false;

  String? urlfinal = null;

  String? name = null;
  // String? email = null;

  get_image(email) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('userProfiles/')
        .child(email)
        .child('DP.jpg');
    var url = await ref.getDownloadURL();
    print(url);
    setState(() {
      urlfinal = url;
    });
    return "Done";
  }

  @override
  Widget build(BuildContext context) {
    // CollectionReference for worker drwaer single data
    CollectionReference workers =
        FirebaseFirestore.instance.collection('Orders');
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: appbarpop(context, "Profile"),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 5),
                  child: FutureBuilder<DocumentSnapshot>(
                    future: workers.doc(widget.documentId).get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text("Something Went wrong");
                      }
                      if (snapshot.hasData && !snapshot.data!.exists) {
                        return ListView(
                          shrinkWrap: true,
                          children: [
                            Text("Data does not exists"),
                          ],
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return ListView(
                          shrinkWrap: true,
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(color: Colors.tealAccent),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                        spreadRadius: 4)
                                  ]),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        get_image(data['workerEmail']);
                                      });
                                    },
                                    child: Center(
                                      child: Column(
                                        children: [
                                          urlfinal != null
                                              ? CircleAvatar(
                                                  radius: 50.0,
                                                  backgroundImage:
                                                      NetworkImage(urlfinal!),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                )
                                              : Text('View Profile..'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Center(
                                    child: Text(
                                      "${data['worker name']}",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                  ),
                                  // SizedBox(height: 5),
                                  Divider(color: Colors.grey),
                                  Center(
                                    child: Text(
                                      "Work status: ${data['status']}",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Colors.teal[500],
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        blurRadius: 5,
                                        offset: const Offset(0, 0),
                                        spreadRadius: 4)
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      Icons.description,
                                      color: Colors.white,
                                    ),
                                    title: Text("Work Description",
                                        style: TextStyle(color: Colors.white)),
                                    subtitle: Text(
                                        "${data['work description']}",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  Divider(color: Colors.tealAccent),
                                  ListTile(
                                      leading: Icon(Icons.euro_outlined,
                                          color: Colors.white),
                                      title: Text(
                                        "Work Demand",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        "Rs: ${data['work demand']}",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: 0,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black,
            iconSize: 25,
            onTap: (int index) => btn(index, context),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.category_outlined,
                  ),
                  label: 'Services'),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outline,
                ),
                label: 'Settings',
              ),
            ]));
  }
}

final _auth = FirebaseAuth.instance;
User? user = _auth.currentUser;
btn(i, context) {
  if (i == 0) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Dashboard()));
  } else if (i == 1) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => workerscategories()));
  } else {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AccountDetails(documentId: user!.uid)));
  }
}
