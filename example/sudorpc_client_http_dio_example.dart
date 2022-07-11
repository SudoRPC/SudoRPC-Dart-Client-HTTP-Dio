import 'package:sudorpc/sudorpc.dart';
import 'package:sudorpc_client_http_dio/src/dio_proxy.dart';

void main() {
  final SudoRPCCallManager dioManager = SudoRPCCallManager(
    proxy: SudoRPCDioHTTPProxy(
      endpoint: "https://example.com/sudorpc",
    ),
  );

  dioManager.ignite();

  dioManager.makeCall(
    resource: "echo",
  );

  dioManager.dialDown();
}
