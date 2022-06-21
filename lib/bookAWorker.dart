// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workersform/bookingModel.dart';
import 'package:workersform/orders.dart';
import 'package:workersform/workerdetails.dart';
import 'package:workersform/workerscategories.dart';

class Book_A_Worker extends StatefulWidget {
  final String documentId;
  final String cat;
  const Book_A_Worker({Key? key, required this.documentId, required this.cat})
      : super(key: key);

  @override
  State<Book_A_Worker> createState() => _Book_A_WorkerState();
}

class _Book_A_WorkerState extends State<Book_A_Worker> {
  final _auth = FirebaseAuth.instance;
  //  CollectionReference users = FirebaseFirestore.instance.collection('users');
  TextEditingController workDescEditingController = TextEditingController();
  TextEditingController demandEditingController = TextEditingController();

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sending these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser!;
    BookingModel bookingModel = BookingModel();

    // writing all the values
    bookingModel.uid = FirebaseAuth.instance.currentUser!.uid;
    bookingModel.workDesc = workDescEditingController.text;
    bookingModel.workDemand = demandEditingController.text;
    bookingModel.userName = userDocs['fullName'];
    bookingModel.userContact = userDocs['phoneNumber'];
    bookingModel.status = 'Pending';
    bookingModel.workerUid = widget.documentId;
    bookingModel.workerName = workerDocs['fullName'];
    bookingModel.workerContact = workerDocs['phoneNumber'];
    bookingModel.date =
        '${DateTime.now().day}:${DateTime.now().month}:${DateTime.now().year}/${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}';
    bookingModel.userEmail = userDocs['email'];
    bookingModel.workerEmail = workerDocs['email'];

    await firebaseFirestore
        .collection('Orders')
        .doc()
        .set(bookingModel.toMap());
    Fluttertoast.showToast(msg: "Order placed successfully");

    Navigator.pushAndRemoveUntil(
        (this.context),
        MaterialPageRoute(builder: (context) => workerscategories()),
        (route) => false);
  }

  var workerDocs;
  var userDocs;
  @override
  void initState() {
    super.initState();
    readUser().then((value) => {
          setState(() {
            userDocs = value;
          })
        });
    readWorker().then((value) => {
          setState(() {
            workerDocs = value;
          })
        });
  }

  Widget build(BuildContext context) {
    final workdesc = TextFormField(
        autofocus: false,
        controller: workDescEditingController,
        keyboardType: TextInputType.name,
        onSaved: (value) {
          workDescEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
          prefixIcon: Icon(Icons.description),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Work Description Here",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final demand = TextFormField(
        autofocus: false,
        controller: demandEditingController,
        keyboardType: TextInputType.number,
        onSaved: (value) {
          demandEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
          prefixIcon: Icon(Icons.add_to_drive),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Work Demand In Rupees",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
          iconSize: 20,
        ),
        title: Text("Booking Details"),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.height - 120,
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            workdesc,
            const SizedBox(height: 20),
            demand,
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.5),
                  //     spreadRadius: 3,
                  //     blurRadius: 10,
                  //     offset: Offset(2, 2),
                  //   )
                  // ]
                ),
                child: MaterialButton(
                  onPressed: () {
                    if (workDescEditingController.text.isEmpty &&
                        demandEditingController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Please Enter Details of your work");
                    } else if (workDescEditingController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Please Enter Your Work Description");
                    } else if (demandEditingController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Please Enter Your Work Demand");
                    } else {
                      postDetailsToFirestore();
                    }
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
                      Text(
                        "Place Order",
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
            ),
          ],
        ),
      ),
    );
  }

  Future readUser() async {
    var querySnapshot;
    try {
      querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (querySnapshot.isNotEmpty) {
        return querySnapshot;
      }
    } catch (e) {
      print(e);
    }
    return querySnapshot;
  }

  Future readWorker() async {
    var querySnapshot;
    try {
      querySnapshot = await FirebaseFirestore.instance
          .collection('employeesDetails')
          .doc(widget.documentId)
          .get();
      if (querySnapshot.isNotEmpty) {
        return querySnapshot;
      }
    } catch (e) {
      print(e);
    }
    return querySnapshot;
  }
}
