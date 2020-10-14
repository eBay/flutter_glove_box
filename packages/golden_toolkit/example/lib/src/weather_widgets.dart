/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************

// ignore_for_file: public_member_api_docs

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Don't look at this code as an example of good Flutter code. This code is a mess.
/// Thankfully, we have pixel perfect golden tests to protect us if we ever
/// refactor and clean it up!

class WeatherForecast extends StatelessWidget {
  const WeatherForecast({Key key, List<Forecast> list = thisWeek})
      : _list = list,
        super(key: key);

  final List<Forecast> _list;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          colors: [Colors.lightBlue, Colors.deepPurple],
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(),
          Column(
            children: [
              const SizedBox(height: 48),
              Text(
                'Today\'s Forecast',
                style: theme.textTheme.headline6,
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 100, maxWidth: 300),
                child: Theme(
                  data: theme.copyWith(
                    cardTheme: theme.cardTheme.copyWith(
                      color: Colors.black26,
                      shape: const CircleBorder(),
                    ),
                    textTheme: theme.textTheme.copyWith(
                      bodyText2: theme.textTheme.bodyText2.copyWith(fontSize: 24),
                    ),
                  ),
                  child: WeatherCard.forecast(today),
                ),
              ),
              const SizedBox(height: 8),
              Text(today.description),
            ],
          ),
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('This Week\'s Forecast', style: Theme.of(context).textTheme.headline6),
              if (MediaQuery.of(context).size.width > 400 && MediaQuery.of(context).size.height > 600)
                WeeklyForecastExpanded(forecasts: _list)
              else
                WeeklyForecastCompact(forecasts: _list),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class WeeklyForecastExpanded extends StatelessWidget {
  const WeeklyForecastExpanded({
    Key key,
    @required this.forecasts,
  }) : super(key: key);

  final List<Forecast> forecasts;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: forecasts
          .map((f) => Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Spacer(flex: 2),
                  Flexible(flex: 3, child: WeatherCard.forecast(f)),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 5,
                    child: Align(alignment: Alignment.centerLeft, child: Text(f.description)),
                  ),
                ],
              ))
          .toList(),
    );
  }
}

class WeeklyForecastCompact extends StatelessWidget {
  const WeeklyForecastCompact({
    Key key,
    @required this.forecasts,
  }) : super(key: key);

  final List<Forecast> forecasts;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: forecasts
              .map((f) => Container(
                    width: MediaQuery.of(context).size.width * .3,
                    child: WeatherCard.forecast(f),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class WeatherCard extends StatelessWidget {
  const WeatherCard({
    Key key,
    this.temp,
    this.weather,
    this.day = 'Friday',
  }) : super(key: key);

  factory WeatherCard.forecast(Forecast forecast) {
    return WeatherCard(
      temp: forecast.temp,
      weather: forecast.weather,
      day: forecast.day,
    );
  }

  final int temp;
  final Weather weather;
  final String day;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      ///example of different layout types based on device size / rotation
      if (constraints.maxWidth > 400) {
        return _horizontalCard(context);
      } else {
        return _verticalCard(context);
      }
    });
  }

  //if screen is large, we want this card to be horizontal as Row
  Widget _horizontalCard(BuildContext context) {
    final cardTheme = CardTheme.of(context);
    return Card(
      shape: cardTheme.shape ?? _cardShape,
      color: cardTheme.color ?? const Color.fromARGB(255, 36, 51, 66),
      elevation: cardTheme.elevation ?? 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
    final cardTheme = CardTheme.of(context);
    return Container(
      width: 180,
      child: Card(
        shape: cardTheme.shape ?? _cardShape,
        color: cardTheme.color ?? const Color.fromARGB(255, 36, 51, 66),
        elevation: cardTheme.elevation ?? 1,
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
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      );

  Text _day() => Text(day, style: const TextStyle(color: Colors.white));

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

final RoundedRectangleBorder _cardShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0));

class Forecast {
  const Forecast({this.day, this.temp, this.weather, this.description});

  final String day;
  final int temp;
  final Weather weather;
  final String description;
}

const Forecast today = Forecast(
  day: 'Friday',
  weather: Weather.sunny,
  temp: 90,
  description: 'Partly cloudy. High 90F. Winds W at 5 to 10 mph.',
);

const List<Forecast> thisWeek = [
  Forecast(
    weather: Weather.sunny,
    temp: 90,
    day: 'Saturday',
    description: 'Partly cloudy. High 90F. Winds W at 5 to 10 mph.',
  ),
  Forecast(
    weather: Weather.cloudy,
    temp: 75,
    day: 'Sunday',
    description: 'Partly cloudy. High 90F. Winds W at 5 to 10 mph.',
  ),
  Forecast(
    weather: Weather.cloudy,
    temp: 70,
    day: 'Monday',
    description: 'Partly cloudy. High 90F. Winds W at 5 to 10 mph.',
  ),
  Forecast(
    weather: Weather.rain,
    temp: 65,
    day: 'Tuesday',
    description: 'Partly cloudy. High 90F. Winds W at 5 to 10 mph.',
  ),
  Forecast(
    weather: Weather.cold,
    temp: 7,
    day: 'Wednesday',
    description: 'Partly cloudy. High 90F. Winds W at 5 to 10 mph.',
  ),
];
