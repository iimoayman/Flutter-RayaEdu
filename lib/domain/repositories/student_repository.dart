import '../../data/models/admission_models.dart';
import '../../data/models/api_response.dart';
import '../../data/models/exam_models.dart';
import '../../data/models/material_models.dart';
import '../../data/models/service_models.dart';
import '../../data/models/student_models.dart';

abstract class StudentRepository {
  Future<LoginRes> login(String username, String password);
  Future<bool> adminLogin(String username, String password);
  Future<ApiRes<MyData>> getMyData();
  Future<ApiRes<StudentAchievements>> getMyAchievements();
  Future<ApiRes<List<StudyMaterials>>> getMyMaterials();
  Future<ApiRes<MainPortal>> getChapterData({int? openMaterialPk, int? chapterPk});
  Future<LoginRes> submitAnswers({required int chapterPk, required Map<int, String> answers});
  Future<LoginRes> endUnit({required int openMaterialPk, required int chapterPk});
  Future<ApiRes<List<StuServices>>> addService({required String serviceType, required String addressed, required String notesStudent});
  Future<ApiRes<List<StuServices>>> getServiceHistory();
  Future<ApiRes<List<Notifications>>> getAlerts();
  Future<ApiRes<List<MyWarnings>>> getWarnings();
  Future<ApiRes<ResultsResponse>> getResults();
  Future<ApiRes<List<ExamResultDto>>> getOnlineResults();
  Future<ApiRes<List<ExamInfo>>> getRecords();
  Future<StudentResponse> applyContinue({required String phone, required String identifier});
  Future<OptionsResponse> getAdmissionLookups();
  Future<bool> fillDataOne(Map<String, dynamic> data);
  Future<bool> fillDataTwo(Map<String, dynamic> data);
  Future<List<Order>> getRayaBanners();
  Future<List<Order>> getGuestBanners();
  Future<List<Order>> getGuestBannersSecond();
  Future<List<HuaweiSession>> getHuaweiSessions();
  Future<void> signOut();
}
