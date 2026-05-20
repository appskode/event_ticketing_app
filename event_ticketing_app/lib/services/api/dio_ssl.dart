import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

/// Trusts local dev TLS for **all** `dart:io` HTTP clients (not only Dio).
///
/// [CachedNetworkImage], `Image.network`, and `precacheImage` use their own
/// [HttpClient] and do **not** go through [configureDioSsl]. Without this,
/// `image_url` values pointing at `https://127.0.0.1:8000/...` with a
/// self-signed dev certificate stay on the loading placeholder forever (TLS
/// fails while the widget keeps waiting).
///
/// Call once at startup, before [runApp]. Debug builds only.
void installDebugHttpOverrides() {
  if (kIsWeb || !kDebugMode) {
    return;
  }
  HttpOverrides.global = _DebugDevHttpOverrides();
}

final class _DebugDevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }
}

/// Trusts local dev TLS (e.g. Caddy `tls internal`) in debug builds only.
void configureDioSsl(Dio dio) {
  if (kIsWeb) {
    return;
  }

  dio.httpClientAdapter = IOHttpClientAdapter(
    createHttpClient: () {
      final client = HttpClient();
      if (kDebugMode) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      }
      return client;
    },
  );
}
