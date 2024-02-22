import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

XFile? imageFile;

class ProfileViewViewModel extends BaseViewModel {

  chooseImageFromGallery() async
  {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedFile !=null)
    {
        imageFile = pickedFile;
    }
    rebuildUi();
  }
}
