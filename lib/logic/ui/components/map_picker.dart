import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPicker extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;

  const MapPicker({super.key, this.initialLatitude, this.initialLongitude});

  @override
  State<MapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  late LatLng selectedLocation;

  @override
  void initState() {
    super.initState();

    selectedLocation = LatLng(
      widget.initialLatitude ?? -7.7956,
      widget.initialLongitude ?? 110.3695,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pilih Lokasi")),

      body: FlutterMap(
        options: MapOptions(
          initialCenter: selectedLocation,
          initialZoom: 15,
          onTap: (tapPosition, point) {
            setState(() {
              selectedLocation = point;
            });
          },
        ),

        children: [
          TileLayer(
            urlTemplate:
                'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c', 'd'],
            userAgentPackageName: 'com.booking_villa.app',
          ),

          MarkerLayer(
            markers: [
              Marker(
                point: selectedLocation,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),

        onPressed: () {
          Navigator.pop(context, {
            'latitude': selectedLocation.latitude,
            'longitude': selectedLocation.longitude,
          });
        },
      ),
    );
  }
}
