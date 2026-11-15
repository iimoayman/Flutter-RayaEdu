import '../../domain/repositories/student_repository.dart';
import '../datasources/local_datasource.dart';
import '../datasources/remote_datasource.dart';
import '../datasources/supabase_datasource.dart';
import '../models/admission_models.dart';
import '../models/api_response.dart';
import '../models/exam_models.dart';
import '../models/material_models.dart';
import '../models/service_models.dart';
import '../models/student_models.dart';

class StudentRepositoryImpl implements StudentRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final SupabaseDataSource supabaseDataSource;

  StudentRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.supabaseDataSource,
  });

  @override
  Future<LoginRes> login(String username, String password) =>
      remoteDataSource.login(username, password);

  @override
  Future<bool> adminLogin(String username, String password) =>
      remoteDataSource.adminLogin(username, password);

  @override
  Future<ApiRes<MyData>> getMyData() => remoteDataSource.getMyData();

  @override
  Future<ApiRes<StudentAchievements>> getMyAchievements() =>
      remoteDataSource.getMyAchievements();

  @override
  Future<ApiRes<List<StudyMaterials>>> getMyMaterials() =>
      remoteDataSource.getMyMaterials();

  @override
  Future<ApiRes<MainPortal>> getChapterData(
          {int? openMaterialPk, int? chapterPk}) =>
      remoteDataSource.getChapterData(
        openMaterialPk: openMaterialPk,
        chapterPk: chapterPk,
      );

  @override
  Future<LoginRes> submitAnswers(
          {required int chapterPk, required Map<int, String> answers}) =>
      remoteDataSource.submitAnswers(chapterPk: chapterPk, answers: answers);

  @override
  Future<LoginRes> endUnit(
          {required int openMaterialPk, required int chapterPk}) =>
      remoteDataSource.endUnit(
        openMaterialPk: openMaterialPk,
        chapterPk: chapterPk,
      );

  @override
  Future<ApiRes<List<StuServices>>> addService(
          {required String serviceType,
          required String addressed,
          required String notesStudent}) =>
      remoteDataSource.addService(
        serviceType: serviceType,
        addressed: addressed,
        notesStudent: notesStudent,
      );

  @override
  Future<ApiRes<List<StuServices>>> getServiceHistory() =>
      remoteDataSource.getServiceHistory();

  @override
  Future<ApiRes<List<Notifications>>> getAlerts() =>
      remoteDataSource.getAlerts();

  @override
  Future<ApiRes<List<MyWarnings>>> getWarnings() =>
      remoteDataSource.getWarnings();

  @override
  Future<ApiRes<ResultsResponse>> getResults() =>
      remoteDataSource.getResults();

  @override
  Future<ApiRes<List<ExamResultDto>>> getOnlineResults() =>
      remoteDataSource.getOnlineResults();

  @override
  Future<ApiRes<List<ExamInfo>>> getRecords() =>
      remoteDataSource.getRecords();

  @override
  Future<StudentResponse> applyContinue(
          {required String phone, required String identifier}) =>
      remoteDataSource.applyContinue(phone: phone, identifier: identifier);

  @override
  Future<OptionsResponse> getAdmissionLookups() =>
      remoteDataSource.getAdmissionLookups();

  @override
  Future<bool> fillDataOne(Map<String, dynamic> data) =>
      remoteDataSource.fillDataOne(data);

  @override
  Future<bool> fillDataTwo(Map<String, dynamic> data) =>
      remoteDataSource.fillDataTwo(data);

  @override
  Future<List<Order>> getRayaBanners() => supabaseDataSource.getRayaBanners();

  @override
  Future<List<Order>> getGuestBanners() => supabaseDataSource.getGuestBanners();

  @override
  Future<List<Order>> getGuestBannersSecond() =>
      supabaseDataSource.getGuestBannersSecond();

  @override
  Future<List<HuaweiSession>> getHuaweiSessions() =>
      supabaseDataSource.getHuaweiSessions();

  @override
  Future<void> signOut() async {
    await localDataSource.clearAll();
  }
}
