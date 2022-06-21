// ignore_for_file: file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workersform/bottomnav.dart';
import 'package:workersform/dashboard.dart';
import 'package:workersform/login.dart';
import 'package:workersform/userModel.dart';
import 'package:firebase_storage/firebase_storage.dart' as Firebase_Storage;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // for password visible or not
  late bool _passwordVisible;
  @override
  void initState() {
    _passwordVisible = false;
  }
  // for password visible or not

  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;

  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  final fullNameEditingController = new TextEditingController();
  final phoneNumberEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();

  File? dp = null;
  bool userLogin = false;

  signUp(emailtxt, passtxt, context) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: emailtxt, password: passtxt)
          .then((value) => postDetailsToFirestore(emailtxt, passtxt))
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
      print("done");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      Fluttertoast.showToast(msg: errorMessage!);
      print(e.code);
    }
    setState(() {
      userLogin == true;
    });
  }

  postDetailsToFirestore(emailtxt, passtxt) async {
    await _auth.signInWithEmailAndPassword(email: emailtxt, password: passtxt);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", emailEditingController.text);
    prefs.setString("pass", passwordEditingController.text);
    // calling our firestore
    // calling our user model
    // sending these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.fullName = fullNameEditingController.text;
    userModel.phoneNumber = phoneNumberEditingController.text;
    userModel.password = passwordEditingController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully");

    Navigator.pushAndRemoveUntil(
        (this.context),
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
  }

  Future uploadFile(email, pass, File dp, context) async {
    // logout();
    await signUp(email, pass, context);
    userLogin == false
        ? Firebase_Storage.FirebaseStorage.instance
            .ref()
            .child('userAAMProfiles/$email/')
            .child("DP.jpg")
            .putFile(dp)
            .then((p0) {
            Fluttertoast.showToast(msg: "DP Upload Sucessfull");
          })
        : print("Working");
  }

  _getFromGallery({dpimg = false}) async {
    // ignore: deprecated_member_use
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        if (dpimg == true) {
          dp = File(pickedFile.path);
        }
      });
    }
  }

  // password widget
  var clrpass = Colors.red;
  Widget passwordField() {
    return TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        keyboardType: TextInputType.name,
        obscureText: !_passwordVisible,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          fullNameEditingController.text = value!;
        },
        onChanged: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');

          if (value == "") {
            clrpass = Colors.red;
          } else if (value.length < 6) {
            print("Change kro");
            setState(() {
              clrpass = Colors.red;
            });
          } else {
            setState(() {
              print("Sahi hai pass");
              clrpass = Colors.teal;
            });
          }
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: clrpass),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: clrpass)),
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(this.context).primaryColor,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
        ));
  }

  //
  @override
  Widget build(BuildContext context) {
    //first name field
    final firstNameField = TextFormField(
        autofocus: false,
        controller: fullNameEditingController,
        keyboardType: TextInputType.name,
        onSaved: (value) {
          fullNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal)),
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Full Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //phone number field
    final phoneNumberField = TextFormField(
        autofocus: false,
        controller: phoneNumberEditingController,
        keyboardType: TextInputType.number,
        // validator: phoneNumberValidator,
        onSaved: (value) {
          phoneNumberEditingController.text = value!;
        },
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11)
        ],
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal)),
          prefixIcon: const Icon(Icons.phone),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "03331234567",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]"
          if (!RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          fullNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal)),
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //signup button
    final signUpButton = Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 3,
          blurRadius: 10,
          offset: const Offset(2, 2),
        )
      ]),
      child: MaterialButton(
        onPressed: () {
          if (fullNameEditingController.text.isEmpty &&
              phoneNumberEditingController.text.isEmpty &&
              dp == null) {
            Fluttertoast.showToast(msg: "Information is not completed");
          } else if (fullNameEditingController.text.isEmpty) {
            Fluttertoast.showToast(msg: "Full name is empty");
          } else if (phoneNumberEditingController.text.isEmpty) {
            Fluttertoast.showToast(msg: "Phone number is empty");
          } else if (phoneNumberEditingController.text.length < 11) {
            Fluttertoast.showToast(msg: "Phone number is invalid");
          } else if (dp == null) {
            Fluttertoast.showToast(msg: "Profile image is empty");
          } else {
            uploadFile(emailEditingController.text,
                passwordEditingController.text, dp!, context);
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
          "SignUp",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Icon(
          Icons.arrow_back,
          color: Colors.teal[500],
        ),
        title: Center(child: Text('AAM AADMI')),
        actions: [
          Icon(Icons.arrow_back_ios_new_sharp, color: Colors.teal[500]),
          Icon(Icons.arrow_back_ios_new_sharp, color: Colors.teal[500]),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 120,
          width: double.infinity,
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  // padding: EdgeInsets.only(top: 10),
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/aamaadmi.png"),
                        fit: BoxFit.fitHeight),
                  ),
                ),
                const Text(
                  "Sign up",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                firstNameField,
                phoneNumberField,
                emailField,
                passwordField(),
                Row(
                  children: [
                    const Text(
                      "Profile Picture: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    dp == null
                        ? IconButton(
                            onPressed: () {
                              _getFromGallery(dpimg: true);
                            },
                            icon: const Icon(Icons.add_a_photo_outlined))
                        : Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    _getFromGallery(dpimg: true);
                                  },
                                  icon: const Icon(Icons.restore)),
                              Container(
                                color: Colors.teal,
                                width: 50,
                                height: 50,
                                child: Image.file(
                                  dp!,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
                signUpButton,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Already have an account?"),
                    InkWell(
                      child: const Text(
                        " Login",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
