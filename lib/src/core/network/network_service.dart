import 'package:autobus_complete/src/core/network/network_request.dart';

abstract interface class NetworkService {
  Future<Model> callApi<Model>(NetworkRequest<dynamic> networkRequest);

  void setToken(String token);

  void removeToken();
}
