import 'package:flutter/material.dart';
import 'package:flutter_nfc_sample/nfc_helpers/ndef_records.dart';
import 'package:flutter_nfc_sample/nfc_helpers/nfc_form_row.dart';
import 'package:flutter_nfc_sample/nfc_helpers/nfc_wrapper_view.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcReadData extends StatefulWidget {
  NfcReadData({Key? key}) : super(key: key);

  @override
  State<NfcReadData> createState() => _NfcReadDataState();
}

class _NfcReadDataState extends State<NfcReadData> {
  Future<NfcTag?> _scannedTag = Future.value(null);
  bool _isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          GestureDetector(
              onTap: () => {
                    setState(() {
                      _isScanning = true;
                      getNfcData();
                    })
                  },
              child: NFCWrapperView(isScanning: _isScanning)),
          FutureBuilder(
            future: _scannedTag,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: readNdef(snapshot.data),
                );
              } else {
                return const Text('No data');
              }
            },
          ),
        ],
      ),
    );
  }

  List<Widget> readNdef(NfcTag tag) {
    //Lister les données du tag
    List<Widget> ndefWidgets = [];

    var tech = Ndef.from(tag);
    if (tech is Ndef) {
      final cachedMessage = tech.cachedMessage;
      final canMakeReadOnly = tech.additionalData['canMakeReadOnly'] as bool?;
      final type = tech.additionalData['type'] as String?;
      if (type != null) {
        ndefWidgets.add(ListTile(
            title: const Text('HOHOHO'), subtitle: Text(getNdefType(type))));
      }

      ndefWidgets.add(ListTile(
          title: const Text('Size'),
          subtitle: Text(
              '${cachedMessage?.byteLength ?? 0} / ${tech.maxSize} bytes')));

      ndefWidgets.add(ListTile(
          title: Text('Writable'), subtitle: Text('${tech.isWritable}')));

      if (canMakeReadOnly != null) {
        ndefWidgets.add(ListTile(
            title: const Text('Can Make Read Only'),
            subtitle: Text('$canMakeReadOnly')));
      }

      if (cachedMessage != null) {
        Iterable.generate(cachedMessage.records.length).forEach((i) {
          final record = cachedMessage.records[i];
          final info = NdefRecordInfo.fromNdef(record);
          ndefWidgets.add(ListTile(
              title: Text('#$i ${info.title}'),
              subtitle: Text('${info.subtitle}')));
        });
      }
      return ndefWidgets;
    } else {
      return [Text('No NDEF data found')];
    }
  }

  //Démarre la session de lecture NFC
  void getNfcData() async {
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (isAvailable) {
      await NfcManager.instance.startSession(onError: (error) async {
        print(error);
        _scannedTag = Future.error(error);
      }, onDiscovered: (NfcTag tag) async {
        setState(() {
          _scannedTag = Future.value(tag);
          _isScanning = false;
        });
        NfcManager.instance.stopSession();
      });
    }
  }
}
