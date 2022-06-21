// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:workersform/bottomnav.dart';
import 'package:workersform/workerdetails.dart';
import 'package:workersform/workerscategories.dart';

// var names = ["Hassan", "Hyder", "Zaheer", "Afifa", "Rao"];
// var revws = [5, 4, 3, 2, 1];
// var age = [21, 25, 30, 35, 40];
// var experience = [10, 12, 5, 3, 6];
// var pics = ["painter1.jpg", "carpenter.jpg", "Null", "plumberr1.jpg", "Null"];
// final names = name;
// final exp = experience;

class Ac_Repair extends StatefulWidget {
  const Ac_Repair({Key? key}) : super(key: key);

  @override
  _Ac_RepairState createState() => _Ac_RepairState();
}

class _Ac_RepairState extends State<Ac_Repair> {
  var size, height, width;
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('employeesDetails')
      .where('category', isEqualTo: 'Ac Repair')
      .where('verification', isEqualTo: 'Verified')
      .orderBy('rating', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal[500],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
        ),
        title: Text("Ac Repair"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.size == 0) {
            return Center(child: Text('Verified workers list is empty'));
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  // height: 120,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 5,
                        offset: const Offset(0, 5),
                        spreadRadius: 1)
                  ]),
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Image(
                          image: AssetImage('assets/electriciann1.jpg'),
                        ),
                        title: Text(data['fullName']),
                        subtitle: Text(data['description']),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkerrDetails(
                                    documentId: document.id,
                                    cat: 'Ac Repair',
                                  )));
                    },
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      bottomNavigationBar: bottomnavbar(context),
    );
  }
}


// Widget reviews(int fil) {
//   if (fil == 5) {
//     return Row(
//       children: [
//         stars(true),
//         stars(true),
//         stars(true),
//         stars(true),
//         stars(true)
//       ],
//     );
//   } else if (fil == 4) {
//     return Row(
//       children: [
//         stars(true),
//         stars(true),
//         stars(true),
//         stars(true),
//         stars(false)
//       ],
//     );
//   } else if (fil == 3) {
//     return Row(
//       children: [
//         stars(true),
//         stars(true),
//         stars(true),
//         stars(false),
//         stars(false)
//       ],
//     );
//   } else if (fil == 2) {
//     return Row(
//       children: [
//         stars(true),
//         stars(true),
//         stars(false),
//         stars(false),
//         stars(false)
//       ],
//     );
//   } else if (fil == 1) {
//     return Row(
//       children: [
//         stars(true),
//         stars(false),
//         stars(false),
//         stars(false),
//         stars(false)
//       ],
//     );
//   } else {
//     return Row(
//       children: [
//         stars(false),
//         stars(false),
//         stars(false),
//         stars(false),
//         stars(false)
//       ],
//     );
//   }
// }

// Widget stars(bool fill) {
//   if (fill == true) {
//     return const Icon(
//       Icons.star,
//       color: Colors.teal,
//       size: 15,
//     );
//   } else {
//     return const Icon(
//       Icons.star_border,
//       color: Colors.teal,
//       size: 15,
//     );
//   }
// }
