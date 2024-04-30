import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat data cuaca');
    }
  }

  Future<String> getCurrentCity() async {
    //mendapatkan izin dari pengguna
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //mengambil lokasi saat ini
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //mengonversi lokasi menjadi daftar objek penanda letak
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    //mengekstrak nama kota dari tanda letak pertama
    String? city = placemarks[0].locality;

    return city ?? "";
  }
}
