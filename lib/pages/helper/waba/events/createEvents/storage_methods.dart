
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // adding image to firebase storage
  Future<String> uploadImageToStorage(String childName, Uint8List file,) async {
    // creating location to our firebase storage

    Reference ref =
    _storage.ref().child(childName).child(_auth.currentUser!.uid);

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putData(
        file
    );

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  Future<String> uploadImageToStorageWork(String childName, Uint8List file,) async {
    // creating location to our firebase storage

    Reference ref =
    _storage.ref().child(childName).child(DateTime.now().millisecondsSinceEpoch.toString());

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putData(
        file
    );

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<List> fetchAds(String currentDate) async {
    QuerySnapshot querySnapshot = await _fireStore.collection('ads').get();

    // Get data from docs and convert map to List
    //final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    //for a specific field
    final allData = querySnapshot.docs.map((doc) => doc.get('ads')).toList();
    final allDataList = querySnapshot.docs.map((doc) => doc.get('ads'));

    Iterable me = allDataList;
    print(allDataList.length);
    print("allDataListDD${me.length}");
    print("allDataListDD${me.length}");
    print(allData);

    print("allData${allData[0].length}");
    print("allData${allData[0].length}");
    print("allData${allData[0].length}");
    getData();
    return allData[0];
  }
  Future  fetchWork() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    QuerySnapshot eventsQuery = await ref
        .where("titles", arrayContainsAny: ['driver'])
        .where("location_status", isEqualTo: true)
        .get();
    final allData =
    eventsQuery.docs.map((doc) => doc.get('location')).toList();

    print("jygsha$allData");
  }
  Future <String> likeWork(int timestampGot,String numberPhone) async {
    String message = "liked";

    try {
      final post = await _fireStore
          .collection('users')
          .where('timestamp', isEqualTo: timestampGot)
          .limit(1)
          .get()
          .then((QuerySnapshot snapshot) {
        //Here we get the document reference and return to the post variable.
        return snapshot.docs[0].reference;
      });

      var batch = _fireStore.batch();
      var liked = [numberPhone];
      //Updates the field value, using post as document reference
      batch.update(post, { 'liked': liked });
      batch.commit();

    } catch (e) {
      message = e.toString();

      print(e);
    }
    return message;
  }
  Future <String> review(String numberPhone, int selectedValue1, String comment, String workId, String currentAddress) async {
    String message = "rated successfully";
    
    double? rated = selectedValue1.toDouble();
    String email = "";

    try {
      final post = await _fireStore
          .collection('users')
          .where('number', isEqualTo: numberPhone)
          .where('role', isEqualTo: "Freelance")
          .limit(1)
          .get()
          .then((QuerySnapshot snapshot) {
        //Here we get the document reference and return to the post variable.


        Map<String, dynamic>? getMapList = snapshot.docs[0].data() as Map<String, dynamic>?;
        if(getMapList!.containsKey("ratings")){
            var getRating = snapshot.docs[0].get("ratings");
            print("meme");
            rated = (rated! + getRating)/2;
        }

        email = snapshot.docs[0].get("email");

        print(snapshot.docs[0].data());
        return snapshot.docs[0].reference;


      });

      var batch = _fireStore.batch();
      //Updates the field value, using post as document reference
      batch.set(post, { 'ratings': rated },SetOptions(merge: true));
      batch.commit();

      //notification
      await FirebaseFirestore.instance
          .collection('notification')
          .add({
        'title': "Rated",
        'email': email,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'status': true,
        'message': "Hello you have been rated $rated stars"
      });
      //ratings

      final prefs = await SharedPreferences.getInstance();
      final getUserName = prefs.getString('name') ?? "";
      final getImage = prefs.getString('photoUrl') ?? "";

      Map<String, dynamic>? getReview = {"name":getUserName,"comment":comment,"ratings":selectedValue1,"dp":getImage,"phone":numberPhone,"location":currentAddress};



      await FirebaseFirestore.instance
          .collection('ratings')
          .add(getReview);


      await FirebaseFirestore.instance
          .collection('work').doc(workId).set({
        'rated': true,
      },SetOptions(merge: true));


    } catch (e) {
      message = e.toString();

      print(e);
    }
    return message;
  }
  Future <String> updateEdit(String type,String content) async {
    String message = "successful";

    try {
     _fireStore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid).update({ type : content});

     final prefs = await SharedPreferences.getInstance();
     prefs.setString(type == "number" ? "number" : "name", content);

     print(type);
     print(type);
     print(type);

    } catch (e) {
      message = e.toString();

      print(e);
    }
    return message;
  }
  Future <String> unlikeWork(int timestampGot,String numberPhone) async {
    String message = "unliked";

    try {
      final post = await _fireStore
          .collection('users')
          .where('timestamp', isEqualTo: timestampGot)
          .limit(1)
          .get()
          .then((QuerySnapshot snapshot) {
        //Here we get the document reference and return to the post variable.
        return snapshot.docs[0].reference;
      });

      var batch = _fireStore.batch();
      var liked = [numberPhone];
      //Updates the field value, using post as document reference
      batch.update(post, { 'liked': FieldValue.arrayRemove(liked)});
      batch.commit();

    } catch (e) {
      message = e.toString();

      print(e);
    }
    return message;
  }

  final _fireStore = FirebaseFirestore.instance;
  Future<List> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _fireStore.collection('ads').get();

    // Get data from docs and convert map to List
    //final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    //for a specific field
    final allData = querySnapshot.docs.map((doc) => doc.get('ads')).toList();

    print(allData);

    return allData;
  }




}