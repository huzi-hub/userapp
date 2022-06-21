// ignore_for_file: avoid_web_libraries_in_flutter

// import 'dart:html';
// import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workersform/accountDetails.dart';
import 'package:workersform/bottomnav.dart';
import 'package:workersform/builders.dart';
import 'package:workersform/carpenters.dart';
import 'package:workersform/completedOrders.dart';
import 'package:workersform/geyser.dart';
import 'package:workersform/login.dart';
import 'package:workersform/orderHistory.dart';
import 'package:workersform/orders.dart';
import 'package:workersform/painters.dart';
import 'package:workersform/stoveRepair.dart';
import 'package:workersform/termsandconditions.dart';
import 'package:workersform/washingMachine.dart';
import 'package:workersform/workerscategories.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as Firebase_Storage;

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String documentId = "";
  final auth = FirebaseAuth.instance.currentUser!;
  var size, height, width;

  String? urlfinal = null;
  String? name = null;
  String? email = null;

  get_image(email) async {
    final ref = Firebase_Storage.FirebaseStorage.instance
        .ref()
        .child('userAAMProfiles/')
        .child(email)
        .child('DP.jpg');
    var url = await ref.getDownloadURL();
    print(url);
    User auth = FirebaseAuth.instance.currentUser!;
    auth.updatePhotoURL(url);
    setState(() {
      urlfinal = url;
    });
    return "Done";
  }

  // method for logging out a current user
  Future logout() async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("email");
    prefs.remove("pass");
  }

  void initState() {
    super.initState();

    // name = auth.displayName;
    email = auth.email;
    documentId = auth.uid;
    get_image(email);
  }

  String? userName;
  String? contact;
  // @override
  // void initState() {
  //   super.initState();
  //   documentId = auth.uid;
  // }

  @override
  Widget build(BuildContext context) {
    // CollectionReference for user drwaer single data
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("AAM AADMI"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OrdersList()));
                },
                icon: const Icon(Icons.work_outline)),
            IconButton(
                onPressed: () {
                  logout();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (Route<dynamic> route) => false);
                },
                icon: const Icon(Icons.logout_outlined)),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(height: height * 0.02),
                  CarouselSlider(
                    items: [
                      //1st Image of Slider
                      Container(
                        margin: EdgeInsets.all(height * 0.02),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                          image: DecorationImage(
                            image: AssetImage("assets/slider3.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      //2nd Image of Slider
                      Container(
                        margin: EdgeInsets.all(height * 0.01),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: AssetImage("assets/slider2.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      //3rd Image of Slider
                      Container(
                        margin: EdgeInsets.all(height * 0.01),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: AssetImage("assets/slider1.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],

                    //Slider Container properties
                    options: CarouselOptions(
                      height: height * 0.25,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: Duration(milliseconds: 1000),
                      viewportFraction: 0.8,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.005,
                  ),
                  Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: width * 0.05, top: height * 0.01),
                        child: Text("Trending Services",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.005,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      workersBTN1(
                          context, "Geyser", "assets/geysero.jpg", Geyser()),
                      workersBTN1(
                          context, "Stove", "assets/stove.png", Stove_Repair()),
                      workersBTN1(context, "Builders", "assets/builder1.jpg",
                          Builders()),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      workersBTN1(context, "WashMec",
                          "assets/washingmachine.jpg", Washing_Machine()),
                      workersBTN1(context, "Carpenter", "assets/carpenter.jpg",
                          Carpenters()),
                      workersBTN1(
                          context, "Painter", "assets/painter1.jpg", Painters())
                    ],
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: Offset(2, 2),
                            )
                          ]),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => workerscategories()));
                        },
                        minWidth: double.infinity,
                        color: Colors.teal[500],
                        height: 50,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Home Services",
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
          ),
        ),
        drawer: Drawer(
          child: FutureBuilder<DocumentSnapshot>(
            future: users.doc(documentId).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something Went wrong");
              }
              if (snapshot.hasData && !snapshot.data!.exists) {
                return ListView(
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text("Data does not exists"),
                      accountEmail: Text("Data does not exists"),
                    )
                  ],
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                // setState(() {
                userName = data['fullName'];
                contact = data['phoneNumber'];
                // });
                return ListView(
                  children: [
                    InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Dashboard())).then((value) {
                        urlfinal = null;
                        setState(() {
                          get_image(email);
                        });
                      }),
                      child: urlfinal != null
                          ? UserAccountsDrawerHeader(
                              decoration:
                                  BoxDecoration(color: Colors.teal[500]),
                              currentAccountPicture: CircleAvatar(
                                backgroundImage: NetworkImage(urlfinal!),
                                backgroundColor: Colors.transparent,
                              ),
                              accountName: Text("${userName}",
                                  style: TextStyle(color: Colors.black)),
                              accountEmail: Text("${data['email']}",
                                  style: TextStyle(color: Colors.black)),
                            )
                          : UserAccountsDrawerHeader(
                              decoration:
                                  BoxDecoration(color: Colors.teal[500]),
                              currentAccountPicture: CircleAvatar(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                              accountName: Text("${data['fullName']}",
                                  style: TextStyle(color: Colors.black)),
                              accountEmail: Text("${data['email']}",
                                  style: TextStyle(color: Colors.black)),
                            ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.person,
                        color: Colors.teal[500],
                      ),
                      title: Text("Account"),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.teal[500],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AccountDetails(
                                      documentId: user!.uid,
                                    )));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.history, color: Colors.teal[500]),
                      title: Text("Order History"),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.teal[500],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderHistoryList()));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.history, color: Colors.teal[500]),
                      title: Text("Completed Orders"),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.teal[500],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CompletedOrders()));
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.pending_actions_outlined,
                        color: Colors.teal[500],
                      ),
                      title: Text("Terms & Conditions"),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.teal[500],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TermsAndConditions()));
                      },
                    ),
                    ListTile(
                      leading:
                          Icon(Icons.announcement, color: Colors.teal[500]),
                      title: Text("About Us"),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.teal[500],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TermsAndConditions()));
                      },
                    ),
                    ListTile(
                        leading: Icon(
                          Icons.logout_rounded,
                          color: Colors.teal,
                        ),
                        title: Text("Log Out"),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.teal[500],
                        ),
                        onTap: () {
                          logout();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                              (Route<dynamic> route) => false);
                        }
                        // _signOut();
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => WelcomePage()));
                        )
                  ],
                );
              }
              return Text("Loading");
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: 0,
            selectedItemColor: Colors.teal,
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

Container workersBTN1(BuildContext context, txt, img, page) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(0, 5),
            spreadRadius: 1)
      ],
    ),
    child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 2, right: 2, top: 4, bottom: 4),
          child: Column(
            children: [
              Image.asset(img, height: 75, width: 65),
              Text(
                txt,
                style: TextStyle(color: Colors.teal[300]),
              ),
            ],
          ),
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white))),
  );
}

// // method for logging out a current user
// Future<void> _signOut() async {
//   await FirebaseAuth.instance.signOut().then((value) => {Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const WelcomePage()), (route) => false)});
// }
