import 'dart:convert';
import 'dart:math';
import 'package:crypto_tracker/pages/crypto_detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List cryptoCurrencies = [];
  List<Color> colors = [];

  Color getRandomColor() {
    Color color = Color.fromRGBO(
      Random().nextInt(256),
      Random().nextInt(256),
      Random().nextInt(256),
      1,
    );
    colors.add(color);
    return color;
  }

  Future<List> _getCryptoCurrencies() async {
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
    print(data['data']);
    cryptoCurrencies = data['data'];
    return data['data'];
  }

  @override
  void initState() {
    super.initState();
    _getCryptoCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Crypto Tracker"),
      ),
      body: FutureBuilder(
        future: _getCryptoCurrencies(),
        builder: (context, AsyncSnapshot<List> dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.done) {
            cryptoCurrencies = dataSnapshot.data!;
            return RefreshIndicator(
              onRefresh: () {
                return _getCryptoCurrencies();
              },
              child: ListView.builder(
                itemCount: cryptoCurrencies.length,
                itemBuilder: (BuildContext context, int index) {
                  return _currencyWidget(cryptoCurrencies[index], index);
                },
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _currencyWidget(dynamic crypto, int index) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CryptoDetail(crypto: crypto),
            ),
          );
        },
        leading: CircleAvatar(
          child: Text(
            "${crypto['name'][0]}",
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.white,
            ),
          ),
          backgroundColor:
              (colors.length == index) ? getRandomColor() : colors[index],
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                crypto['name'],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.00,
                ),
              ),
            ),
            _getPriceText(
              crypto,
            )
          ],
        ),
      ),
    );
  }

  Widget _getPriceText(dynamic crypto) {
    double price = crypto['quote']['USD']['price'];
    double percentageChange1Hour = crypto['quote']['USD']['percent_change_24h'];

    Text priceText = Text(
      "\$${price.toStringAsFixed(2)}",
      style: new TextStyle(
        color: Colors.black,
      ),
    );

    Text percentageChangeText = Text(
      "${percentageChange1Hour.toStringAsFixed(2)} %",
      style: new TextStyle(
        color: (percentageChange1Hour > 0) ? Colors.green : Colors.red,
      ),
    );

    Icon percentageChangeIcon = ((percentageChange1Hour > 0)
        ? Icon(
            Icons.arrow_upward_sharp,
            color: Colors.green,
          )
        : Icon(
            Icons.arrow_downward_sharp,
            color: Colors.red,
          ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        priceText,
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            percentageChangeText,
            percentageChangeIcon,
          ],
        )
      ],
    );
  }
}
