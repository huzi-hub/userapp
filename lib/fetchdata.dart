// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class AddData extends StatelessWidget {
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       backgroundColor: Colors.green,
//       title: Text("geeksforgeeks"),
//     ),
//     body: Center(
// child: StreamBuilder(
//   stream: FirebaseFirestore.instance.collection('users').snapshots(),
//   builder:
//       (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//     if (!snapshot.hasData) {
//       return Center(
//         child: CircularProgressIndicator(),
//       );
//     }

//     return ListView(
//       children: snapshot.data!.docs.map((document) {
//         return Container(
//           child: Center(
//             child: Column(
//               children: [
//                 Text(document['email']),
//                 Text(
//                   document['fullName'],
//                   style: TextStyle(),
//                 )
//               ],
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   },
// ),
// ),
//       drawer: Drawer(
//         child: StreamBuilder(
//           stream: FirebaseFirestore.instance.collection('users').snapshots(),
//           builder:
//               (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (!snapshot.hasData) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }

//             return ListView(
//               children: snapshot.data!.docs.map((document) {
//                 return Container(
//                   child: Column(
//                     children: [
//                       UserAccountsDrawerHeader(
//                         accountName: Text(document['email']),
//                         accountEmail: Text(
//                           document['fullName'],
//                         ),
//                         currentAccountPicture: CircleAvatar(
//                             child:
//                                 Image(image: AssetImage("assets/stove.png"))),
//                         decoration: BoxDecoration(
//                           color: Colors.teal[500],
//                           borderRadius: BorderRadius.only(
//                             bottomLeft: Radius.circular(10),
//                             bottomRight: Radius.circular(10),
//                           ),
//                         ),
//                       ),
//                       ListTile(
//                         leading: Icon(
//                           Icons.person,
//                           color: Colors.teal[500],
//                         ),
//                         title: Text("Account"),
//                         trailing: Icon(
//                           Icons.arrow_forward_ios,
//                           color: Colors.teal[500],
//                         ),
//                         onTap: () {
//                           // Navigator.push(context,
//                           //     MaterialPageRoute(builder: (context) => AccountSettings()));
//                         },
//                       ),
//                       ListTile(
//                         leading: Icon(Icons.location_on_rounded,
//                             color: Colors.teal[500]),
//                         title: Text("Address"),
//                         trailing: Icon(
//                           Icons.arrow_forward_ios,
//                           color: Colors.teal[500],
//                         ),
//                         onTap: () {
//                           // Navigator.push(context,
//                           //     MaterialPageRoute(builder: (context) => AccountSettings()));
//                         },
//                       ),
//                       ListTile(
//                         leading: Icon(
//                           Icons.pending_actions_outlined,
//                           color: Colors.teal[500],
//                         ),
//                         title: Text("Terms & Conditions"),
//                         trailing: Icon(
//                           Icons.arrow_forward_ios,
//                           color: Colors.teal[500],
//                         ),
//                         onTap: () {
//                           // Navigator.push(
//                           //     context,
//                           //     MaterialPageRoute(
//                           //         builder: (context) => TermsAndConditions()));
//                         },
//                       ),
//                       ListTile(
//                         leading: Icon(
//                           Icons.share,
//                           color: Colors.teal[500],
//                         ),
//                         title: Text("Invite Friends"),
//                         trailing: Icon(Icons.arrow_forward_ios,
//                             color: Colors.teal[500]),
//                         onTap: () {},
//                       ),
//                       ListTile(
//                         leading:
//                             Icon(Icons.announcement, color: Colors.teal[500]),
//                         title: Text("About Us"),
//                         trailing: Icon(
//                           Icons.arrow_forward_ios,
//                           color: Colors.teal[500],
//                         ),
//                         onTap: () {
//                           // Navigator.push(
//                           //     context,
//                           //     MaterialPageRoute(
//                           //         builder: (context) => TermsAndConditions()));
//                         },
//                       ),
//                       Container(
//                         child: ListTile(
//                             leading: Icon(
//                               Icons.logout_rounded,
//                               color: Colors.red,
//                             ),
//                             title: Text("Log Out"),
//                             trailing: Icon(
//                               Icons.arrow_forward_ios,
//                               color: Colors.teal[500],
//                             ),
//                             onTap: () {
//                               // Navigator.push(context,
//                               //     MaterialPageRoute(builder: (context) => LoginScreen()));
//                             }),
//                         decoration: BoxDecoration(
//                             color: Colors.grey.withOpacity(0.5),
//                             borderRadius: BorderRadius.circular(10)),
//                       )
//                     ],
//                   ),
//                 );
//               }).toList(),
//             );
//           },
//         ),
//       ),
//       bottomNavigationBar: bottomnavbar(context),
//     );
//   }
// }

// class AddData extends StatelessWidget {
//   final String documentId;

//   AddData(this.documentId);

//   @override
//   Widget build(BuildContext context) {
//     CollectionReference users = FirebaseFirestore.instance.collection('users');

//     return FutureBuilder<DocumentSnapshot>(
//       future: users.doc(documentId).get(),
//       builder:
//           (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return Text("Something went wrong");
//         }

//         if (snapshot.hasData && !snapshot.data!.exists) {
//           return Text("Document does not exist");
//         }

//         if (snapshot.connectionState == ConnectionState.done) {
//           Map<String, dynamic> data =
//               snapshot.data!.data() as Map<String, dynamic>;
//           return Text("Full Name: ${data['email']} ${data['fullName']}");
//         }

//         return Text("loading");
//       },
//     );
//   }
// }
