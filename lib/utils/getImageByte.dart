import 'dart:convert';
import 'dart:typed_data';

getImageByte(image) async {
  Uint8List imagebytes = await image.readAsBytes(); //convert to bytes
  String base64string =
      base64.encode(imagebytes); //convert bytes to base64 string
  print(base64string);
  return imagebytes;
}
