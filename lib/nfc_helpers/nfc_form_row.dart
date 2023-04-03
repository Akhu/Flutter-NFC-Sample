import 'package:flutter/cupertino.dart';

/* 
Standard NFC line description for a single record, used to display the record in the UI.
*/
class FormRow extends StatelessWidget {
  const FormRow({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final Text title;
  final Text value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        title,
        value,
      ],
    );
  }
}

String getNdefType(String code) {
  switch (code) {
    case 'org.nfcforum.ndef.type1':
      return 'NFC Forum Tag Type 1';
    case 'org.nfcforum.ndef.type2':
      return 'NFC Forum Tag Type 2';
    case 'org.nfcforum.ndef.type3':
      return 'NFC Forum Tag Type 3';
    case 'org.nfcforum.ndef.type4':
      return 'NFC Forum Tag Type 4';
    default:
      return 'Unknown';
  }
}
