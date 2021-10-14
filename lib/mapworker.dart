import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:living_map/accountmanager.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MapImg {
  late String name;
  late String owner;
  late String src;

  MapImg(this.name, this.owner, this.src);

  Map toJson() {
    var r = {'name': name, 'owner': owner, 'src': src};
    return r;
  }
}

MapImg mapFromJson(Map mapImg) {
  MapImg r = MapImg(mapImg['name'], mapImg['owner'], mapImg['src']);
  return r;
}

List<MapImg> allMaps = get_maps();

void createMap(String name, String map, String user, WebSocketChannel wsc) {
  String src = saveMapImg(map);
  MapImg newMap = MapImg(name, user, src);
  wsc.sink.add('map_add; name: $name; src: $src');
  allMaps.add(newMap);
  saveMaps();
}

String saveMapImg(String map) {
  Uint8List bitlist = base64Decode(parseImage(map));
  Image img = decodeImage(bitlist) as Image;
  String newname = allMaps.length.toString();
  File('web/img/maps/$newname.png').writeAsBytesSync(encodePng(img));
  String r = 'img/maps/$newname.png';
  return r;
}

List<MapImg> get_maps() {
  List<MapImg> r = [];
  List<dynamic> st = [];

  File file = File('.data/map.json');
  String s = file.readAsStringSync();
  if (s.isNotEmpty) {
    st = jsonDecode(s);
  }

  for (int i = 0; i < st.length; i++) {
    MapImg u = mapFromJson(st[i]);
    r.add(u);
  }

  return r;
}

void saveMaps() {
  List<dynamic> st = [];
  for (int i = 0; i < allMaps.length; i++) {
    st.add(allMaps[i].toJson());
  }
  String s = jsonEncode(st);
  File file = File('.data/map.json');
  file.writeAsString(s);
}

void getMapsForUser(String username, WebSocketChannel wsc) {
  for (int i = 0; i < allMaps.length; i++) {
    if (allMaps[i].owner == username) {
      String name = allMaps[i].name;
      String src = allMaps[i].src;
      wsc.sink.add('map_add; name: $name; src: $src');
    }
  }
}
