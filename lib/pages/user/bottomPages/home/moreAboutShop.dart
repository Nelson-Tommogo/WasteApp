import 'dart:convert';

import 'package:chemba/pages/helper/payment/payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chemba/dialog/dialogGood.dart';
import 'package:chemba/dialog/dialogLoadWait.dart';
import 'package:chemba/resource/color.dart';
import 'package:flutterbudpay/flutterbudpay.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MoreAboutShop extends StatefulWidget {
  Map<String, dynamic> data;

  MoreAboutShop({Key? key, required this.data}) : super(key: key);

  @override
  State<MoreAboutShop> createState() => _MoreAboutShopState();
}

class _MoreAboutShopState extends State<MoreAboutShop> {


  var publicKey = 'Add your BudPay Public Key Here';
  var secretKey = 'Add your Budpay Secret Key Here';
  final plugin = Budpay();



  @override
  void initState() {
    // TODO: implement initState
    setDataHere();
    plugin.initialize(publicKey: publicKey,secretKey:secretKey);
    super.initState();
  }

  var getUserRole = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorList.white,
      body: ListView(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).viewPadding.top > 0 ? 40 : 10),
        children: <Widget>[
          InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: backButton())),
          SizedBox(
            height: (MediaQuery.of(context).size.height / 4) - 5,
            width: (MediaQuery.of(context).size.width / 4) - 5,
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Hero(
                    tag: "logo",
                    child: Image.asset(
                      "images/logo.png",
                      width: 40,
                    ))),
          ),
          const SizedBox(
            height: 40,
          ),
          Column(
            children: [
              Text(
                getUserRole,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: ColorList.greenMain,
                ),
              )
            ],
          ),
          inputName(),
          inputEmail(),
          inputNumber(),
          inputShopName(),
          inputLocation(),
          inputBio(),
          Visibility(
            visible: getUserRole == "Garbage Collector" ? true : false,
              child: buttonNext()),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  TextEditingController getEmail = TextEditingController();
  TextEditingController getName = TextEditingController();
  TextEditingController getShopName = TextEditingController();
  TextEditingController getLocation = TextEditingController();
  TextEditingController getBio = TextEditingController();
  TextEditingController getPassword = TextEditingController();
  TextEditingController getPhoneNumber = TextEditingController();

  Widget inputEmail() {
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
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                  color: ColorList.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
              controller: getEmail,
              readOnly: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: ColorList.greenMain.withOpacity(.2),
                hintText: 'Email',
                suffixIcon: const Icon(
                  Icons.email_outlined,
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

  Widget backButton() {
    return const Icon(
      CupertinoIcons.arrow_left_square_fill,
      size: 34,
      color: ColorList.greenMain,
    );
  }

  Widget inputName() {
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
              readOnly: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: ColorList.greenMain.withOpacity(.2),
                hintText: 'Full name',
                suffixIcon: const Icon(
                  Icons.account_circle_outlined,
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

  Widget inputShopName() {
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
              controller: getShopName,
              readOnly: true,
              maxLines: 2,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: ColorList.greenMain.withOpacity(.2),
                hintText: 'Shop name',
                suffixIcon: const Icon(
                  Icons.shopping_basket,
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
              maxLines: 10,
              style: const TextStyle(
                  color: ColorList.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
              controller: getBio,
              readOnly: true,
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
              maxLines: 2,
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

  Widget inputNumber() {
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
              keyboardType: TextInputType.number,
              style: const TextStyle(
                  color: ColorList.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
              controller: getPhoneNumber,
              readOnly: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: ColorList.greenMain.withOpacity(.2),
                hintText: 'Phone Number',
                suffixIcon: const Icon(
                  Icons.phone,
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

  void setDataHere() {
    setState(() {
      getUserRole = widget.data["role"];
      getEmail.text = widget.data["email"];
      getName.text = widget.data["full_name"];
      getShopName.text = widget.data["shopName"];
      getLocation.text = widget.data["location"];
      getBio.text = widget.data["bio"];
      getPhoneNumber.text = widget.data["phone"];
    });
  }



  Widget buttonNext() {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>  Payment(ticketName: getUserRole,data: widget.data)));


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
            'Continue',
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


  Future<void> makePayments() async {
    showAlertDialog(context);

    //check if the email exist



    final message = await addData();


    Navigator.of(context, rootNavigator: true).pop();
    var messageNext = message;
    if (message!.contains('sent')) {
      //open her the splashscreen
      takeMessage = 'Success!';
      messageNext = "Sent successfully";
    } else {
      takeMessage = 'Error!';
    }




    showAlertDialogGood(messageNext!,buttonOk(),takeMessage);
    //then load the user to the database
  }

  var   messageDataUrl = "";

  Future<String> addData() async {
    var message = "error";
    try {

      Map<String, String> data = {
        "email": getEmail.text,
        "amount": "20",
        "currency": "KES",
        "reference": DateTime.now().millisecondsSinceEpoch.toString(),
        "callback":"www.budpay.com"

      };

      final getUrl = Uri.parse("https://api.budpay.com/api/v2/transaction/initialize");


      final uri = getUrl.replace(queryParameters: data );
      var response = await http.post(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer sk_live_cswltnqwc2rp7dedhblxpxmuoaz880jgqmi92dz',
      });

      print(response.body.toString());
      var jsonResponse = json.decode(response.body.toString());
      final messageData = jsonResponse['status'];



      if(messageData == true){
        message = 'sent';
         messageDataUrl = jsonResponse['data']['authorization_url'];
        print(messageDataUrl);

      }else{
        message = "Try Again";
      }
    }catch (e) {
      message = e.toString();
    }

    return message;
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

                // _launchURL();
                _launchInBrowser();
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


  _launchURL() async {
    if (await canLaunchUrl(Uri.parse(messageDataUrl))) {
      await launchUrl(Uri.parse(messageDataUrl));
    } else {
      throw 'Could not launch $messageDataUrl';
    }
  }

  Future<void> _launchInBrowser() async {

    // final String query = "";
    //
    // final String encodedQuery = Uri.encodeFull(query);
    // final String url = 'https://www.google.com/search?q=$encodedQuery';

    //https://inline-merchant.budpay.com/pay/api?reference

     String query = messageDataUrl.replaceAll("https://inline-merchant.budpay.com/pay/api?reference=", "");
    final String encodedQuery = Uri.encodeFull(query);
    final String url = '${messageDataUrl.replaceAll(query, "")}$encodedQuery';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }

  }

}
