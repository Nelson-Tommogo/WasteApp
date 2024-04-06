import 'package:chemba/pages/widgets/headers.dart';
import 'package:chemba/resource/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:ticket_widget/ticket_widget.dart';

class Payment extends StatefulWidget {
  String ticketName;
  Map<String, dynamic> data;
   Payment({Key? key, required this.ticketName, required this.data}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorList.white,
      body: Column(
        children: [
          Headers(title: "Receipt",getBack: true,),
          Expanded(child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Center(
                child: TicketWidget(
                  width: MediaQuery.of(context).size.width - 50,
                  height: MediaQuery.of(context).size.height - 200,
                  isCornerRounded: true,
                  color: ColorList.greenMain,
                  padding: const EdgeInsets.all(20),
                  child: ticketData(),
                ),
              ),
              buttonNext()
            ],
          ))
        ],
      ),
    );
  }


  Widget buttonNext() {
    return InkWell(
      onTap: () {


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
            'Pay',
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


  Widget ticketData(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 120.0,
              height: 25.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(width: 1.0, color: ColorList.white),
              ),
              child:  Center(
                child: Text(
                  widget.data["timestamp"].toString(),
                  style: const TextStyle(color: ColorList.white),
                ),
              ),
            ),
            Row(
              children: const [

              ],
            )
          ],
        ),
         Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            widget.ticketName,
            style: const TextStyle(
                color: ColorList.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ticketDetailsWidget(
                  'Full Name', widget.data["full_name"], 'Date', DateFormat('yMd').format(DateTime.now())),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, right: 52.0),
                child: ticketDetailsWidget('Company', widget.data["shopName"],'', ""),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, right: 53.0),
                child: ticketDetailsWidget('Location', widget.data["location"], '', ''),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 80.0, left: 30.0, right: 30.0),
          child: SizedBox(
            height: 150,
            child: SfBarcodeGenerator(value: widget.data["phone"],symbology: QRCode(), barColor: ColorList.white,),
          ),
        ),
         Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 25.0, right: 25.0),
          child: Center(
            child: Text(
              widget.data["phone"],
              style: const TextStyle(
                color: ColorList.white,
                fontWeight: FontWeight.bold,
                fontSize: 24
              ),
            ),
          ),
        ),

        const Text('')
      ],
    );
  }
  }

  Widget ticketDetailsWidget(String firstTitle, String firstDesc,
      String secondTitle, String secondDesc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                firstTitle,
                style: const TextStyle(color: ColorList.white),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: SizedBox(
                  width: 200,
                  child: Text(
                    firstDesc,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                secondTitle,
                style: const TextStyle(color: ColorList.white),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Column(
                  children: [
                    Text(

                      secondDesc,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
}
