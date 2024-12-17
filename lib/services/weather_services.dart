import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_models.dart';

class WeatherServices {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherServices(this.apiKey);

  Future<Weather> getWeather(
    String cityName,
  ) async {
    final response = await http.get(
      Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'),
    );

    print('Detected City/Kecamatan: $cityName');
    print('Response: ${response.body}'); // Debugging respons

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      print('Error: ${response.statusCode}');
      throw Exception('Failed to get weather data');
    }
  }

  /// Mapping kecamatan ke nama kota
  Map<String, String> cityMapping = {};

 Future<Map<String, String>> getCurrentCity() async {
  // Dapatkan izin lokasi
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception("Location permission denied");
    }
  }

  // Dapatkan lokasi saat ini
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  // Ambil daftar placemark
  List<Placemark> placemark =
      await placemarkFromCoordinates(position.latitude, position.longitude);

  print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');

  // Nama asli kota dari koordinat
  String originalCity = placemark[0].locality ??
      '';

  print('Original City Name from Coordinates: $originalCity');

  // Final nama kota setelah normalisasi
  String city = originalCity.toLowerCase();

  // Periksa apakah nama yang terdeteksi adalah kecamatan
  if (city.startsWith("kecamatan")) {
    city = cityMapping[city] ?? "malang"; // Default ke Malang jika tidak ditemukan
    print('Mapped Kecamatan to City: $city');
  } else {
    // Normalisasi nama kota
    city = city
        .replaceFirst(RegExp(r'^kota\s+', caseSensitive: false), '')
        .replaceFirst(RegExp(r'^kabupaten\s+', caseSensitive: false), '')
        .replaceFirst(RegExp(r'^central\s+', caseSensitive: false), '')
        .replaceFirst(RegExp(r'\s*regency$', caseSensitive: false), '')
        .replaceFirst(RegExp(r'\s*city$', caseSensitive: false), '')
        .trim();
    print('Cleaned City Name: $city');
  }

  // Gunakan nama kota default jika kosong
  if (city.isEmpty) {
    city = "malang";
  }

  return {
    'originalCity': originalCity,
    'finalCity': city,
  };
}
}
