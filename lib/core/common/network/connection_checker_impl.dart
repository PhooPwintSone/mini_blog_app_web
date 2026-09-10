import 'package:blog_app/core/common/network/connection_checker.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectionCheckerImpl implements ConnectionChecker {
  final InternetConnection _connection;

  ConnectionCheckerImpl({required this._connection});

  @override
  Future<bool> get isConnected async => await _connection.hasInternetAccess;
}
