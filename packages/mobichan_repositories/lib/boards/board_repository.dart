library mobichan_repository;

import 'package:mobichan_datasources/boards/datasources/board_local_datasource.dart';
import 'package:mobichan_datasources/boards/datasources/board_remote_datasource.dart';

class MobichanRepository {
  MobichanRepository({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  final BoardRemoteDatasource remoteDatasource;
  final BoardLocalDatasource localDatasource;
}
