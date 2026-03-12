import 'package:get/get.dart';
import '../../../data/repositories/ai_repository.dart';

class CalculationController extends GetxController {
  final AiRepository _aiRepository = AiRepository();

  final RxBool isLoading = false.obs;

  final RxString statusMessage = "".obs;

  final RxString imageUrl = "".obs;

  /// =========================
  /// GENERATE AI IMAGE
  /// =========================
  Future<void> generateAIDrawing(String prompt) async {
    try {
      isLoading.value = true;

      final response = await _aiRepository.generateDrawing(
        inputData: {"prompt": prompt},
      );

      print("API RESPONSE: $response");

      imageUrl.value = response["image"];
    } catch (e) {
      print("AI drawing error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
