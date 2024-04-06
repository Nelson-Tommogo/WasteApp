import 'dart:typed_data';

import 'package:chemba/pages/helper/waba/events/createEvents/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location_geocoder/location_geocoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chemba/model/user.dart' as model;


class AuthService {
  String reg = "working";

  Future<String?> registration({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
     String location = "not applicable",
     String bio = "not applicable",
     String shopName = "not applicable",
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final message =
          await addUser(name: name, email: email,phone : phone, role : role,location : location, bio : bio, shopName : shopName);

      var returnMessage = "";
      if (message!.contains('Added user')) {
        returnMessage = "Success";
      } else {
        returnMessage = message;
      }

      print(message);

      await FirebaseFirestore.instance
          .collection('notification')
          .add({
        'title': "Account Registration",
        'email': email,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'status': true,
        'message': "registration was successful"
      });

      return returnMessage;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }


  Future<String?> registrationClick({
    required String email,
    required String name,
    required String nameUser,
    required String phoneUser,
    required String emailUser,
    required String phone,
    required String role,
    required String location,
    required String bio,
    required String shopName,
  }) async {
    try {


      final message =
      await addUserClick(name: name, email: email,phone : phone, role : role,location : location, bio : bio, shopName : shopName,nameUser: nameUser,emailUser: emailUser,phoneUser: phoneUser);

      var returnMessage = "";
      if (message!.contains('Added user')) {
        returnMessage = "Success";
      } else {
        returnMessage = message;
      }

      await FirebaseFirestore.instance
          .collection('notification')
          .add({
        'title': "Account Clicked",
        'email': emailUser,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'status': true,
        'message': "You checked $name with $shopName"
      });

      return returnMessage;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final message = await getUserDetails();

      var returnMessage = "";
      if (message!.contains('welcome')) {
        returnMessage = "welcome";
      } else {
        returnMessage = message;
      }

      await FirebaseFirestore.instance
          .collection('notification')
          .add({
        'title': "Account Authentication",
        'email': email,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'status': true,
        'message': "login was successful"
      });

      return returnMessage;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> reset({
    required String email,
  }) async {
    try {
      var returnMessage = "";
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email)
          .then((value) => returnMessage = "password reset was successfully")
          .catchError((e) => returnMessage = e.toString());


      await FirebaseFirestore.instance
          .collection('notification')
          .add({
        'title': "Password Reset",
        'email': email,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'status': true,
        'message': returnMessage
      });



      return returnMessage;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> addUser(
      {required String email,
      required String role,
      required String name,
      required String phone,
      required String bio,
      required String location,
      required String shopName,
      }) async {
    try {


      String lat = "not applicable";
      String long = "not applicable";


      if(role != "Basic User"){


        const apiKey = 'AIzaSyArXMbGYaxzdmt0diLK9x8aBZLyij51PBU';
        final LocatitonGeocoder geocoder = LocatitonGeocoder(apiKey);
        final address = await geocoder.findAddressesFromQuery(location);
        print(address.first.coordinates.longitude);

        long = address.first.coordinates.longitude.toString();
        lat = address.first.coordinates.latitude.toString();
      }



      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'full_name': name,
        'email': email,
        'role': role,
        'phone': phone,
        'bio': bio,
        'lat': lat,
        'long': long,
        'shopName': shopName,
        'location': location,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'status': true,
        'photoUrl': "empty"
      });

      return 'Added user';
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> addUserClick(
      {required String email,
      required String role,
      required String name,
      required String phone,
      required String bio,
      required String location,
      required String shopName,
        required String nameUser,
        required String phoneUser,
        required String emailUser,
      }) async {
    try {


      String lat = "not applicable";
      String long = "not applicable";


      if(role != "Basic User"){
        const apiKey = 'AIzaSyArXMbGYaxzdmt0diLK9x8aBZLyij51PBU';
        final LocatitonGeocoder geocoder = LocatitonGeocoder(apiKey);
        final address = await geocoder.findAddressesFromQuery(location);
        print(address.first.coordinates.longitude);

        long = address.first.coordinates.longitude.toString();
        lat = address.first.coordinates.latitude.toString();
      }



      await FirebaseFirestore.instance
          .collection('clicks').add({
        'full_name': name,
        'full_name_user': nameUser,
        'email': email,
        'emailUser': emailUser,
        'role': role,
        'phone': phone,
        'phoneUser': phoneUser,
        'bio': bio,
        'lat': lat,
        'long': long,
        'shopName': shopName,
        'location': location,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'status': true,
        'photoUrl': "empty"
      });

      return 'Added user';
    }
    on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> getUserDetails() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      var returnMessage = "";
        returnMessage = "welcome";
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('name', model.Users.fromSnap(documentSnapshot).name);
        prefs.setString('email', model.Users.fromSnap(documentSnapshot).email);
        prefs.setString('login', "in");
        prefs.setString('role', model.Users.fromSnap(documentSnapshot).role);
        prefs.setString('lat', model.Users.fromSnap(documentSnapshot).lat);
        prefs.setString('long', model.Users.fromSnap(documentSnapshot).long);
        prefs.setString('bio', model.Users.fromSnap(documentSnapshot).bio);
        prefs.setString('location', model.Users.fromSnap(documentSnapshot).location);
        prefs.setString('phone', model.Users.fromSnap(documentSnapshot).phone);
        prefs.setString('shopName', model.Users.fromSnap(documentSnapshot).shopName);
        prefs.setBool('status', model.Users.fromSnap(documentSnapshot).status);
        prefs.setString(
            'photoUrl', model.Users.fromSnap(documentSnapshot).photoUrl);


      return returnMessage;
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  createEvents({required String name, required String bio, required String location, Uint8List? file}) async {


    try {


      String photoUrl =
          "https://images.pexels.com/photos/12739401/pexels-photo-12739401.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2";

      if (file != null) {
        photoUrl =
        await StorageMethods().uploadImageToStorageWork('work', file);
      }



      await FirebaseFirestore.instance
          .collection('events').add({
        'location': location,
        'bio': bio,
        'name': name,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'status': true,
        'image': photoUrl
      });

      return 'Success!';
    }
    on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }




  }
  createIssue({ required String bio, required String location, Uint8List? file}) async {


    try {


      String photoUrl =
          "https://images.pexels.com/photos/12739401/pexels-photo-12739401.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2";

      if (file != null) {
        photoUrl =
        await StorageMethods().uploadImageToStorageWork('report', file);
      }



      final prefs = await SharedPreferences.getInstance();
      final getUserName = prefs.getString('name') ?? "";
      final getEmail = prefs.getString('email') ?? "";


      await FirebaseFirestore.instance
          .collection('reports').add({
        'location': location,
        'bio': bio,
        'name': getUserName,
        'email': getEmail,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'status': true,
        'image': photoUrl
      });

      return 'Success!';
    }
    on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }




  }
  postComment({required String username, required var event, required String comment}) async {


    try {





      await FirebaseFirestore.instance
          .collection('comment').add({
        'event': event,
        'name': username,
        'comment': comment,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'status': true,
      });

      return 'Success!';
    }
    on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }




  }





}
