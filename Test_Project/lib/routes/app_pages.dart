import 'package:get/get.dart';
import 'package:test_project/bindings/field_tools_binding.dart';
import 'package:test_project/core/constants/route_constants.dart';
import 'package:test_project/features/ai_assistant/screens/ai_civil_screen.dart';
import 'package:test_project/features/field_tools/screens/area_calc_screen.dart';
import 'package:test_project/features/field_tools/screens/cad_viewer_screen.dart';
import 'package:test_project/features/field_tools/screens/concrete_calc_screen.dart';
import 'package:test_project/features/field_tools/screens/gps_tool_screen.dart';
import 'package:test_project/features/field_tools/screens/level_tools_screen.dart';
import 'package:test_project/features/field_tools/screens/site_diary_screen.dart';
import 'package:test_project/features/field_tools/screens/slope_calc_screen.dart';
import 'package:test_project/features/field_tools/screens/steel_calc_screen.dart';
import 'package:test_project/features/field_tools/screens/sun_path_screen.dart';
import 'package:test_project/features/field_tools/screens/unit_converter_screen.dart';
import 'package:test_project/features/reports/screens/create_report_screen.dart';

import '../routes/app_routes.dart';

import '../bindings/auth_binding.dart';
import '../bindings/dashboard_binding.dart';
import '../bindings/project_binding.dart';
import '../bindings/calculation_binding.dart';
import '../bindings/report_binding.dart';

import '../features/auth/screens/splash_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';

import '../features/dashboard/screens/dashboard_screen.dart';

import '../features/projects/screens/project_list_screen.dart';
import '../features/projects/screens/create_project_screen.dart';
import '../features/projects/screens/project_detail_screen.dart';

import '../features/calculations/screens/calculation_type_screen.dart';
import '../features/calculations/screens/structure_input_screen.dart';
import '../features/calculations/screens/drawing_result_screen.dart';

import '../features/field_tools/screens/field_tools_screen.dart';
import '../features/field_tools/screens/measurement_screen.dart';

import '../features/reports/screens/report_list_screen.dart';
import '../features/calculations/screens/building_input_screen.dart';
import '../features/calculations/screens/road_input_screen.dart';
import '../features/calculations/screens/bridge_input_screen.dart';
import '../features/calculations/screens/chimney_input_screen.dart';
import '../features/calculations/screens/cooling_tower_input_screen.dart';
import '../features/calculations/screens/custom_structure_input_screen.dart';
import '../features/calculations/screens/dam_input_screen.dart';
import '../features/calculations/screens/factory_input_screen.dart';
import '../features/calculations/screens/fence_input_screen.dart';
import '../features/calculations/screens/foundation_input_screen.dart';
import '../features/calculations/screens/parking_input_screen.dart';
import '../features/calculations/screens/pipeline_input_screen.dart';
import '../features/calculations/screens/plant_input_screen.dart';
import '../features/calculations/screens/retaining_wall_input_screen.dart';
import '../features/calculations/screens/silo_input_screen.dart';
import '../features/calculations/screens/solar_farm_input_screen.dart';
import '../features/calculations/screens/tank_input_screen.dart';
import '../features/calculations/screens/telecom_tower_input_screen.dart';
import '../features/calculations/screens/tower_input_screen.dart';
import '../features/calculations/screens/tunnel_input_screen.dart';
import '../features/calculations/screens/warehouse_input_screen.dart';

class AppPages {
  static final routes = [
    /// AUTH MODULE
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupScreen(),
      binding: AuthBinding(),
    ),

