import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/widgets.dart';


class Storage {
  final firebase_storage.FirebaseStorage storage = 
    firebase_storage.FirebaseStorage.instance;
  
  
  Future <String> downloadURL(String imageName) async {
  try{
    String downloadURL = await storage.ref('$imageName').getDownloadURL() as String;
    return downloadURL;
  }
  catch(error){
    print("file not found");
  }
  return downloadURL(imageName);
}
}
