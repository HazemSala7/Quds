import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/foundation.dart'; // For describeEnum

class BarcodeScannerScreen extends StatefulWidget {
  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Barcode'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      'Barcode Type: ${describeEnum(result!.format)}\nData: ${result!.code}',
                      textAlign: TextAlign.center,
                    )
                  : Text('Place a barcode inside the viewfinder'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (result != null) {
                Navigator.pop(context, result!.code);
              } else {
                // Show a message if no barcode was scanned
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('No barcode scanned yet!')),
                );
              }
            },
            child: Text('Done'),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      // Automatically pop the screen and return the barcode
      if (result != null) {
        Navigator.pop(context, result!.code);
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
