import 'dart:convert';
import 'package:crypto_tracker/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() async {
  runApp(MyApp(
    cryptoCurrencies: await _getCryptoCurrencies(),
  ));
}

class MyApp extends StatelessWidget {
  final List cryptoCurrencies;

  const MyApp({Key? key, required this.cryptoCurrencies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(cryptoCurrencies: cryptoCurrencies),
    );
  }
}

Future<List<dynamic>> _getCryptoCurrencies() async {
  String url =
      'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?start=1&limit=50&convert=USD';
  http.Response response = await http.get(
    Uri.parse(url),
    headers: {
      'X-CMC_PRO_API_KEY': '12c9037d-563b-45d9-8510-a675eaf357e9',
      "Accept": "application/json",
    },
  );
  var data = jsonDecode(response.body);
  return data['data'];
}