    /// DASHBOARD
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),

    /// PROJECTS
    GetPage(
      name: AppRoutes.projects,
      page: () => const ProjectListScreen(),
      binding: ProjectBinding(),
    ),

    GetPage(
      name: AppRoutes.createProject,
      page: () => const CreateProjectScreen(),
      binding: ProjectBinding(),
    ),

    GetPage(
      name: AppRoutes.projectDetail,
      page: () => const ProjectDetailScreen(),
      binding: ProjectBinding(),
    ),

    /// CALCULATIONS
    GetPage(
      name: AppRoutes.calculationType,
      page: () => const CalculationTypeScreen(),
      binding: CalculationBinding(),
    ),

    GetPage(
      name: AppRoutes.houseInput,
      page: () => const StructureInputScreen(),
      binding: CalculationBinding(),
    ),

    GetPage(
      name: AppRoutes.drawingResult,
      page: () => const DrawingResultScreen(),
      binding: CalculationBinding(),
    ),

    /// FIELD TOOLS
    GetPage(
      name: AppRoutes.fieldTools,
      page: () => const FieldToolsScreen(),
      binding: FieldToolsBinding(),
    ),

    GetPage(name: AppRoutes.measurement, page: () => const MeasurementScreen()),

    /// AI ASSISTANT

    /// REPORTS
    GetPage(
      name: AppRoutes.reports,
      page: () => const ReportListScreen(),
      binding: ReportBinding(),
    ),

    GetPage(
      name: AppRoutes.createReport,
      page: () => const CreateReportScreen(),
      binding: ReportBinding(),
    ),

    GetPage(name: AppRoutes.levelTool, page: () => const LevelToolScreen()),

    GetPage(name: AppRoutes.gpsTool, page: () => const GpsToolScreen()),

    GetPage(
      name: AppRoutes.unitConverter,
      page: () => const UnitConverterScreen(),
    ),

    GetPage(
      name: AppRoutes.concreteCalc,
      page: () => const ConcreteCalcScreen(),
    ),

    GetPage(name: AppRoutes.steelCalc, page: () => const SteelCalcScreen()),

    GetPage(name: AppRoutes.siteDiary, page: () => const SiteDiaryScreen()),

    GetPage(name: AppRoutes.cadViewer, page: () => const CadViewerScreen()),

    GetPage(name: AppRoutes.sunPath, page: () => const SunPathScreen()),
    GetPage(name: AppRoutes.aiChat, page: () => const AiCivilScreen()),
    GetPage(name: RouteConstants.areaCalc, page: () => const AreaCalcScreen()),

    GetPage(
      name: RouteConstants.slopeCalc,
      page: () => const SlopeCalcScreen(),
    ),

    /// CALCULATIONS
    GetPage(
      name: AppRoutes.calculationType,
      page: () => const CalculationTypeScreen(),
      binding: CalculationBinding(),
    ),

    /// RESULT
    GetPage(
      name: AppRoutes.drawingResult,
      page: () => const DrawingResultScreen(),
      binding: CalculationBinding(),
    ),

    /// =============================
    /// STRUCTURE INPUT SCREENS
    /// =============================
    GetPage(
      name: RouteConstants.buildingInput,
      page: () => const BuildingInputScreen(),
      binding: CalculationBinding(),
    ),

    GetPage(
      name: RouteConstants.roadInput,
      page: () => const RoadInputScreen(),
      binding: CalculationBinding(),
    ),

    GetPage(
      name: RouteConstants.bridgeInput,
      page: () => const BridgeInputScreen(),
      binding: CalculationBinding(),
    ),

    GetPage(
      name: RouteConstants.chimneyInput,
      page: () => const ChimneyInputScreen(),
      binding: CalculationBinding(),
    ),

    GetPage(
      name: RouteConstants.coolingTowerInput,
      page: () => const CoolingTowerInputScreen(),
      binding: CalculationBinding(),
    ),

    GetPage(
      name: RouteConstants.customStructureInput,
      page: () => const CustomStructureInputScreen(),
      binding: CalculationBinding(),
    ),

    GetPage(
      name: RouteConstants.damInput,
      page: () => const DamInputScreen(),
      binding: CalculationBinding(),
    ),

    GetPage(
      name: RouteConstants.factoryInput,
      page: () => const FactoryInputScreen(),
      binding: CalculationBinding(),
    ),

    GetPage(
      name: RouteConstants.fenceInput,
      page: () => const FenceInputScreen(),
      binding: CalculationBinding(),
    ),

    GetPage(
      name: RouteConstants.foundationInput,
      page: () => const FoundationInputScreen(),
      binding: CalculationBinding(),
    ),

    GetPage(
      name: RouteConstants.parkingInput,
      page: () => const ParkingInputScreen(),
      binding: CalculationBinding(),
    ),

    GetPage(
      name: RouteConstants.pipelineInput,
      page: () => const PipelineInputScreen(),
      binding: CalculationBinding(),
    ),

    GetPage(
      name: RouteConstants.plantInput,
      page: () => const PlantInputScreen(),
      binding: CalculationBinding(),
    ),

    GetPage(
      name: RouteConstants.retainingWallInput,
      page: () => const RetainingWallInputScreen(),
      binding: CalculationBinding(),
    ),

    GetPage(
      name: RouteConstants.siloInput,
      page: () => const SiloInputScreen(),
      binding: CalculationBinding(),
    ),

    GetPage(
      name: RouteConstants.solarFarmInput,
      page: () => const SolarFarmInputScreen(),
      binding: CalculationBinding(),
    ),

    GetPage(
      name: RouteConstants.tankInput,
      page: () => const TankInputScreen(),
      binding: CalculationBinding(),
    ),

    GetPage(
      name: RouteConstants.telecomTowerInput,
      page: () => const TelecomTowerInputScreen(),
      binding: CalculationBinding(),
    ),

    GetPage(
      name: RouteConstants.towerInput,
      page: () => const TowerInputScreen(),
      binding: CalculationBinding(),
    ),

    GetPage(
      name: RouteConstants.tunnelInput,
      page: () => const TunnelInputScreen(),
      binding: CalculationBinding(),
    ),

    GetPage(
      name: RouteConstants.warehouseInput,
      page: () => const WarehouseInputScreen(),
      binding: CalculationBinding(),
    ),
  ];
}
