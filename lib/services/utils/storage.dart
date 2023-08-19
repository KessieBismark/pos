import 'package:get_storage/get_storage.dart';

class Storage {
    bool isLogged = false;
  final box = GetStorage();
  String userName = '';
  String userRole = '';

  String getUserName() => userName = box.read("name").toString();
  String getUserRole() => userRole = box.read("role").toString();
}
