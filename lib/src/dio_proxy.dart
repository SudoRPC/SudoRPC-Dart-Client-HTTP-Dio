import 'package:dio/dio.dart';
import 'package:sudorpc/sudorpc.dart';
import 'package:sudorpc_client_http_dio/sudorpc_client_http_dio.dart';

class SudoRPCDioHTTPProxy implements SudoRPCCallProxy {
  final String endpoint;

  final BaseOptions? baseOptions;
  final List<InterceptorsWrapper>? interceptors;

  final Map<String, SudoRPCCallProxyCallback> _listeners = {};

  SudoRPCDioHTTPProxy({
    required this.endpoint,
    this.baseOptions,
    this.interceptors,
  });

  @override
  void addListener(
    String listenerIdentifier,
    SudoRPCCallProxyCallback callback,
  ) {
    _listeners[listenerIdentifier] = callback;
  }

  @override
  void removeListener(
    String listenerIdentifier,
  ) {
    _listeners.remove(listenerIdentifier);
  }

  @override
  void send(
    SudoRPCCall call,
  ) {
    final Dio dio = getSudoRPCDio(
      baseOptions: baseOptions,
      interceptors: interceptors,
    );

    dio.post(endpoint, data: call.toJson()).then(
      (Response<dynamic> response) {
        for (final listener in _listeners.values) {
          listener(createSudoRPCReturnFromJson(response.data));
        }
      },
    ).catchError(
      (dynamic error) {
        if (call is! SudoRPCCallV1) {
          throw Exception('SudoRPCDioHTTPProxy only supports SudoRPCCallV1');
        }

        final SudoRPCReturnV1FailErrorItem errorItem =
            SudoRPCReturnV1FailErrorItem(
          error: 'Dio Error',
          message: error.toString(),
          result: error,
        );

        final SudoRPCReturn errorReturn = SudoRPCReturnV1Fail(
          identifier: call.identifier,
          errors: [errorItem],
        );

        for (final listener in _listeners.values) {
          listener(errorReturn);
        }
      },
    );
  }
}
