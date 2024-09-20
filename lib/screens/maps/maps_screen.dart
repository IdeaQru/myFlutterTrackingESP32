import 'package:admin/controllers/udp_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart'; // Untuk format waktu

class MapsScreen extends StatefulWidget {
  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  UdpService _udpService = UdpService(); // Instance UDP Service
  LatLng _currentPosition = LatLng(-7.2756, 112.7976); // Lokasi awal (PPNS)

  @override
  void initState() {
    super.initState();
    _udpService.startListening();
    _udpService.onDataReceived.listen((data) {
      _updatePosition(data);
    });
  }

  // Mendapatkan waktu sekarang
  String getCurrentTime() {
    return DateFormat('HH:mm:ss').format(DateTime.now());
  }

  // Update posisi marker berdasarkan data yang diterima
  void _updatePosition(String data) {
     print("Received data: $data");
    List<String> latLng = data.split(",");
    if (latLng.length == 2) {
      double lat = double.parse(latLng[0]);
      double lng = double.parse(latLng[1]);

      setState(() {
        _currentPosition = LatLng(lat, lng); // Update posisi marker
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Maps with Real-Time Data"),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _currentPosition, // Gunakan posisi yang diperbarui
          initialZoom: 15.0, // Zoom level untuk peta
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _currentPosition, // Update posisi marker di sini
                width: 150.0,
                height: 100.0, // Menambah ketinggian untuk tempat teks
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Blok teks di atas marker
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 5.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Lokasi Anda Terkini',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Pukul: ${getCurrentTime()}',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5), // Jarak antara teks dan marker
                        // Marker ikon di bawah teks
                        Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40.0,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _udpService.dispose();
    super.dispose();
  }
}
