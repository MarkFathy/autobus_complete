import 'network_request.dart';

abstract interface class NetworkService {
  Future<Model> callApi<Model>(NetworkRequest networkRequest);

  void setToken(String token);

  void removeToken();
}
