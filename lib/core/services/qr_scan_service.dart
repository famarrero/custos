import 'dart:async';

import 'package:custos/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

abstract class QRScanService {
  /// Abre la cámara y devuelve el contenido del QR escaneado
  Future<String?> scanQRCode();
}

class QRScanServiceImpl implements QRScanService {
  QRScanServiceImpl();

  @override
  Future<String?> scanQRCode() async {
    final completer = Completer<String?>();
    final navigator = rootNavigatorKey.currentState;

    final controller = MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates, facing: CameraFacing.back);

    // Widget de escaneo
    final scanner = MobileScanner(
      controller: controller,
      onDetect: (capture) {
        final barcode = capture.barcodes.firstOrNull;
        final value = barcode?.rawValue;

        if (value != null && !completer.isCompleted) {
          completer.complete(value);
          controller.dispose();
          // Cerrar la pantalla de escaneo
          navigator?.pop();
        }
      },
    );

    // Mostramos el scanner en un dialog / route
    await navigator?.push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => Scaffold(appBar: AppBar(title: const Text('Scan QR')), body: scanner),
      ),
    );

    return completer.future;
  }
}
