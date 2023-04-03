//Author : Anthony Da Cruz - 2023
import 'package:flutter/material.dart';
import 'package:flutter_nfc_sample/nfc_helpers/nfc_wrapper_view.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcWriteData extends StatefulWidget {
  NfcWriteData({Key? key}) : super(key: key);

  @override
  State<NfcWriteData> createState() => _KeycardCreateNfcState();
}

class _KeycardCreateNfcState extends State<NfcWriteData> {
  bool _isScanning = false;
  bool? _writeSuccess;
  bool? _validationSuccess = false;

  String _dataToWrite = "Coucou ! Je vais être écrit dans un Tag NFC :o!";

  late Future<String> _generatedKey;
  Future<bool?> _linkKeyToReservation = Future.value(false);

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Ecriture NFC')),
        body: ListView(
          children: [
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () => {
                setState(() {
                  _isScanning = true;
                  writeData(_dataToWrite);
                })
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[50],
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
                    child: Column(
                      children: [
                        Text("Va être écrit sur le tag: ${_dataToWrite}",
                            style: const TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                        NFCWrapperView(isScanning: _isScanning),
                        const SizedBox(height: 20),
                        const Text(
                            "Toucher l'icone NFC pour commencer l'écriture...",
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 20,
                                fontWeight: FontWeight.w900),
                            textAlign: TextAlign.center)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ));
  }

  Future<NfcTag?> scannedTag = Future.value(null);

  //Démarre la session d'écriture NFC
  void writeData(String keyCode) async {
    NfcManager.instance.startSession(onError: (error) async {
      print(error.details);
      print(error.message);
    }, onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        print('Tag is not writable');
        _isScanning = false;
        _writeSuccess = false;
        NfcManager.instance.stopSession();
        return;
      }

      NdefMessage message = NdefMessage(
        [NdefRecord.createText(keyCode)],
      );

      try {
        await ndef.write(message);
        print("successfuly write");
        NfcManager.instance.stopSession();
        setState(() {
          _writeSuccess = true;
          _isScanning = false;
        });
      } catch (e) {
        NfcManager.instance.stopSession(errorMessage: e.toString());
        setState(() {
          _writeSuccess = false;
          _isScanning = false;
        });
        print("error");
        return;
      }
    });
  }
}
