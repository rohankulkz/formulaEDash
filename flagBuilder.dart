
import "dart:developer";

import "package:flutter/material.dart";

Container getFlagAssessmentWidget(TextEditingController textEditingController,VoidCallback filePicker, VoidCallback uploadCall, String fileName){

  return

  Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.withOpacity(0.4))
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      Container(
      width: 900,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25), bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0)),

                color: Colors.grey.withOpacity(0.15),
                //border: Border.all(color: Colors.black.withOpacity(0.4))
              ),
              width: 900,
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 25, top: 20, bottom: 0, right: 0),
                    child: Text("Upload .csv File", style: TextStyle(fontSize: 20),),
                  ),
                ],
              )
          ),
          Container(

          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200,

                margin: EdgeInsets.only(left: 25, top: 50, right: 0, bottom: 20),
                child: const Text(
                  "Nickname",
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 400, top: 50, right: 0, bottom: 20),
                width: 200,
                child: Text(
                  "File " + "($fileName)",
                ),
              ),
            ],
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200,

                margin: EdgeInsets.only(left: 25, top: 0, right: 0, bottom: 20),
                child: TextField(
  decoration: InputDecoration(
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
  hintText: "Nickname"
  ),
  controller: textEditingController,
  )
              ),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                margin: EdgeInsets.only(left: 370, top: 0, right: 0, bottom: 20),
                width: 150,
                child: InkWell(
  borderRadius: BorderRadius.circular(20),
  onTap: filePicker,
  child: Padding(
  padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
  child: Text("Pick File"),
  ),
  )
              ),
            ],
          ),


        ],

      ),
    ),
        Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              //border: Border.all(color: Colors.black.withOpacity(0.4))
            ),
          margin: EdgeInsets.only(top: 50, bottom: 25),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: uploadCall,
          child: Padding(
            padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
            child: Text("Upload"),
          ),
        )
        )
      ],
    ),
  );

}
