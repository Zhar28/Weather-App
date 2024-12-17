import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_models.dart';
import 'package:weather_app/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherServices('59da7edd1618df6f5264ca204591d02a');
  Weather? _weather;
  String? _originalCity;
  bool _isLoading = true; // Tambahkan loading state
  String? _errorMessage; // Tambahkan error message

  Future<void> _fetchWeather() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Ambil data kota
      final cityData = await _weatherService.getCurrentCity();
      final detectedCity = cityData['originalCity'] ?? 'Unknown';
      final normalizedCity = cityData['finalCity'] ?? 'DefaultCity';

      // Fetch data cuaca
      final weather = await _weatherService.getWeather(normalizedCity);
      setState(() {
        _originalCity = detectedCity;
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Failed to fetch weather data: $e";
      });
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/cloud.json';
      case 'rain':
        return 'assets/rain.json';
      case 'drizzle':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Text(_errorMessage!),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_originalCity ?? 'Unknown City',
                style: const TextStyle(fontSize: 24)),
            Lottie.asset(getWeatherAnimation(_weather?.mainConditions)),
            Text('${_weather?.temperature.round()}°C',
                style: const TextStyle(fontSize: 48)),
            Text(_weather?.mainConditions ?? '',
                style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
