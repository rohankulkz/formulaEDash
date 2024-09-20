

import 'dart:developer' as l;
import 'dart:math';

List<Map<String,String>> generateRecords(int length){

  List<String> emotions = ["happy", "happy", "happy", "happy","happy", "happy", "sad", "mad", "tired", "tired", "neutral", "neutral", "neutral"];
  List<bool> reminder = [true, true, false, false, false, true];


  List<Map<String,String>> ret = [];
  for(int i= 0; i<length; i++){
    Map<String, String> data = {
      "name": "user $i",
      "sentiment": emotions[Random().nextInt(emotions.length-1)],
      "satisfaction": ((Random().nextInt(500)+480)/10).toString() + "%",
      "reminder" : reminder[Random().nextInt(reminder.length-1)].toString()
    };
    //log(data.toString());
    ret.add(data);
  }
  return ret;
}





 List<List<Map<String, String>>> compileRecords(List<Map<String,String>> data, int maxLength){
   List<List<Map<String, String>>> ret = [];

   for(int i=0; i<  data.length~/maxLength; i++){
     List<Map<String, String>> subList = [];
     for(int k=0; k <  maxLength; k++){
          subList.add(data[(maxLength*i)+k]);
     }
     ret.add(subList);
   }
   List<Map<String, String>> subList = [];

   for(int i = (data.length~/maxLength)*maxLength; i<data.length; i++){
     subList.add(data[i]);
   }
   ret.add(subList);
   //printRecords(ret);

   return ret;
 }


 void printRecords(List<List<Map<String, String>>> records){

  for(int i=0; i<records.length; i++){
   l.log("-------------------------New Array---------------------");
   for(int k=0; k<records[i].length; k++){
     l.log(records[i][k].toString());
   }
  }
}