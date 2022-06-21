// ignore_for_file: file_names
// ignore_for_file: camel_case_types, must_be_immutable

import 'dart:io';

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
import 'package:workersform/workerscategories.dart';

class CompletedOrdersHistory extends StatefulWidget {
  final String documentId;
  final workerId;
  CompletedOrdersHistory(
      {Key? key, required this.documentId, required this.workerId})
      : super(key: key);

  @override
  State<CompletedOrdersHistory> createState() => _CompletedOrdersHistoryState();
}

var revw = 0;

class _CompletedOrdersHistoryState extends State<CompletedOrdersHistory> {
  final TextEditingController reviewEditingController =
      new TextEditingController();

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

  var userDocs;
  double? preRating;
  double? ratingNum;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readUser().then((value) => {
          setState(() {
            userDocs = value;
          })
        });
    print(widget.workerId);
  }

  @override
  Widget build(BuildContext context) {
    // description Field
    final reviewField = TextFormField(
        autofocus: false,
        controller: reviewEditingController,
        keyboardType: TextInputType.name,
        onSaved: (value) {
          reviewEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
          prefixIcon: Icon(Icons.description),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "How was the work?",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                color: Colors.white,
                margin: const EdgeInsets.only(top: 5),
                child: FutureBuilder<DocumentSnapshot>(
                  future: workers.doc(widget.documentId).get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Something Went wrong");
                    }
                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return ListView(
                        shrinkWrap: true,
                        children: const [
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
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(20),
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
                                const SizedBox(height: 5),
                                Center(
                                  child: Text(
                                    "${data['worker name']}",
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ),
                                // SizedBox(height: 5),
                                const Divider(color: Colors.grey),
                                Center(
                                  child: Text(
                                    "Work status: ${data['status']}",
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            padding: const EdgeInsets.all(20),
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
                                  leading: const Icon(
                                    Icons.description,
                                    color: Colors.white,
                                  ),
                                  title: Text("Work description",
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  subtitle: Text("${data['work description']}",
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ),
                                const Divider(color: Colors.tealAccent),
                                ListTile(
                                  leading: const Icon(Icons.euro_outlined,
                                      color: Colors.white),
                                  title: Text(
                                    "Work Demand",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text("Rs: ${data['work demand']}",
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: MediaQuery.of(context).size.height - 500,
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            child: stars(fill),
                            onTap: () {
                              setState(() {
                                fill = true;
                                fill1 = false;
                                fill2 = false;
                                fill3 = false;
                                fill4 = false;
                                rating = 1;
                              });
                            },
                          ),
                          InkWell(
                            child: stars(fill1),
                            onTap: () {
                              setState(() {
                                fill = true;
                                fill1 = true;
                                fill2 = false;
                                fill3 = false;
                                fill4 = false;
                                rating = 2;
                              });
                            },
                          ),
                          InkWell(
                            child: stars(fill2),
                            onTap: () {
                              setState(() {
                                fill = true;
                                fill1 = true;
                                fill2 = true;
                                fill3 = false;
                                fill4 = false;
                                rating = 3;
                              });
                            },
                          ),
                          InkWell(
                            child: stars(fill3),
                            onTap: () {
                              setState(() {
                                fill = true;
                                fill1 = true;
                                fill2 = true;
                                fill3 = true;
                                fill4 = false;
                                rating = 4;
                              });
                            },
                          ),
                          InkWell(
                            child: stars(fill4),
                            onTap: () {
                              setState(() {
                                fill = true;
                                fill1 = true;
                                fill2 = true;
                                fill3 = true;
                                fill4 = true;
                                rating = 5;
                              });
                            },
                          ),
                          Text("${rating.toString()} / 5")
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: reviewField,
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset: const Offset(2, 2),
                              )
                            ]),
                        child: MaterialButton(
                          onPressed: () {
                            if (rating == 0 &&
                                reviewEditingController.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg:
                                      'Please give reviews and ratings related to work done');
                            } else if (rating == 0) {
                              Fluttertoast.showToast(
                                  msg: 'Please give ratings');
                            } else if (reviewEditingController.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'Please give reviews');
                            } else {
                              Fluttertoast.showToast(msg: 'Rated succesfully');
                              update();
                              rated();
                              review(reviewEditingController.text);
                              Navigator.pop(context);
                            }
                          },
                          minWidth: double.infinity,
                          color: Colors.teal[500],
                          height: 50,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "Submit Ratings",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
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

  // Future update() async {
  //   preRating = double.parse(userDocs['rating']);
  //   ratingNum = double.parse(userDocs['noOfRating']);
  //   double avgRating;
  //   if (preRating! >= 1 && ratingNum! >= 1) {
  //     avgRating = (rating + preRating!) / 2;
  //   } else {
  //     avgRating = rating.toDouble();
  //   }
  //   ratingNum = ratingNum! + 1;
  //   FirebaseFirestore.instance
  //       .collection('employeesDetails')
  //       .doc(widget.workerId)
  //       .update({"noOfRating": (ratingNum).toString()}).then(
  //           (value) => print('Success'));
  //   FirebaseFirestore.instance
  //       .collection('employeesDetails')
  //       .doc(widget.workerId)
  //       .update({"rating": avgRating.toString()}).then(
  //           (value) => print('Success'));
  // }
  Future<void> update() async {
    try {
      preRating = double.parse(userDocs['rating']);
      ratingNum = double.parse(userDocs['noOfRating']);
      double avgRating;
      if (preRating! >= 1 && ratingNum! >= 1) {
        avgRating = (rating + preRating!) / 2;
      } else {
        avgRating = rating.toDouble();
      }
      ratingNum = ratingNum! + 1;
      FirebaseFirestore.instance
          .collection('employeesDetails')
          .doc(widget.workerId)
          .update({
        'noOfRating': (ratingNum).toString(),
        'rating': avgRating.toString()
      }).then((value) => print('Success'));
    } catch (e) {
      print(e);
    }
  }

  Future review(revs) async {
    FirebaseFirestore.instance
        .collection('employeesDetails')
        .doc(widget.workerId)
        .collection('reviews')
        .doc()
        .set({'reviews': revs});
  }

  Future rated() async {
    FirebaseFirestore.instance
        .collection('Orders')
        .doc(widget.documentId)
        .update({"status": "Rated"});
  }

  bool fill = false;
  bool fill1 = false;
  bool fill2 = false;
  bool fill3 = false;
  bool fill4 = false;

  int rating = 0;

  // Widget reviw(int fil) {
  //   if (fil == 5) {
  //     return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
  //       stars(true),
  //       stars(true),
  //       stars(true),
  //       stars(true),
  //       stars(true),
  //       const SizedBox(width: 5),
  //       Text(revw.toString(),
  //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
  //       const Text(" / 5.0",
  //           style: TextStyle(fontSize: 20, color: Colors.grey)),
  //     ]);
  //   } else if (fil == 4) {
  //     return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
  //       stars(true),
  //       stars(true),
  //       stars(true),
  //       stars(true),
  //       stars(false),
  //       const SizedBox(width: 5),
  //       Text(revw.toString(),
  //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
  //       const Text(" / 5.0",
  //           style: TextStyle(fontSize: 20, color: Colors.grey)),
  //     ]);
  //   } else if (fil == 3) {
  //     return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
  //       stars(true),
  //       stars(true),
  //       stars(true),
  //       stars(false),
  //       stars(false),
  //       const SizedBox(width: 5),
  //       Text(revw.toString(),
  //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
  //       const Text(" / 5.0",
  //           style: TextStyle(fontSize: 20, color: Colors.grey)),
  //     ]);
  //   } else if (fil == 2) {
  //     return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
  //       stars(true),
  //       stars(true),
  //       stars(false),
  //       stars(false),
  //       stars(false),
  //       const SizedBox(width: 5),
  //       Text(revw.toString(),
  //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
  //       const Text(" / 5.0",
  //           style: TextStyle(fontSize: 20, color: Colors.grey)),
  //     ]);
  //   } else if (fil == 1) {
  //     return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
  //       stars(true),
  //       stars(false),
  //       stars(false),
  //       stars(false),
  //       stars(false),
  //       const SizedBox(width: 5),
  //       Text(revw.toString(),
  //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
  //       const Text(" / 5.0",
  //           style: TextStyle(fontSize: 20, color: Colors.grey)),
  //     ]);
  //   } else {
  //     return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
  //       stars(false),
  //       stars(false),
  //       stars(false),
  //       stars(false),
  //       stars(false),
  //       const SizedBox(width: 5),
  //       Text(revw.toString(),
  //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
  //       const Text(" / 5.0",
  //           style: TextStyle(fontSize: 20, color: Colors.grey)),
  //     ]);
  //   }
  // }

  Future readUser() async {
    print(widget.workerId);
    var querySnapshot;
    try {
      querySnapshot = await FirebaseFirestore.instance
          .collection('employeesDetails')
          .doc(widget.workerId)
          .get();
      if (querySnapshot.isNotEmpty) {
        return querySnapshot;
      }
    } catch (e) {
      print(e);
    }
    return querySnapshot;
  }

  Widget stars(bool fill) {
    if (fill == true) {
      return const Icon(
        Icons.star,
        color: Colors.teal,
        size: 30,
      );
    } else {
      return const Icon(
        Icons.star_border,
        color: Colors.teal,
        size: 30,
      );
    }
  }

  Future cancelledByUser() async {
    FirebaseFirestore.instance
        .collection('Orders')
        .doc(widget.documentId)
        .update({"status": "Cancelled by user"}).then(
            (value) => print('Success'));
  }
}
