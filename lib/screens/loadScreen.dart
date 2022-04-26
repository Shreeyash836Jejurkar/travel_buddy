// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new, camel_case_types, duplicate_ignore, sized_box_for_whitespace, avoid_unnecessary_containers, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:travel_buddy/data/getData.dart';
import 'package:travel_buddy/screens/initialScreen.dart';

class loadScreen extends StatefulWidget {
  final String originalTxt;
  final String translatedTxt;
  final String oTLang;
  final String tTLang;
  final String toEng;
  const loadScreen(this.originalTxt, this.translatedTxt, this.oTLang,
      this.tTLang, this.toEng,
      {Key? key})
      : super(key: key);

  @override
  State<loadScreen> createState() => _loadScreenState();
}

class _loadScreenState extends State<loadScreen> {
  final FlutterTts ftts = FlutterTts();

  var hText = "";
  var tText = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    String originalText = widget.originalTxt;
    String translatedText = widget.translatedTxt;

    _speak(lang, text) async {
      await ftts.setLanguage(lang);
      await ftts.setPitch(1);
      await ftts.setSpeechRate(0.5);
      await ftts.speak(text);
    }

    //re translate
    reTranslate(text) async {
      Map txt = await getData(text, widget.toEng);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => loadScreen(
              txt['orignalText'],
              txt['translatedText'],
              widget.oTLang,
              widget.tTLang,
              widget.toEng)));
    }

    swithLanguage() async {
      widget.toEng == "false"
          ? Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) =>
                  loadScreen(" ", " ", "Hindi", "English", "true")))
          : Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) =>
                  loadScreen(" ", " ", "English", "Hindi", "false")));
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (BuildContext context) => initialScreen())),
            icon: Icon(Icons.arrow_back_rounded)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text("Translated - Text"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: size.height * 0.08,
              child: Stack(
                children: [
                  Container(
                    height: size.height * 0.08 - 18,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        height: 54,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: kElevationToShadow[4]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Text(widget.oTLang,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w500)),
                              IconButton(
                                onPressed: () => swithLanguage(),
                                icon: Icon(Icons.compare_arrows_rounded),
                                color: Colors.blueAccent,
                              ),
                              Text(widget.tTLang,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Translate From",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16)),
                        Row(
                          children: [
                            Text(widget.oTLang,
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 16)),
                            IconButton(
                                icon: Icon(Icons.copy),
                                onPressed: () {
                                  Clipboard.setData(
                                          new ClipboardData(text: hText))
                                      .then((_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Copied to your clipboard !')));
                                  });
                                }),
                            IconButton(
                              icon: Icon(Icons.speaker_phone_rounded),
                              onPressed: () => _speak('hi-IN', hText),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      style: TextStyle(fontSize: 15),
                      controller: TextEditingController()..text = originalText,
                      onChanged: (text) {
                        hText = text;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: 8,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // ignore: avoid_unnecessary_containers
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Translate To",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16)),
                        Row(
                          children: [
                            Text(widget.tTLang,
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 16)),
                            IconButton(
                                icon: Icon(Icons.copy),
                                onPressed: () {
                                  Clipboard.setData(
                                          new ClipboardData(text: tText))
                                      .then((_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Copied to your clipboard !')));
                                  });
                                }),
                            IconButton(
                              icon: Icon(Icons.speaker_phone_rounded),
                              onPressed: () => _speak('en-IN', tText),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      style: TextStyle(fontSize: 15),
                      controller: TextEditingController()
                        ..text = translatedText,
                      onChanged: (text) {
                        tText = text;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: 8,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Divider(
              height: 8,
              thickness: 0.2,
              indent: 30,
              endIndent: 30,
              color: Colors.black54,
            ),
            SizedBox(height: 20),
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 20),
            //   child: Column(
            //     children: [
            //       Row(
            //         children: [
            //           Text("Know more",
            //               style:
            //                   TextStyle(color: Colors.black54, fontSize: 16)),
            //           SizedBox(width: 8),
            //           Icon(
            //             Icons.app_registration_rounded,
            //             color: Colors.black54,
            //           )
            //         ],
            //       )
            //     ],
            //   ),
            // )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () => {reTranslate(hText)},
        tooltip: 'Re-Translate',
        child: Icon(Icons.camera),
      ),
    );
  }
}
