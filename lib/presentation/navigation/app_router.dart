import 'package:flutter/material.dart';
import '../features/admission/view/add_stu_view.dart';
import '../features/admission/view/fill_data_one_view.dart';
import '../features/admission/view/fill_data_two_view.dart';
import '../features/auth/view/sign_in_view.dart';
import '../features/digital_id/view/my_digital_id_view.dart';
import '../features/edu_portal/view/exam_controller_view.dart';
import '../features/edu_portal/view/portal_material_nav_view.dart';
import '../features/edu_portal/view/qr_scan_view.dart';
import '../features/guest/view/crew_view.dart';
import '../features/guest/view/guest_view.dart';
import '../features/guest/view/program_details_view.dart';
import '../features/home/view/home_portal_view.dart';
import '../features/home/view/location_view.dart';
import '../features/home/view/notifications_tab_view.dart';
import '../features/onboarding/view/onboarding_view.dart';
import '../features/results_records/view/exams_view.dart';
import '../features/results_records/view/records_view.dart';
import '../features/results_records/view/results_online_view.dart';
import '../features/results_records/view/results_view.dart';
import '../features/settings/view/settings_menu_view.dart';
import '../features/splash/view/loading_view.dart';
import '../features/student_services/view/add_new_statement_view.dart';
import '../features/student_services/view/new_card_view.dart';
import '../features/student_services/view/proof_of_registration_view.dart';
import '../features/student_services/view/student_guide_view.dart';
import '../features/student_services/view/student_service_view.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const LoadingView());

      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingView());

      case AppRoutes.signIn:
        return MaterialPageRoute(builder: (_) => const SignInView());

      case AppRoutes.guest:
        return MaterialPageRoute(builder: (_) => const GuestView());

      case AppRoutes.guestProgramDetails:
        return MaterialPageRoute(builder: (_) => const ProgramDetailsView());

      case AppRoutes.guestCrew:
        return MaterialPageRoute(builder: (_) => const CrewView());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePortalView());

      case AppRoutes.digitalId:
        return MaterialPageRoute(builder: (_) => const MyDigitalIdView());

      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsTabView());

      case AppRoutes.location:
        return MaterialPageRoute(builder: (_) => const LocationView());

      case AppRoutes.qrScan:
        return MaterialPageRoute(builder: (_) => const QrScanView());

      case AppRoutes.portalMaterialNav:
        return MaterialPageRoute(builder: (_) => const PortalMaterialNavView());

      case AppRoutes.examController:
        return MaterialPageRoute(builder: (_) => const ExamControllerView());

      case AppRoutes.studentServices:
        return MaterialPageRoute(builder: (_) => const StudentServiceView());

      case AppRoutes.newCard:
        return MaterialPageRoute(builder: (_) => const NewCardView());

      case AppRoutes.proofOfRegistration:
        return MaterialPageRoute(builder: (_) => const ProofOfRegistrationView());

      case AppRoutes.addNewStatement:
        return MaterialPageRoute(builder: (_) => const AddNewStatementView());

      case AppRoutes.studentGuide:
        return MaterialPageRoute(builder: (_) => const StudentGuideView());

      case AppRoutes.exams:
        return MaterialPageRoute(builder: (_) => const ExamsView());

      case AppRoutes.results:
        return MaterialPageRoute(builder: (_) => const ResultsView());

      case AppRoutes.resultsOnline:
        return MaterialPageRoute(builder: (_) => const ResultsOnlineView());

      case AppRoutes.records:
        return MaterialPageRoute(builder: (_) => const RecordsView());

      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsMenuView());

      case AppRoutes.addStu:
        return MaterialPageRoute(builder: (_) => const AddStuView());

      case AppRoutes.fillDataOne:
        return MaterialPageRoute(builder: (_) => const FillDataOneView());

      case AppRoutes.fillDataTwo:
        return MaterialPageRoute(builder: (_) => const FillDataTwoView());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
