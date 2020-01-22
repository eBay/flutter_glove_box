/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final RoundedRectangleBorder _cardShape =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0));

class WeatherCard extends StatelessWidget {
  const WeatherCard({Key key, this.temp, this.weather}) : super(key: key);
  final int temp;
  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(builder: (context, constraints) {
        ///example of different layout types based on device size / rotation
        if (constraints.maxWidth > 600) {
          return _horizontalCard(context);
        } else {
          return _verticalCard(context);
        }
      }),
    );
  }

  //if screen is large, we want this card to be horizontal as Row
  Widget _horizontalCard(BuildContext context) {
    return Card(
      shape: _cardShape,
      color: const Color.fromARGB(255, 36, 51, 66),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 8),
            _day(),
            const SizedBox(width: 8),
            _image(),
            const SizedBox(width: 8),
            _description(),
            const SizedBox(width: 8),
            _temperature(),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  //if screen is small, we want this card to be vertical as Column
  Widget _verticalCard(BuildContext context) {
    return Container(
      width: 180,
      child: Card(
        shape: _cardShape,
        color: const Color.fromARGB(255, 36, 51, 66),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              _day(),
              const SizedBox(height: 8),
              _image(),
              _description(),
              _temperature(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Text _temperature() => Text(
        '$temp°F',
        style: TextStyle(color: temp > 33 ? Colors.red : Colors.blue),
      );

  Text _description() => Text(
        _textForWeather(weather),
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      );

  Text _day() => Text('Friday', style: TextStyle(color: Colors.white));

  Image _image() => Image.asset(
        'images/${_assetForWeather(weather)}',
        color: Colors.white,
        width: 40,
        height: 40,
      );
}

String _assetForWeather(Weather weather) {
  switch (weather) {
    case Weather.sunny:
      return 'sample_sunny.png';
    case Weather.rain:
      return 'sample_rain.png';
      break;
    case Weather.cold:
      return 'sample_cold.png';
      break;
    case Weather.cloudy:
      return 'sample_cloudy.png';
      break;
  }
  return '';
}

String _textForWeather(Weather weather) {
  switch (weather) {
    case Weather.sunny:
      return 'Sunny';
    case Weather.rain:
      return 'Raining';
      break;
    case Weather.cold:
      return 'Frosty';
      break;
    case Weather.cloudy:
      return 'Partly Cloudy';
      break;
  }
  return '';
}

enum Weather {
  sunny,
  rain,
  cold,
  cloudy,
}
