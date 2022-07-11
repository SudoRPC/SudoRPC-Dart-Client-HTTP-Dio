import 'package:dio/dio.dart';

Dio getSudoRPCDio({
  BaseOptions? baseOptions,
  List<InterceptorsWrapper>? interceptors,
}) {
  final BaseOptions fixedBaseOptions = baseOptions ?? BaseOptions();
  final List<InterceptorsWrapper> fixedInterceptors =
      interceptors ?? <InterceptorsWrapper>[];

  final Dio dio = Dio(fixedBaseOptions);

  for (var interceptor in fixedInterceptors) {
    dio.interceptors.add(interceptor);
  }

  return dio;
}
