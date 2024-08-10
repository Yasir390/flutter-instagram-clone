
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/services/flutter_toast.dart';

 pickImage({required ImageSource source}) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? image = await imagePicker.pickImage(source: source);
  if (image != null) {
    return await image.readAsBytes();
  }
  toastMsg(msg: 'No image selected');
}