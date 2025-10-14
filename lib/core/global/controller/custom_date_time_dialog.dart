
import 'package:get/get.dart';

class CustomDateTimeController extends GetxController {
  var selectedDate = DateTime.now().obs; // Observable selected date
  var startDate = DateTime.utc(2020, 1, 1).obs; // Observable start date (min date)

  void setSelectedDate(DateTime newDate) {
    selectedDate.value = newDate; // Update selected date
  }

  void setStartDate(DateTime newStartDate) {
    startDate.value = newStartDate; // Update start date
  }
}