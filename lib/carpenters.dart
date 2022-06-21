// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/streams.dart';
import 'package:workersform/bottomnav.dart';
import 'package:workersform/workerdetails.dart';
import 'package:workersform/workerscategories.dart';

// var names = ["Hassan", "Hyder", "Zaheer", "Afifa", "Rao"];
// var revws = [5, 4, 3, 2, 1];
// var age = [21, 25, 30, 35, 40];
// var experience = [10, 12, 5, 3, 6];
// var pics = ["painter1.jpg", "carpenter.jpg", "Null", "plumberr1.jpg", "Null"];

class Carpenters extends StatefulWidget {
  const Carpenters({Key? key}) : super(key: key);

  @override
  _CarpentersState createState() => _CarpentersState();
}

class _CarpentersState extends State<Carpenters> {
  var size, height, width;
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('employeesDetails')
      .where('category', isEqualTo: 'Carpenter')
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
        title: Text("Carpenters"),
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
                                    cat: 'Carpenter',
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

// Widget card(
//     context, int i, String name, int age, int exp, int review, String picx) {
//   if (picx == "Null") {
//     picx = "electriciann1.jpg";
//   }
// return InkWell(
//   child: Container(
//     margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//     height: 120,
//     decoration: BoxDecoration(color: Colors.white, boxShadow: [
//       BoxShadow(
//           color: Colors.grey.withOpacity(0.4),
//           blurRadius: 5,
//           offset: const Offset(0, 5),
//           spreadRadius: 1)
//     ]),
//     child: Row(children: [
//       Container(
//         height: 130,
//         width: 130,
//         color: Colors.amber,
//         child: Image.asset(
//           "assets/" + picx,
//           fit: BoxFit.cover,
//         ),
//       ),
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 120,
//             margin: const EdgeInsets.only(left: 20, top: 15),
//             child: Text(
//               name,
//               style: const TextStyle(fontWeight: FontWeight.w700),
//             ),
//           ),
//           Container(
//               margin: const EdgeInsets.only(left: 20, top: 12),
//               child: Text("Age: " + age.toString(),
//                   style: const TextStyle(fontSize: 10))),
//           Container(
//               margin: const EdgeInsets.only(
//                 left: 20,
//                 top: 5,
//               ),
//               child: Text("Experience: " + exp.toString(),
//                   style: const TextStyle(fontSize: 10))),
//           Row(
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(left: 18, top: 10),
//                 child: reviews(review),
//               ),
//               // Container(
//               //   margin: EdgeInsets.only(left: 100, top: 10),
//               //   child: Icon(
//               //     Icons.arrow_forward_ios,
//               //     color: Colors.teal[500],
//               //   ),
//               // ),
//             ],
//           )
//         ],
//       )
//     ]),
//   ),
//   onTap: () {
//     Navigator.push(
//         context, MaterialPageRoute(builder: (context) => WorkerDetails()));
//   },
// );
// }

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
