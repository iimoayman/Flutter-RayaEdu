import 'dart:convert';
import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exceptions.dart';
import '../models/admission_models.dart';
import '../models/api_response.dart';
import '../models/exam_models.dart';
import '../models/material_models.dart';
import '../models/service_models.dart';
import '../models/student_models.dart';

class RemoteDataSource {
  final ApiClient apiClient;

  RemoteDataSource(this.apiClient);

  // Student Login
  Future<LoginRes> login(String username, String password) async {
    try {
      final formData = FormData.fromMap({
        'username': username,
        'password': password,
      });

      final response = await apiClient.studentGateDio.post(
        ApiEndpoints.login,
        data: formData,
      );

      return LoginRes.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(e.response?.data?['errors']?.firstOrNull ?? 'Login failed');
    }
  }

  // Admin Login
  Future<bool> adminLogin(String username, String password) async {
    try {
      final formData = FormData.fromMap({
        'username': username,
        'password': password,
      });

      final response = await apiClient.adminDio.post(
        ApiEndpoints.adminLogin,
        data: formData,
      );

      return response.statusCode == 200 || response.statusCode == 302;
    } on DioException catch (e) {
      throw ApiException('Admin login failed: ${e.message}');
    }
  }

  // Student Profile Data
  Future<ApiRes<MyData>> getMyData() async {
    try {
      final response = await apiClient.studentGateDio.get(
        ApiEndpoints.app,
        queryParameters: {'main_target': 'home'},
      );
      return ApiRes<MyData>.fromJson(
        response.data,
        (data) => MyData.fromJson(data),
      );
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Failed to fetch student data');
    }
  }

  // Student Achievements
  Future<ApiRes<StudentAchievements>> getMyAchievements() async {
    try {
      final response = await apiClient.studentGateDio.get(
        ApiEndpoints.app,
        queryParameters: {'main_target': 'platformLeftHome'},
      );
      return ApiRes<StudentAchievements>.fromJson(
        response.data,
        (data) => StudentAchievements.fromJson(data),
      );
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Failed to fetch achievements');
    }
  }

  // Study Materials
  Future<ApiRes<List<StudyMaterials>>> getMyMaterials() async {
    try {
      final response = await apiClient.studentGateDio.get(
        ApiEndpoints.app,
        queryParameters: {'main_target': 'platformMaterials'},
      );
      return ApiRes<List<StudyMaterials>>.fromJson(
        response.data,
        (list) => (list as List<dynamic>)
            .map((e) => StudyMaterials.fromJson(e))
            .toList(),
      );
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Failed to fetch materials');
    }
  }

  // Chapter Content & Drawer Navigation
  Future<ApiRes<MainPortal>> getChapterData(
      {int? openMaterialPk, int? chapterPk}) async {
    try {
      final params = <String, dynamic>{'main_target': 'platformChapter'};
      if (openMaterialPk != null) {
        params['profesorMaterialPK'] = openMaterialPk;
      }
      if (chapterPk != null) {
        params['chapterPK'] = chapterPk;
      }

      final response = await apiClient.studentGateDio.get(
        ApiEndpoints.app,
        queryParameters: params,
      );
      return ApiRes<MainPortal>.fromJson(
        response.data,
        (data) => MainPortal.fromJson(data),
      );
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Failed to fetch chapter details');
    }
  }

  // Submit Exam Answers
  Future<LoginRes> submitAnswers({
    required int chapterPk,
    required Map<int, String> answers,
  }) async {
    try {
      final answersMap = answers.map((k, v) => MapEntry(k.toString(), v));
      final formData = FormData.fromMap({
        'main_target': 'platformAnswers',
        'answers': jsonEncode(answersMap),
        'chapterPK': chapterPk.toString(),
      });

      final response = await apiClient.studentGateDio.post(
        ApiEndpoints.app,
        data: formData,
      );
      return LoginRes.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Failed to submit exam answers');
    }
  }

  // Complete / End Unit
  Future<LoginRes> endUnit({
    required int openMaterialPk,
    required int chapterPk,
  }) async {
    try {
      final formData = FormData.fromMap({
        'main_target': 'completeChapter',
        'completeChapter': 'true',
        'openMaterialPK': openMaterialPk.toString(),
        'chapterPK': chapterPk.toString(),
      });

      final response = await apiClient.studentGateDio.post(
        ApiEndpoints.app,
        data: formData,
      );
      return LoginRes.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Failed to end unit');
    }
  }

