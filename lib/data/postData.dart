import 'dart:convert';

import 'package:http/http.dart';

Future<Map?> postV1ImageUpload(imageCroppedBytes) async {
  Map? respMap;
  try {
    Uri url = Uri.parse("http://adityayadav800.pythonanywhere.com/OCRImage");

    var request = MultipartRequest('POST', url);

    var image = MultipartFile.fromBytes('file', imageCroppedBytes,
        filename: 'profileImage.jpg');
    request.files.add(image);

    var resp = await request.send();
    String response1 = await resp.stream.bytesToString();
    respMap = jsonDecode(response1);
    respMap!["resp_code"] = resp.statusCode.toString();
    print("cg url  $url");
    //print("output :${response.body.toString()}");
  } on Exception catch (e) {
    print("Error Message : " + e.toString());
  }
  // print(respMap);
  return respMap;
}
