import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_first_app/app/app.locator.dart';
import 'package:my_first_app/methods/common_methods.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

XFile? imageFile;
 String urlOfUploadedImage = "";

class ProfileViewViewModel extends BaseViewModel {
  CommonMethods cmethods = CommonMethods();

  chooseImageFromGallery() async
  {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedFile !=null)
    {
        imageFile = pickedFile;
    }
    BuildContext? context = locator<NavigationService>().navigatorKey?.currentContext!;
    rebuildUi();
     await cmethods.checkConnectivity(context!);

     if(imageFile!=null)
     {
      uploadImageToStorage();
     }
     else
     {
      cmethods.displaySnackbar("Please choose image first", context);
     }
  }
  uploadImageToStorage() async
  {
    String imageIDName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceImage = FirebaseStorage.instance.ref().child("Images").child(imageIDName);
    UploadTask uploadTask = referenceImage.putFile(File(imageFile!.path));
    TaskSnapshot snapshot = await uploadTask;
    urlOfUploadedImage = await snapshot.ref.getDownloadURL();
    rebuildUi();
  }
}
