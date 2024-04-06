import 'dart:typed_data';

import 'package:chemba/authetication/backend/authServices.dart';
import 'package:chemba/dialog/dialogGood.dart';
import 'package:chemba/dialog/dialogLoadWait.dart';
import 'package:chemba/pages/widgets/headers.dart';
import 'package:chemba/resource/color.dart';
import 'package:chemba/resource/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'dart:io' show Platform;

import 'package:image_picker/image_picker.dart';

class CreateEvents extends StatefulWidget {
  const CreateEvents({Key? key}) : super(key: key);

  @override
  State<CreateEvents> createState() => _CreateEventsState();
}

class _CreateEventsState extends State<CreateEvents> {

  Uint8List? _image;

  TextEditingController getLocation = TextEditingController();
  TextEditingController getBio = TextEditingController();
  TextEditingController getTime = TextEditingController();
  TextEditingController getName = TextEditingController();


  String get location => getLocation.text.trim();
  String get bio => getBio.text.trim();
  String get time => getTime.text.trim();
  String get name => getName.text.trim();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorList.white,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Headers(title: "Create Event",getBack: true,),


          Stack(
            children: [
              _image != null
                  ?
              Container(
                width: double.infinity,
                height: 160,
                margin: const EdgeInsets.only(top: 2, left: 15, right: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(image: MemoryImage(_image!),fit:BoxFit.cover)
                ),
              )
                  :
              Container(
                width: double.infinity,
                height: 160,
                margin: const EdgeInsets.only(top: 2, left: 15, right: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: ColorList.greenMain, //                   <--- border color
                      width: 1.0,
                    )
                ),
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      backgroundColor: ColorList.greenMain.withOpacity(0.4),
                      radius: 50,
                      child: const Icon(Icons.image_rounded,color: ColorList.greenMain,size: 60,),
                    ),
                    const Text("select below to add image",style: TextStyle(fontSize: 13,color: ColorList.greenMain,fontWeight: FontWeight.w200),),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          imageSign(),
          inputEventName(),
          inputLocation(),
          inputBio(),
          buttonNext()

        ],
      ),
    );
  }


  Widget buttonNext() {
    return InkWell(
      onTap: () {
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Holder()));

        if (location.isNotEmpty && name.isNotEmpty && bio.isNotEmpty && _image != null) {
          createEvent();
        } else {
          Fluttertoast.showToast(
              msg: "please do not leave any blanks",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
        child: Container(
          padding: const EdgeInsets.all(15),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: ColorList.greenMain,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            'Post',
            style: TextStyle(
              color: ColorList.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
  Future<void> createEvent() async {
    showAlertDialog(context);

    //check if the email exist


    final message =   await AuthService().createEvents(
      name: getName.text,
      bio: getBio.text,
      location: getLocation.text,
      file: _image,
    );




    Navigator.of(context, rootNavigator: true).pop();
    var messageNext = message;
    if (message!.contains('Success')) {
      //open her the splashscreen
      takeMessage = 'Success!';
      messageNext = "account was set up successfully";
    } else {
      takeMessage = 'Error!';
    }




    showAlertDialogGood(messageNext!,buttonOk(),takeMessage);
    //then load the user to the database
  }



  showAlertDialog(BuildContext contexts) async {
    showDialog(
      context: contexts,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DialogLoadWait();
      },

    );
  }

  var takeMessage = '';
  Widget buttonOk() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              Navigator.pop(context);

              if (takeMessage == 'Success!') {
                //open her the splashscreen
                Navigator.pop(context);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: takeMessage == 'Success!' ? ColorList.green : ColorList.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'ok',
                style: TextStyle(
                  color: ColorList.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  showAlertDialogGood(String message, Widget buttonOk,String title) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DialogGood(message: message, title: title,buttons: buttonOk,);
      },
    );
  }


  Widget imageSign() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ColorList.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: ColorList.greenMain.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: TextButton(
            onPressed: () {
              // add logic here
              selectImage("Gallery");
            },
            child: const Text(
              'Gallery',
              style: TextStyle(
                color: ColorList.greenMain,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Container(
          width: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ColorList.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: ColorList.greenMain.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: TextButton(
            onPressed: () {
              //add the logic
              selectImage("Camera");
            },
            child: const Text(
              'Camera',
              style: TextStyle(
                color: ColorList.greenMain,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        )
      ],
    );
  }
  selectImage(String type) async {
    Uint8List im;

    if(type == "Camera"){
      im = await pickImage(ImageSource.camera);
    }else{
      im = await pickImage(ImageSource.gallery);
    }

    setState(() {
      _image = im;
    });
  }


  Widget inputEventName() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: TextField(
              cursorColor: ColorList.greenMain.withOpacity(.5),
              keyboardType: TextInputType.text,
              style: const TextStyle(
                  color: ColorList.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
              controller: getName,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: ColorList.greenMain.withOpacity(.2),
                hintText: 'Event name',
                suffixIcon: const Icon(
                  Icons.event,
                  size: 24,
                  color: ColorList.greenMain,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      width: 1, color: ColorList.black.withOpacity(.0)),
                ),
                hintStyle: const TextStyle(
                    color: ColorList.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                labelStyle: const TextStyle(
                    color: ColorList.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1, color: ColorList.black.withOpacity(.0)),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget inputBio() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: TextField(
              cursorColor: ColorList.greenMain.withOpacity(.5),
              keyboardType: TextInputType.text,
              maxLines: 4,
              style: const TextStyle(
                  color: ColorList.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
              controller: getBio,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: ColorList.greenMain.withOpacity(.2),
                hintText: 'Bio',
                suffixIcon: const Icon(
                  Icons.account_tree_rounded,
                  size: 24,
                  color: ColorList.greenMain,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      width: 1, color: ColorList.black.withOpacity(.0)),
                ),
                hintStyle: const TextStyle(
                    color: ColorList.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                labelStyle: const TextStyle(
                    color: ColorList.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1, color: ColorList.black.withOpacity(.0)),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget inputLocation() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: TextField(
              readOnly: true,
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlacePicker(
                      apiKey: Platform.isAndroid
                          ? "AIzaSyAO6CcKrA0n1XTgIR6VHe-5G7P0p2KenGY"
                          : "AIzaSyAO6CcKrA0n1XTgIR6VHe-5G7P0p2KenGY",
                      onPlacePicked: (result) async {
                        // print(result.formattedAddress);
                        // print(result.vicinity);
                        // print(result.reference);
                        // print(result.adrAddress);
                        // print(result.addressComponents);
                        // print(result.geometry);
                        // print(result.placeId);
                        print("here 0ne ${result.toString()}");


                        setState(() {
                          getLocation.text = result.formattedAddress.toString();
                        });
                        Navigator.of(context).pop();



                      },
                      useCurrentLocation: true,
                      resizeToAvoidBottomInset: false,
                      initialPosition: const LatLng(-33.8567844, 151.213108), // only works in page mode, less flickery, remove if wrong offsets
                    ),
                  ),
                );
              },
              cursorColor: ColorList.greenMain.withOpacity(.5),
              keyboardType: TextInputType.text,
              style: const TextStyle(
                  color: ColorList.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
              controller: getLocation,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: ColorList.greenMain.withOpacity(.2),
                hintText: 'Location',
                suffixIcon: const Icon(
                  Icons.location_history,
                  size: 24,
                  color: ColorList.greenMain,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      width: 1, color: ColorList.black.withOpacity(.0)),
                ),
                hintStyle: const TextStyle(
                    color: ColorList.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                labelStyle: const TextStyle(
                    color: ColorList.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1, color: ColorList.black.withOpacity(.0)),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
