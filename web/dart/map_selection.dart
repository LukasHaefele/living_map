import 'dart:html';

import 'actionhandler.dart';
import 'panel.dart';
import 'websocket.dart';

void initMapSelection(ClientWebSocket ws) {
  InputElement imgUpload = querySelector('#imgUploadMap') as InputElement;
  imgUpload.onInput.listen((event) {
    if (imgUpload.files!.isNotEmpty) {
      _loadMapAsImage(imgUpload.files![0]);
    }
  });

  querySelector('.mapSelection')?.style.display = 'flex';
  querySelector('#mapAdd')?.onClick.listen((event) {
    //print('mapUploadPanel');
    mapUploadPanel(ws, imgUpload);
  });
  String user = querySelector('#account')?.text as String;
  ws.send('map_get_all; username: $user');
}

void mapUploadPanel(ClientWebSocket ws, InputElement imgUpload) {
  showpanel('#mapUpload');

  querySelector('#uploadMap')?.onClick.listen((event) {
    uploadMap(ws, imgUpload);
  });
  querySelector('#closeButtonMap')?.onClick.listen((event) {
    hidepanel('#mapUpload');
    (querySelector('#mapPreview') as ImageElement).removeAttribute('src');
    imgUpload.value = null;
  });
}

void uploadMap(ClientWebSocket ws, InputElement imgUpload) async {
  hidepanel('#mapUpload');
  (querySelector('#mapPreview') as ImageElement).removeAttribute('src');
  var base64 = await _mapToBase64(imgUpload.files![0]);
  processUpload(base64, ws);

  imgUpload.value = null;
}

Future<dynamic> _mapToBase64(Blob b) async {
  FileReader fr = FileReader()..readAsDataUrl(b);
  await fr.onLoadEnd.first;

  return fr.result as String;
}

void _loadMapAsImage(File img) {
  //print('src');
  (querySelector('#mapPreview') as ImageElement).src =
      Url.createObjectUrlFromBlob(img);
}

processUpload(var base64, ClientWebSocket ws) {
  String un = querySelector('#account')?.text as String;
  String name = (querySelector('#mapName') as InputElement).value as String;
  if (name == '') {
    name = 'No Name Given';
  }
  ws.send('map_upload; pic: $base64; username: $un; name: $name');
}

void addMap(String name, String src, int id, ClientWebSocket ws) {
  querySelector('.mapSelection')?.append(getMapElement(name, src, id, ws));
}

ButtonElement getMapElement(
    String name, String src, int id, ClientWebSocket ws) {
  ButtonElement newDiv = ButtonElement();
  String ts = DateTime.now().microsecondsSinceEpoch.toString();
  newDiv
    ..classes.add('mapButton')
    ..id = 'name'
    ..style.backgroundImage = 'url($src?$ts)'
    ..text = name
    ..onClick.listen((event) {
      ws.send('map_select; id: $id');
    });
  remember['mapButton:$id'] = newDiv;
  return newDiv;
}
