import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather_models.dart';
import 'package:http/http.dart' as http;

class WeatherServices {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/forecast';
  final String apiKey;

  WeatherServices(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
       print(response.body);
       print('City Name: $cityName');
      throw Exception('failed to get weather data');
    }
  }

  Map<String, String> cityMapping = {
  "Kecamatan Dau": "Kota Malang",
  // Tambahkan pemetaan lainnya sesuai kebutuhan
};


  Future<String> getCurrentCity() async {
    //get permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //fetch teh current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //convert a location into a  list of placemark objects
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
        print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');

        // Ambil nama kota dari placemark
  String city = placemark[0].locality ?? placemark[0].subAdministrativeArea ?? '';

     // Gunakan pemetaan untuk mengganti nama kota jika diperlukan
  city = cityMapping[city] ?? city;

  // Gunakan nama kota default jika kosong
  if (city.isEmpty) {
    city = "Malang";
  }

  return city;
}
  }

