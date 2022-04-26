import 'dart:convert';

import 'package:http/http.dart' as http;

String getUrl = "http://adityayadav800.pythonanywhere.com/translater?text=";

Future<dynamic> getData(txtToTrans, toEng) async {
  final url = Uri.parse(getUrl + txtToTrans + "&htoe=" + toEng);
  http.Response response = await http.get(url);
  print(response.body);
  Map resp;
  resp = jsonDecode(response.body);
  print(resp);
  print("asdAEfsr");
  return resp;
}
