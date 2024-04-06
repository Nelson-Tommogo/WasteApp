
import 'package:chemba/pages/helper/reportIssue/createIssue.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chemba/dialog/dialogGood.dart';
import 'package:chemba/pages/widgets/headers.dart';
import 'package:chemba/resource/color.dart';
import 'package:chemba/splash/splash.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorList.white,
      body: Column(
        children: [
          Headers(title: "Profile"),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                topProfile(),
                settingReport(),
                topBudPay(),
                settingHolder()
              ],
            ),
          )
        ],
      ),
    );
  }


  Widget topProfile() {
    return Expanded(
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                height: 140.0,
                width: 110.0,
                decoration: const BoxDecoration(
                  color: ColorList.greenMain,
                  borderRadius:
                  BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Center(
                  child: Text(
                    getInitials(string: nameUsed,limitTo: 2),
                    style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: ColorList.white,
                        fontSize: 40),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      nameUsed,
                      style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: ColorList.black,
                          fontSize: 25),
                    ),
                    Text(
                      emailUsed,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: ColorList.black.withOpacity(.5),
                          fontSize: 15),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ));
  }


  var nameUsed = "John Edins";
  var emailUsed = "eddinsstivons@gmail.com";
  var pointCount = 0;

  Future<void> setData() async {
    final prefs = await SharedPreferences.getInstance();
    final getUserName = prefs.getString('name') ?? "";
    final getEmail = prefs.getString('email') ?? "";

    int count = await FirebaseFirestore.instance
        .collection('reports')
        .where("email", isEqualTo: getEmail)
        .get()
        .then((value) => value.size);

    setState(() {
      nameUsed = getUserName;
      emailUsed = getEmail;

      pointCount = count;

      print(pointCount);
    });
  }


  String getInitials({required String string, required int limitTo}) {
    var buffer = StringBuffer();
    var split = string.split(' ');
    for (var i = 0 ; i < (limitTo ?? split.length); i ++) {
      buffer.write(split[i][0]);
    }

    return buffer.toString();
  }


  Widget settingHolder() {

   var nameHolder = "Logout";
    IconData iconData = Icons.logout_rounded;

    return InkWell(
      onTap: (){
        showAlertDialog("You are about to log out of your account.",buttonOk(),"Info!");
      },
      child: Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            decoration: BoxDecoration(
              color: ColorList.greenMain.withOpacity(.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ColorList.greenMain,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      iconData,
                      size: 24,
                      color: ColorList.white,
                    )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nameHolder,
                        style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: ColorList.greenMain,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
  Widget settingReport() {

   var nameHolder = "Report Issue";
    IconData iconData = Icons.report;

    return InkWell(
      onTap: (){
        pushNewScreen(
          context,
          screen:  const CreateIssues(),
          withNavBar: false, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.slideRight,
        ).then((value) async {
          int count = await FirebaseFirestore.instance
              .collection('reports')
              .where("email", isEqualTo: emailUsed)
              .get()
              .then((value) => value.size);

          setState(() {


            pointCount = count;

            print(pointCount);
          });
        });
      },
      child: Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            decoration: BoxDecoration(
              color: ColorList.greenMain.withOpacity(.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ColorList.greenMain,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      iconData,
                      size: 24,
                      color: ColorList.white,
                    )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nameHolder,
                        style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: ColorList.greenMain,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }


  Widget buttonOk() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: ColorList.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ColorList.greenMain,width: 1)
              ),
              child: const Text(
                'cancel',
                style: TextStyle(
                  color: ColorList.greenMain,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 5,),
        Expanded(
          child: InkWell(
            onTap: () async {

              SharedPreferences preferences = await SharedPreferences.getInstance();
              await preferences.clear();


              Navigator.of(context, rootNavigator: true).pop();

              Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => const Splash()));


            },
            child: Container(
              padding: const EdgeInsets.all(15),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: ColorList.greenMain,
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

  showAlertDialog(String message, Widget buttonOk,String title) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DialogGood(message: message, title: title,buttons: buttonOk,);
      },
    );
  }

  Widget topBudPay(){
    return Row(
      children: [
        Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              margin:
              const EdgeInsets.only(left: 20, right: 10, top: 10),
              decoration: BoxDecoration(
                color: ColorList.greenMain.withOpacity(.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: ColorList.greenMain,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.point_of_sale,
                        size: 24,
                        color: ColorList.white,
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      Text(
                        pointCount.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: ColorList.greenMain,
                            fontSize: 15),
                      ),
                      const Text(
                        "Points",
                        style: TextStyle(
                            fontWeight: FontWeight.w100,
                            color: ColorList.greenMain,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            )),
        Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(
                left: 10,
                right: 20,
                top: 10,
              ),
              decoration: BoxDecoration(
                color: ColorList.greenMain.withOpacity(.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: ColorList.greenMain,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.monetization_on_outlined,
                        size: 24,
                        color: ColorList.white,
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "0",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: ColorList.greenMain,
                            fontSize: 15),
                      ),
                      Text(
                        "Coins",
                        style: TextStyle(
                            fontWeight: FontWeight.w100,
                            color: ColorList.greenMain,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ],
    );
  }




}
