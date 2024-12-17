class Weather {
  final String cityName;
  final double temperature;
  final String mainConditions;
  final String description;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainConditions,
    required this.description,
  });

  // Parsing JSON dari API OpenWeatherMap
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? 'Unknown City', // Nama kota dari 'name'
      temperature: json['main']['temp']?.toDouble() ?? 0.0, // Suhu dari 'main.temp'
      mainConditions: json['weather'][0]['main'] ?? 'Unknown', // Kondisi cuaca
      description: json['weather'][0]['description'] ?? 'No description', // Deskripsi cuaca
    );
  }
}
