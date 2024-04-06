import 'package:cached_network_image/cached_network_image.dart';
import 'package:chemba/pages/helper/waba/events/createEvents/createEvents.dart';
import 'package:chemba/pages/helper/waba/events/view/viewEvents.dart';
import 'package:chemba/resource/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class Events extends StatefulWidget {
  const Events({Key? key}) : super(key: key);

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorList.white,
      body: Stack(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('events')
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: LoadingAnimationWidget.dotsTriangle(
                    color: ColorList.white,
                    size: 100,
                  ),
                );
              }
              if (snapshot.data!.docs.isEmpty) {
                return Column(
                  children: const [
                    Center(
                      child: Text(
                        "You currently having zero events.",
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
                itemBuilder: (ctx, index) => jobList(
                  snap: snapshot.data!.docs[index].data(),
                ),
              );
            },
          ),
          Positioned(
              bottom: 25,
              right: 25,
              child:floatButton()),
        ],
      ),
    );
  }


  Widget floatButton(){
    return  InkWell(
      onTap: (){
        pushNewScreen(
          context,
          screen:  const CreateEvents(),
          withNavBar: false, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.slideRight,
        );
      },
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: ColorList.greenMain,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: ColorList.greenMain.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),

          child: const Icon(
            Icons.add_rounded,
            size: 24,
            color: ColorList.white,
          )),
    );
  }

  Widget jobList({required Map<String, dynamic> snap}) {
    return GestureDetector(
      onTap: () {
        pushNewScreen(
          context,
          screen:   ViewEvents(snapGet: snap),
          withNavBar: false, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.slideRight,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
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
      ),
    );
  }
}
