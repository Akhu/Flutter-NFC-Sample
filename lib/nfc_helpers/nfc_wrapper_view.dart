import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NFCWrapperView extends StatelessWidget {
  const NFCWrapperView({
    super.key,
    required bool isScanning,
  }) : _isScanning = isScanning;

  final bool _isScanning;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 250.0,
        height: 250.0,
        decoration: BoxDecoration(
          color: _isScanning ? Colors.green[100] : Colors.amber[100],
          shape: BoxShape.circle,
        ),
        child: Center(
            child: Icon(
          CupertinoIcons.radiowaves_right,
          size: 100,
          color: _isScanning ? Colors.green[400] : Colors.amber[400],
        )));
  }
}
