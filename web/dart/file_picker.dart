import 'dart:html';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'panel.dart';
import 'websocket.dart';

void initFilePicker(ClientWebSocket ws) async {
  showpanel('#picturepanel');

  InputElement imgUpload = querySelector('#imgUpload') as InputElement;
  imgUpload.onInput.listen((event) {
    if (imgUpload.files!.isNotEmpty) {
      _loadFileAsImage(imgUpload.files![0]);
    }
  });

  querySelector('#uploadProfilePic')?.onClick.listen((event) async {
    hidepanel('#picturepanel');
    (querySelector('#preview') as ImageElement).removeAttribute('src');
    var base64 = await _imgToBase64(imgUpload.files![0]);
    processUpload(base64, ws);

    imgUpload.value = null;
  });
  querySelector('#closeButton')?.onClick.listen((event) {
    hidepanel('#picturepanel');
    (querySelector('#preview') as ImageElement).removeAttribute('src');
    imgUpload.value = null;
  });
}

void _loadFileAsImage(File img) {
  //print('src');
  (querySelector('#preview') as ImageElement).src =
      Url.createObjectUrlFromBlob(img);
}

Future<dynamic> _imgToBase64(Blob b) async {
  FileReader fr = FileReader()..readAsDataUrl(b);
  await fr.onLoadEnd.first;

  return fr.result as String;
}

processUpload(var base64, ClientWebSocket ws) {
  String un = querySelector('#account')?.text as String;
  ws.send('profile_picture; pic: ' + base64 + '; username: ' + un);
}
