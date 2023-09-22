// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, unused_element

import 'package:flutter/material.dart';
import 'style.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


void main() {
  runApp(WheaterApp());
}

class WheaterApp extends StatelessWidget {

  Future<Map<String, dynamic>?> loadWeatherData() async {
    var queryParams = {
      "key": "949480b031fb4d2196e185234232209",
      "q": "-20.8,-49.38",
    };
    var url = Uri.https('api.weatherapi.com', '/v1/forecast.json', queryParams);
    var response = await http.get(url);

    print(response.statusCode);
    if(response.statusCode == 200) {
      var json = convert.jsonDecode(response.body) as Map<String, dynamic>;
      return json;
    }
  }

  @override
  Widget build(BuildContext context) {
    loadWeatherData();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF255AF4),
        body: FutureBuilder<Map<String, dynamic>?>(
          future: loadWeatherData(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            var dados = snapshot.data;
            var forecastday = dados['forecast']['forecastday'][0]['hour'] as List<dynamic>;
            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("São José do Rio Preto", style: titleStyle),
                  Column(
                    children: [
                      Container(
                        child: Image.asset('images/01_sunny_color.png'),
                        width: 96,
                        height: 96,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
                      ),
                      Text(dados!['current']['condition']['text'], style: titleStyle),
                      Text("${dados['current']['temp_c']}°C", style: temperatureStyle),
                    ],
                  ),
                  Container(
                    // margin: EdgeInsets.only(top: 71),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Image.asset('images/humidity.png'),
                            Text("Humidity", style: iconStyle),
                            Text("52%", style: iconStyle),
                          ],
                        ),
                        Column(
                          children: [
                            Image.asset('images/wind.png'),
                            Text("Wind", style: iconStyle),
                            Text("${dados['current']['wind_kph']}Km/h", style: iconStyle),
                          ],
                        ),
                        Column(
                          children: [
                            Image.asset('images/feels_like.png'),
                            Text("Feels Like", style: iconStyle),
                            Text("${dados['current']['fellslike']}Km/h", style: iconStyle),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 100,
                    // margin: EdgeInsets.only(top: 80),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: forecastday.map((item) => ForecastDay(item['time_epoch'], 'chuva', item['temp_c'])).toList()
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}

class ForecastDay extends StatelessWidget {
  int timeEpoch;
  String image;
  double temperature;
  String? hour;

  ForecastDay(this.timeEpoch, this.image, this.temperature) {
    var data = DateTime.fromMillisecondsSinceEpoch(timeEpoch);
    hour = data.hour.toString();
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 39),
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hour, style: hourStyle),
          Image.asset('images/$image.png', width: 36, height: 36),
          Text("$temperature°", style: hourTemperatureStyle)
        ],
      ),
    );
  }
}
