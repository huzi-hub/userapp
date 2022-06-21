// ignore_for_file: camel_case_types, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workersform/bookAWorker.dart';
import 'package:workersform/bookingModel.dart';
import 'package:workersform/bottomnav.dart';
import 'package:workersform/workerReviews.dart';
import 'package:workersform/workerscategories.dart';

class WorkerrDetails extends StatefulWidget {
  final String documentId;
  final String cat;
  WorkerrDetails({Key? key, required this.documentId, required this.cat})
      : super(key: key);

  @override
  State<WorkerrDetails> createState() => _WorkerrDetailsState();
}

class _WorkerrDetailsState extends State<WorkerrDetails> {
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

  // void intiState() {
  //   super.initState();

  //   workers.doc(widget.documentId).get().then((value) {
  //     get_image(value['email']).then((value) {
  //       setState(() {
  //         urlfinal = value;
  //       });
  //     });
  //   });
  // }

  CollectionReference workers =
      FirebaseFirestore.instance.collection('employeesDetails');

  @override
  Widget build(BuildContext context) {
    // CollectionReference for worker drwaer single data
    // CollectionReference workers =
    //     FirebaseFirestore.instance.collection('employeesDetails');

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
                      // get_image(data['email']);
                      // setState(() {
                      //   get_image(data['email']);
                      // });

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
                                      get_image(data['email']);
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
                                  child: Column(
                                    children: [
                                      Text(
                                        "${data['fullName']}",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Working Experience: ",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            "${data['experience']}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[700]),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // SizedBox(height: 5),
                                Divider(color: Colors.grey),
                                Center(
                                  child: Text(
                                    "${data['description']}",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
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
                                      offset: const Offset(0, 2),
                                      spreadRadius: 1)
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ListTile(
                                  leading: Icon(
                                    Icons.reviews_outlined,
                                    color: Colors.white,
                                  ),
                                  title: const Text("Ratings",
                                      style: TextStyle(color: Colors.white)),
                                  subtitle: Text(
                                      "${double.parse(data['rating']).toStringAsFixed(2)} / ${double.parse(data['noOfRating'])}",
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ),
                                Divider(color: Colors.tealAccent),
                                ListTile(
                                  leading: Icon(
                                    Icons.work_outline,
                                    color: Colors.white,
                                  ),
                                  title: Text("${data['category']}",
                                      style: TextStyle(color: Colors.white)),
                                ),
                                Divider(color: Colors.tealAccent),
                                ListTile(
                                    leading: Icon(Icons.email_outlined,
                                        color: Colors.white),
                                    title: Text(
                                      "${data['email']}",
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Book_A_Worker(
                                        documentId: widget.documentId,
                                        cat: widget.cat,
                                      )));
                        },
                        minWidth: double.infinity,
                        color: Colors.teal[500],
                        height: 50,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Book Now",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 3),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 50,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WorkerReviews(
                                    documentId: widget.documentId)));
                      },
                      // defining the shape
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.teal),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "See Reviews",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
