import 'package:cached_network_image/cached_network_image.dart';
import 'package:chemba/authetication/backend/authServices.dart';
import 'package:chemba/dialog/dialogGood.dart';
import 'package:chemba/dialog/dialogLoadWait.dart';
import 'package:chemba/pages/widgets/headers.dart';
import 'package:chemba/resource/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewEvents extends StatefulWidget {
  Map<String, dynamic> snapGet;
   ViewEvents({Key? key, required this.snapGet}) : super(key: key);

  @override
  State<ViewEvents> createState() => _ViewEventsState();
}

class _ViewEventsState extends State<ViewEvents> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorList.white,
      body: Column(
        children: [
          Headers(title: "Comments",getBack: true,),
          jobList(snap: widget.snapGet),
          Expanded(child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('comment')
                      .where("event", isEqualTo: widget.snapGet["timestamp"])
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                      snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: LoadingAnimationWidget.dotsTriangle(
                          color: ColorList.greenMain,
                          size: 200,
                        ),
                      );
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return Column(
                        children: const [
                          Center(
                            child: Text(
                              "There is no comment available",
                              maxLines: 1,
                              style: TextStyle(
                                color: ColorList.greenMain,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (ctx, index) => historyHolder(
                        snap: snapshot.data!.docs[index].data(),
                      ),
                    );
                  },
                )),
            inputComment()
          ],
          )
          )
        ],
      ),
    );
  }


  TextEditingController getComment = TextEditingController();

  bool textPost = false;

  Widget inputComment() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 0, right: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: TextField(
              cursorColor: ColorList.greenMain.withOpacity(.5),
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              onChanged: (value){
                if(value.isNotEmpty){
                  setState(() {
                    textPost = true;
                  });

                }else{
                  setState(() {
                    textPost = false;
                  });

                }
              },
              maxLines: null,
              style: const TextStyle(
                  color: ColorList.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
              controller: getComment,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: ColorList.greenMain.withOpacity(.2),
                hintText: 'Add a comment',
                suffixIcon: InkWell(
                  onTap: (){
                    if(textPost == true){
                      createUser();
                    }
                  },
                  child:  Icon(
                    CupertinoIcons.arrow_right_circle_fill,
                    size: 24,
                    color: textPost == true ? ColorList.greenMain : ColorList.lightGrey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0.0),
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
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget jobList({required Map<String, dynamic> snap}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: ColorList.greenMain.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 100,
              height: 110,
              decoration: BoxDecoration(
                //decoration for the outer wrapper
                color: ColorList.greenMain,
                borderRadius: BorderRadius.circular(20),
              ),
              child: CachedNetworkImage(
                imageUrl: snap['image'],
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) =>
                const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        snap['name'],
                        maxLines: 1,
                        style: const TextStyle(
                          color: ColorList.greenMain,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          const Icon(Icons.location_on_outlined,color: ColorList.greenMain,size: 18,),
                          Flexible(
                            child: Column(
                              children: [
                                Text(snap['location'],
                                    style: const TextStyle(
                                      color: ColorList.greenMain,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(snap['bio'],
                          style: const TextStyle(
                            color: ColorList.greenMain,
                            fontSize: 13,
                            fontWeight: FontWeight.w100,
                          )),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const SizedBox(height: 9),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget historyHolder({required Map<String, dynamic> snap}) {
    IconData iconData = Icons.account_circle;
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      decoration: BoxDecoration(
        color: ColorList.greenMain.withOpacity(.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ColorList.greenMain.withOpacity(.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                iconData,
                size: 24,
                color: ColorList.greenMain.withOpacity(.9),
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
                  snap["name"],
                  style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: ColorList.greenMain,
                      fontSize: 16),
                ),
                Text(
                  snap["comment"],
                  style: const TextStyle(
                      fontWeight: FontWeight.w100,
                      color: ColorList.greenMain,
                      fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> createUser() async {
    showAlertDialog(context);

    //check if the email exist

    final message = await AuthService().postComment(
      event: widget.snapGet["timestamp"],
      comment: getComment.text,
      username: nameUsed,
    );




    Navigator.of(context, rootNavigator: true).pop();
    var messageNext = message;
    if (message!.contains('Success')) {
      //open her the splashscreen
      takeMessage = 'Success!';
      messageNext = "posted";
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
                getComment.clear();
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }

  var nameUsed = "John Edins";
  var emailUsed = "eddinsstivons@gmail.com";

  Future<void> setData() async {
    final prefs = await SharedPreferences.getInstance();
    final getUserName = prefs.getString('name') ?? "";
    final getEmail = prefs.getString('email') ?? "";
    setState(() {
      nameUsed = getUserName;
      emailUsed = getEmail;

    });
  }

}
