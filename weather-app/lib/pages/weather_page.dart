import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:main/models/weather_model.dart';
import 'package:main/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherService = WeatherService('9b2f7b75f0d94919a492ec0794edf2ea');
  Weather? _weather;

  //mengambil cuaca
  _fetchWeather() async {
    //mengambil kota saat ini
    String cityName = await _weatherService.getCurrentCity();

    //mengambil cuata untuk kota
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    //kalo ada error
    catch (e) {
      print(e);
    }
  }

  //animasi cuaca
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/cerah.json'; //default

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/mendung.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/hujan.json';
      case 'thunderstorm':
        return 'assets/petir.json';
      case 'clear':
        return 'assets/cerah.json';
      default:
        return 'assets/cerah.json';
    }
  }

  //init state
  @override
  void initState() {
    super.initState();

    //mengambil cuaca mulai dari atas
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //nama kota
            Text(
              _weather?.cityName ?? "Memuat Kota...",
              style: TextStyle(fontSize: 30.0, height: 7),
            ),

            //animasi
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            //temperatur
            Text(
              '${_weather?.temperature.round()}°C',
              style: TextStyle(
                  fontSize: 30.0, fontWeight: FontWeight.bold, height: 5),
            ),
          ],
        ),
      ),
    );
  }
}
