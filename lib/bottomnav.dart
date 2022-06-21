import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workersform/accountDetails.dart';
import 'package:workersform/dashboard.dart';
import 'package:workersform/workerscategories.dart';

// firebase
final _auth = FirebaseAuth.instance;
AppBar appbarr(title) => AppBar(
    backgroundColor: Colors.teal[500],
    title: Text(
      title,
      textAlign: TextAlign.justify,
    ));

AppBar appbarpop(BuildContext context, title) {
  return AppBar(
    // elevation: 0,
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
    title: Text(title),
  );
}

BottomNavigationBar bottomnavbar(context) {
  return BottomNavigationBar(
      backgroundColor: Colors.white,
      fixedColor: Colors.teal,
      currentIndex: 1,
      iconSize: 30,
      onTap: (int index) => btn(index, context),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined, color: Colors.black),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.category_outlined,
            color: Colors.teal,
          ),
          label: 'Services',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outline,
            color: Colors.black,
          ),
          label: 'Settings',
        ),
      ]);
}

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
