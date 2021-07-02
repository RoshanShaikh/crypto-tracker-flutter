import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CryptoDetail extends StatefulWidget {
  final dynamic crypto;
  const CryptoDetail({
    Key? key,
    required this.crypto,
  }) : super(key: key);

  @override
  _CryptoDetailState createState() => _CryptoDetailState(crypto);
}

class _CryptoDetailState extends State<CryptoDetail> {
  final dynamic crypto;

  _CryptoDetailState(this.crypto);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(crypto['name']),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: Colors.blue[900],
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: Text(
                crypto['symbol'],
                style: TextStyle(
                  fontSize: 50.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(child: _getPriceText(crypto)),
                ],
              ),
            ),
            Divider(
              color: Colors.black,
              thickness: 1.0,
            ),
            _getDetails(),
          ],
        ),
      ),
    );
  }

  Widget _getDetails() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _marketCapText(),
          _changesTexts(),
        ],
      ),
    );
  }

  Widget _getPercentageChnage(double percentageChange, String text) {
    Icon percentageChangeIcon = ((percentageChange > 0)
        ? Icon(
            Icons.arrow_upward_sharp,
            color: Colors.green,
            size: 30.0,
          )
        : Icon(
            Icons.arrow_downward_sharp,
            color: Colors.red,
            size: 30.0,
          ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Colors.blue[900],
            fontSize: 18.0,
          ),
        ),
        SizedBox(
          height: 2.0,
        ),
        Row(
          children: [
            Text(
              "${percentageChange.toStringAsFixed(2)} %",
              style: new TextStyle(
                color: (percentageChange > 0) ? Colors.green : Colors.red,
                fontSize: 30.0,
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            percentageChangeIcon,
          ],
        )
      ],
    );
  }

  Widget _changesTexts() {
    double percentageChange1Hour = crypto['quote']['USD']['percent_change_1h'];
    double percentageChange24Hour =
        crypto['quote']['USD']['percent_change_24h'];
    double percentageChange7Days = crypto['quote']['USD']['percent_change_1h'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _getPercentageChnage(percentageChange1Hour, "1 Hour Change"),
            SizedBox(height: 12.0),
            _getPercentageChnage(percentageChange24Hour, "24 Hours Change"),
            SizedBox(height: 12.0),
            _getPercentageChnage(percentageChange7Days, "7 Days Change"),
          ],
        ),
      ),
    );
  }

  Widget _marketCapText() {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Current Market Cap",
              style: TextStyle(
                color: Colors.blue[900],
                fontSize: 18.0,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              "\$ ${NumberFormat.compactLong(locale: "en_US").format(crypto['quote']['USD']['market_cap'])}",
              style: TextStyle(
                color: Colors.blue[900],
                fontSize: 30.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getPriceText(dynamic crypto) {
    double price = crypto['quote']['USD']['price'];
    double percentageChange24Hour =
        crypto['quote']['USD']['percent_change_24h'];

    Column priceText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Current Price",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          "\$ ${price.toStringAsFixed(2)}",
          style: new TextStyle(color: Colors.white, fontSize: 30.0),
        )
      ],
    );

    Icon percentageChangeIcon = ((percentageChange24Hour > 0)
        ? Icon(
            Icons.arrow_upward_sharp,
            color: Colors.green,
          )
        : Icon(
            Icons.arrow_downward_sharp,
            color: Colors.red,
          ));

    Column percentageChange = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "Change in last 24 hours",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Row(
          children: [
            Text(
              "${percentageChange24Hour.toStringAsFixed(2)} %",
              style: new TextStyle(
                color: (percentageChange24Hour > 0) ? Colors.green : Colors.red,
                fontSize: 30.0,
              ),
            ),
            percentageChangeIcon,
          ],
        )
      ],
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        priceText,
        percentageChange,
      ],
    );
  }
}
