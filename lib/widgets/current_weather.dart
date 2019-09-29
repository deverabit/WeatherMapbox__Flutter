import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

import 'package:weather_card/.env.dart';
import 'package:weather_card/helpers/ui_helper.dart';
import 'package:weather_card/services/current_weather_service.dart';
import 'package:weather_card/services/location_service.dart';
import 'package:weather_card/services/settings_service.dart';

class CurrentWeather extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Map(),
        Container(
          color: Color.fromARGB(50, 45, 55, 72),
        ),
        CurrentWeatherInfo(),
      ],
    );
  }
}

class Map extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocationService>(
      builder: (context, locationService, child) {
        final position = locationService.position;

        return FlutterMap(
          options: MapOptions(
            center: LatLng(position.latitude, position.longitude),
            zoom: 13.0,
          ),
          layers: [
            new TileLayerOptions(
              urlTemplate:
                  "https://api.mapbox.com/styles/v1/t800t8/ck0hxusqi12if1cpdj034jsw6/tiles/256/{z}/{x}/{y}@2x?access_token=${Configuration.MapBoxApiKey}",
              additionalOptions: {
                'accessToken': Configuration.MapBoxApiKey,
                'id': 'mapbox.streets',
              },
            ),
            new MarkerLayerOptions(
              markers: [
                new Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(position.latitude, position.longitude),
                  builder: (ctx) => new Container(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class CurrentWeatherInfo extends StatelessWidget {
  const CurrentWeatherInfo();

  @override
  Widget build(BuildContext context) {
    return Consumer2<CurrentWeatherService, SettingsService>(
      builder: (context, currentWeatherService, settingsService, child) {
        final currentWeather = currentWeatherService.value;

        return Container(
          padding: EdgeInsets.only(
            left: 16,
            top: 16,
            bottom: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    DateFormat('EEEEE').format(currentWeather.date),
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('dd MMM yyyy').format(currentWeather.date),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      //color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_on),
                      Text(
                        currentWeather.location,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    UiHelper.getIconData(currentWeather.icon),
                    size: 70,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${currentWeather.temprature}°${settingsService.value.unit == 'metric' ? 'C' : 'F'}',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      //color: Colors.white,
                    ),
                  ),
                  Text(
                    currentWeather.description,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      //color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
