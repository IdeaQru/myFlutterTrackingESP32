import 'dart:async';
import 'dart:io';

class UdpService {
  RawDatagramSocket? _udpSocket;
  StreamController<String> _dataStreamController = StreamController<String>();

  Stream<String> get onDataReceived => _dataStreamController.stream;

  Future<void> startListening() async {
    _udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 12345);
    _udpSocket!.listen((RawSocketEvent event) {
      if (event == RawSocketEvent.read) {
        Datagram? dg = _udpSocket!.receive();
        if (dg != null) {
          String message = String.fromCharCodes(dg.data);
          _dataStreamController.add(message); // Mengirim data ke stream
        }
      }
    });
  }

  void dispose() {
    _udpSocket?.close();
    _dataStreamController.close();
  }
}
