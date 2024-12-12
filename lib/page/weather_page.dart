import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_models.dart';
import 'package:weather_app/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api Key
  final _WeatherService = WeatherServices('59da7edd1618df6f5264ca204591d02a');
  Weather? _weather;

  //fetch weather
  _fetchweather() async {
    //get the currernt city
    String cityName = await _WeatherService.getCurrentCity();
    if (cityName.isEmpty) {
    cityName = "Malang"; // Menggunakan nama kota yang lebih umum
  }
    cityName = cityName.trim();
    cityName = cityName.toLowerCase().trim();

    //get weather for city
    try {
      final weather = await _WeatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    //any error
    catch (e) {
  setState(() {
    _weather = null;
  });
  print("Error: $e");
}
  }

  //weather animation

  //init state
  void initState() {
    super.initState();

    //fetch weather on startup
    _fetchweather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            Text(_weather?.cityName ?? "loading city.."),
        
            //temperature
            Text('${_weather?.temperature.round()}°C'),
          ],
        ),
      ),
    );
  }
}
