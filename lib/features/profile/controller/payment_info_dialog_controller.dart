import 'package:get/get.dart';

class PaymentInfodialogController extends GetxController {
  var selectedCountry = 'America'.obs;
  var selectedCurrency = 'US Dollar'.obs;
  var selectedTimeZone = 'Los Angeles, America (GMT-08:00)'.obs;

  List<String> countries = ['America', 'Canada', 'United Kingdom', 'Australia'];
  List<String> currencies = ['US Dollar', 'Canadian Dollar', 'Pound', 'Euro'];
  List<String> timeZones = [
    'Los Angeles, America (GMT-08:00)',
    'New York, America (GMT-05:00)',
    'London, Europe (GMT+00:00)',
    'Sydney, Australia (GMT+10:00)',
  ];

  void onNext() {
    // Perform validation or navigation logic here
    Get.back(); // Close dialog for now
  }
}
