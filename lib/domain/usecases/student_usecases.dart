import '../repositories/student_repository.dart';
import '../../data/models/api_response.dart';
import '../../data/models/student_models.dart';

class GetStudentDataUseCase {
  final StudentRepository repository;
  GetStudentDataUseCase(this.repository);

  Future<ApiRes<MyData>> execute() => repository.getMyData();
}

class LoginUseCase {
  final StudentRepository repository;
  LoginUseCase(this.repository);

  Future<LoginRes> execute(String username, String password) =>
      repository.login(username, password);
}

class AdminLoginUseCase {
  final StudentRepository repository;
  AdminLoginUseCase(this.repository);

  Future<bool> execute(String username, String password) =>
      repository.adminLogin(username, password);
}
