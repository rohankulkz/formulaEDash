import 'dart:html';

import 'package:flutter/material.dart';






List<double> getColumn(List<List<String>> records, int column) {

  List<double> response = [];
  for (List<String> row in records) {
    response.add(double.parse(row[column]));
  }
  return response;
}






Container generateUsersTable(List<Map<String, String>> records) {
  List<Widget> rows = [];

  for (int i=0; i<records.length; i++) {
    if(i<records.length-1){
    rows.add(generateUserRow(records[i], true));
    }
    else{
      rows.add(generateUserRow(records[i], false));

    }
  }

  return Container(
    margin: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: rows,
    ),
  );
}

Container generateRawTable(List<List<String>> records, int start, int end) {
  List<Widget> rows = [];

  if(records.length>25){
    records = records.sublist(start,end);
  }


  for (List<String> s in records){
    rows.add(generateRawRow(s));
  }

  return Container(
    margin: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: rows,
    ),
  );
}

Row generateRawRow(List<String> data){
  List<Container> constructedRow = [];

  for( String s in data){
    constructedRow.add(
        Container(
          width: 170,
          margin: EdgeInsets.only(left: 20, top: 0, bottom: 0, right: 0),
          child: SelectableText(s),
        )
    );
  }

  return Row(
    children: constructedRow,
  );
}



double subtextOpacity = 0.6;

Container generateUserRow(Map<String, String> data, bool fullBorder) {
  if(fullBorder){
  return Container(
    height: 50,
    width: 900,
    decoration: BoxDecoration(
      border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.4), width: 0.5))

  ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 342,
          margin: EdgeInsets.only(left: 25, top: 0, bottom: 0, right: 0),
          child:  SelectableText(data["name"]!,style: TextStyle(color: Colors.black.withOpacity(subtextOpacity))),
        ),
        Container(
          width: 145,
          margin: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
          child: SelectableText(data["sentiment"]!,style: TextStyle(color: Colors.black.withOpacity(subtextOpacity))),
        ),
        Container(
          width: 157,
          margin: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
          child:  SelectableText(data["satisfaction"]!, style: TextStyle(color: Colors.black.withOpacity(subtextOpacity))),
        ),
        Container(
          margin: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
          child:  SelectableText(data["reminder"]!, style: TextStyle(color: Colors.black.withOpacity(subtextOpacity))),
        )
      ],
    ),
  );
  }
  else{
    return Container(
      height: 50,
      width: 900,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.4), width: 0.5))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 342,
            margin: EdgeInsets.only(left: 25, top: 0, bottom: 0, right: 0),
            child:  SelectableText(data["name"]!, style: TextStyle(color: Colors.black.withOpacity(subtextOpacity)),),
          ),
          Container(
            width: 145,
            margin: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
            child: SelectableText(data["sentiment"]!, style: TextStyle(color: Colors.black.withOpacity(subtextOpacity))),
          ),
          Container(
            width: 157,
            margin: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
            child:  SelectableText(data["satisfaction"]!, style: TextStyle(color: Colors.black.withOpacity(subtextOpacity))),
          ),
          Container(
            margin: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
            child:  SelectableText(data["reminder"]!, style: TextStyle(color: Colors.black.withOpacity(subtextOpacity))),
          )
        ],
      ),
    );
  }
}
