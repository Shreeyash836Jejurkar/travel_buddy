// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types, duplicate_ignore, avoid_unnecessary_containers, sized_box_for_whitespace, file_names

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_buddy/data/getData.dart';
import 'package:travel_buddy/data/postData.dart';
import 'package:travel_buddy/screens/loadScreen.dart';
import 'package:travel_buddy/utils/getImageByte.dart';

class initialScreen extends StatefulWidget {
  const initialScreen({Key? key}) : super(key: key);

  @override
  State<initialScreen> createState() => _initialScreenState();
}

class _initialScreenState extends State<initialScreen> {
  var _imageSelected = true;

  File? image;
  late Uint8List base64Str;
  var originalTxt = "";
  var translatedTxt = "";
  var oTLang = "Hindi";
  var tTLang = "English";
  var toEng = "false";

  // Get OCR text
  getOCRText() async {
    var oTLang = toEng == "false" ? "English" : "Hindi";
    var tTLang = toEng == "false" ? "Hindi" : "English";

    Map? txt = await postV1ImageUpload(base64Str);
    print(txt);
    Map txt2 = await getData(txt!['text'], toEng);
    print("Here");
    print("check====>" + txt2['orignalText']);
    print("Noew here");
    setState(() {
      originalTxt = txt['text'];
      translatedTxt = txt2['translatedText'];
    });
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) =>
            loadScreen(originalTxt, translatedTxt, oTLang, tTLang, toEng)));
  }

  // camera capture
  imageFrontCamera() async {
    // ignore: deprecated_member_use
    PickedFile? img = await ImagePicker().getImage(source: ImageSource.camera);
    if (img != null) {
      setState(() {
        image = File(img.path);
      });
      getResult();
    }
  }

  // upload image
  imageFromGallery() async {
    // ignore: deprecated_member_use
    PickedFile? img = await ImagePicker().getImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() {
        image = File(img.path);
      });
      getResult();
    }
  }

  getResult() async {
    var imageByte = await getImageByte(image);
    setState(() {
      base64Str = imageByte;
    });
    getOCRText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Row(
          children: [
            Icon(Icons.translate_outlined),
            SizedBox(width: 10),
            Text("Travel Buddy"),
          ],
        ),
      ),
      body: _imageSelected
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image(
                    image: AssetImage('assets/images/uploadFile.png'),
                    height: 300,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text("You don't have any Image Selected!!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87)),
                        Text(
                            "Capture Image or Upload Image to get the translated text in the respective language",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54))
                      ],
                    ),
                  ),
                ],
              ))
          : Container(
              child: Stack(children: [
                Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.file(image!, fit: BoxFit.contain)),
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black45,
                ),
                Center(
                    child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFFe0f2f1)),
                  child: Icon(
                    Icons.translate_rounded,
                    color: Colors.blueAccent,
                    size: 30,
                  ),
                )),
              ]),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          imageFrontCamera();
          _imageSelected = false;
        },
        tooltip: 'Scan',
        child: Icon(Icons.camera),
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  imageFromGallery();
                  _imageSelected = false;
                },
                icon: Icon(Icons.upload_file)),
            label: "Upload"),
        BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(toEng == "false"
                      ? SnackBar(content: Text('Hindi to English'))
                      : SnackBar(content: Text("English to Hindi")));
                  toEng == "true" ? toEng = "false" : toEng = "true";
                },
                icon: Icon(Icons.g_translate)),
            label: 'Settings')
      ]),
    );
  }
}
