import 'package:bitirme_projesi/repository/database_repository.dart';
import 'package:bitirme_projesi/service/firebase/firebase_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

setupLocator() {
  locator.registerLazySingleton(() => DatabaseRepository());
  locator.registerLazySingleton(() => FirebaseDatabaseService());
}
