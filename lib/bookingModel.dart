// Pehla email pass wala kam hai yh
// ignore_for_file: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  String? uid;
  String? workDesc;
  String? workDemand;
  String? userName;
  String? userContact;
  String? status;
  String? workerUid;
  String? workerName;
  String? workerContact;
  String? date;
  String? userEmail;
  String? workerEmail;

  BookingModel({
    this.uid,
    this.workDesc,
    this.workDemand,
    this.userName,
    this.userContact,
    this.status,
    this.workerUid,
    this.workerName,
    this.workerContact,
    this.date,
    this.userEmail,
    this.workerEmail,
  });

  // receiving data from server
  factory BookingModel.fromMap(map) {
    return BookingModel(
      uid: map['uid'],
      workDesc: map['work description'],
      workDemand: map['work demand'],
      userName: map['userName'],
      userContact: map['userContact'],
      workerName: map['workerName'],
      workerContact: map['workerContact'],
      status: map['status'],
      workerUid: map['workerUid'],
      date: map['date'],
      userEmail: map['userEmail'],
      workerEmail: map['workerEmail'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'work description': workDesc,
      'work demand': workDemand,
      'userName': userName,
      'userContact': userContact,
      'status': status,
      'workerUid': workerUid,
      'worker name': workerName,
      'worker contact': workerContact,
      'date': date,
      'userEmail': userEmail,
      'workerEmail': workerEmail,
    };
  }
}
