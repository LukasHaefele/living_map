import 'dart:io';

import 'package:living_map/accountmanager.dart';
import 'package:living_map/user.dart';
import 'package:living_map/websockethandler.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/echo/<message>', _echoHandler);

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Future<Response> _echoHandler(Request request) async {
  if (request.url.path == 'ws') {
    return await webSocketHandler(onConnect)(request);
  }

  final message = request.params /*params(request, 'message')*/;
  return Response.ok('$message\n');
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final _handler =
      Pipeline().addMiddleware(logRequests()).addHandler(_echoHandler);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '7070');
  final server = await serve(_handler, ip, port);
  print('Server listening on port ${server.port}');
  //print(allUsers);
}