  // Student Services (New Card, Proof of Registration, Grade Statement)
  Future<ApiRes<List<StuServices>>> addService({
    required String serviceType,
    required String addressed,
    required String notesStudent,
  }) async {
    try {
      final formData = FormData.fromMap({
        'service': serviceType,
        'main_target': 'studentService',
        'addressed': addressed,
        'notes_student': notesStudent,
      });

      final response = await apiClient.studentGateDio.post(
        ApiEndpoints.app,
        data: formData,
      );
      return ApiRes<List<StuServices>>.fromJson(
        response.data,
        (list) => (list as List<dynamic>)
            .map((e) => StuServices.fromJson(e))
            .toList(),
      );
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Failed to request student service');
    }
  }

  // History of Services
  Future<ApiRes<List<StuServices>>> getServiceHistory() async {
    try {
      final response = await apiClient.studentGateDio.get(
        ApiEndpoints.app,
        queryParameters: {'main_target': 'studentService'},
      );
      return ApiRes<List<StuServices>>.fromJson(
        response.data,
        (list) => (list as List<dynamic>)
            .map((e) => StuServices.fromJson(e))
            .toList(),
      );
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Failed to fetch service history');
    }
  }

  // Notifications (Alerts / Sessions)
  Future<ApiRes<List<Notifications>>> getAlerts() async {
    try {
      final response = await apiClient.studentGateDio.get(
        ApiEndpoints.app,
        queryParameters: {'main_target': 'platformNotification'},
      );
      return ApiRes<List<Notifications>>.fromJson(
        response.data,
        (list) => (list as List<dynamic>)
            .map((e) => Notifications.fromJson(e))
            .toList(),
      );
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Failed to fetch alerts');
    }
  }

  // Warnings
  Future<ApiRes<List<MyWarnings>>> getWarnings() async {
    try {
      final response = await apiClient.studentGateDio.get(
        ApiEndpoints.app,
        queryParameters: {'main_target': 'StudentAlert'},
      );
      return ApiRes<List<MyWarnings>>.fromJson(
        response.data,
        (list) => (list as List<dynamic>)
            .map((e) => MyWarnings.fromJson(e))
            .toList(),
      );
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Failed to fetch warnings');
    }
  }

  // Results
  Future<ApiRes<ResultsResponse>> getResults() async {
    try {
      final response = await apiClient.studentGateDio.get(
        ApiEndpoints.app,
        queryParameters: {'main_target': 'results'},
      );
      return ApiRes<ResultsResponse>.fromJson(
        response.data,
        (data) => ResultsResponse.fromJson(data),
      );
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Failed to fetch results');
    }
  }

  // Online Exam Results
  Future<ApiRes<List<ExamResultDto>>> getOnlineResults() async {
    try {
      final response = await apiClient.studentGateDio.get(
        ApiEndpoints.app,
        queryParameters: {'main_target': 'resultsOnline'},
      );
      return ApiRes<List<ExamResultDto>>.fromJson(
        response.data,
        (list) => (list as List<dynamic>)
            .map((e) => ExamResultDto.fromJson(e))
            .toList(),
      );
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Failed to fetch online results');
    }
  }

  // Academic Records / Transcripts
  Future<ApiRes<List<ExamInfo>>> getRecords() async {
    try {
      final response = await apiClient.studentGateDio.get(
        ApiEndpoints.app,
        queryParameters: {'main_target': 'StudentMaterial'},
      );
      return ApiRes<List<ExamInfo>>.fromJson(
        response.data,
        (list) =>
            (list as List<dynamic>).map((e) => ExamInfo.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Failed to fetch records');
    }
  }

  // Admission Step 0: Apply Verification
  Future<StudentResponse> applyContinue({
    required String phone,
    required String identifier,
  }) async {
    try {
      final formData = FormData.fromMap({
        'phone': phone,
        'identifier': identifier,
      });

      final response = await apiClient.studentGateDio.post(
        ApiEndpoints.applyContinue,
        data: formData,
      );
      return StudentResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Verification failed');
    }
  }

  // Admission Lookups
  Future<OptionsResponse> getAdmissionLookups() async {
    try {
      final response = await apiClient.studentGateDio.get(ApiEndpoints.applyLookups);
      return OptionsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Failed to fetch lookups');
    }
  }

  // Admission Step 1: Personal Data
  Future<bool> fillDataOne(Map<String, dynamic> data) async {
    try {
      final formData = FormData.fromMap(data);
      final response = await apiClient.studentGateDio.post(
        ApiEndpoints.applyData,
        data: formData,
      );
      return response.data?['success'] == true;
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Failed to save personal data');
    }
  }

  // Admission Step 2: Academic & Coordination Data
  Future<bool> fillDataTwo(Map<String, dynamic> data) async {
    try {
      final formData = FormData.fromMap(data);
      final response = await apiClient.studentGateDio.post(
        ApiEndpoints.applyAdmission,
        data: formData,
      );
      return response.data?['success'] == true;
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Failed to save academic data');
    }
  }
}
