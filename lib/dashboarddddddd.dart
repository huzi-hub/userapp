import 'package:flutter/material.dart';
import 'package:workersform/electricians.dart';

class dashboarddddddd extends StatelessWidget {
  dashboarddddddd({Key? key}) : super(key: key);
  var size, height, width;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal[500],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
        ),
        title: Text("AMM ADMI"),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  height: height * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Trending Services",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      )),
                ),
              ],
            ),
            // SizedBox(
            //   height: height * 0.05,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                workersBTN1(
                    context, "Geyser", "assets/geysero.jpg", Electricians()),
                workersBTN1(
                    context, "Stove", "assets/stove.png", Electricians()),
                workersBTN1(
                    context, "Builders", "assets/builder1.jpg", Electricians()),
              ],
            )
          ],
        ),
      ),
    );
  }

  ElevatedButton workersBTN1(BuildContext context, txt, img, page) {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 2, right: 2, top: 4, bottom: 4),
          child: Column(
            children: [
              Image.asset(img, height: 75, width: 65),
              Text(
                txt,
                style: TextStyle(color: Colors.teal[300]),
              ),
            ],
          ),
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white)));
  }
}
