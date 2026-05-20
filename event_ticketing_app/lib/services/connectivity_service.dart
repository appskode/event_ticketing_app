import 'package:connectivity_plus/connectivity_plus.dart';

/// Observes device network reachability (Wi‑Fi / mobile / ethernet).
class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Stream<bool> get onlineStream async* {
    yield await isOnline;
    await for (final results in _connectivity.onConnectivityChanged) {
      yield _hasConnection(results);
    }
  }

  Future<bool> get isOnline async {
    final results = await _connectivity.checkConnectivity();
    return _hasConnection(results);
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((r) => r != ConnectivityResult.none);
  }
}
