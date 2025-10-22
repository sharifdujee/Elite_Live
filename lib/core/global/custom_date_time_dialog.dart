
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

import '../global_widget/controller/custom_date_time_dialogue.dart';
import 'controller/custom_date_time_dialog.dart';
import 'custom_elevated_button.dart';



class CustomDateTimePicker extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final Function onClick;

  const CustomDateTimePicker({
    super.key,
    this.hintText,
    this.controller,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFEDEEF4),
          width: 1, // Border width
        ),
      ),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              onClick();
            },
            icon: Icon(Icons.calendar_month),
          ),
          hintStyle: GoogleFonts.poppins(
            color: Color(0xff1F2C37),
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(10),
        ),
      ),
    );
  }
}

class CustomDatePicker extends StatelessWidget {
  final Function(DateTime selectedDate) selectedDateCallback;

  const CustomDatePicker({super.key, required this.selectedDateCallback});

  @override
  Widget build(BuildContext context) {
    final dateController = Get.find<CustomDateTimeController>();
    var selectedDate = dateController.selectedDate.value;

    int currentYear = DateTime.now().year;
    List<int> yearsList = List.generate(
      100,
          (index) => currentYear - index,
    ); // Past 100 years

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
                  () => Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: DropdownButton<int>(
                  value: dateController.selectedDate.value.year,
                  onChanged: (newYear) {
                    if (newYear != null) {
                      // Update the selected year in the calendar
                      dateController.setSelectedDate(
                        DateTime(newYear, selectedDate.month, selectedDate.day),
                      );
                      selectedDateCallback(
                        DateTime(newYear, selectedDate.month, selectedDate.day),
                      );
                    }
                  },
                  items:
                  yearsList.map((int year) {
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(
                        year.toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // TableCalendar widget
            Obx(() {
              return TableCalendar(
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  titleTextStyle: Theme.of(context).textTheme.titleLarge!,
                ),
                calendarStyle: CalendarStyle(
                  defaultTextStyle: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(color: Colors.black),
                  weekendTextStyle: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(color: Colors.black),
                ),
                focusedDay: dateController.selectedDate.value,
                selectedDayPredicate: (day) {
                  // Return true if the day is the selected date
                  return isSameDay(dateController.selectedDate.value, day);
                },
                daysOfWeekVisible: false,
                onDaySelected: (selectedDay, focusedDay) {
                  selectedDate = dateController.selectedDate.value;
                  dateController.setSelectedDate(selectedDay);
                  selectedDateCallback(
                    selectedDay,
                  ); // Pass the selected date back
                  // Navigator.pop(
                  //     context); // Close the bottom sheet after selecting the date
                },
                // firstDay: dateController.startDate.value,
                // // Use startDate as the first day
                // lastDay: DateTime.utc(2099, 12, 31),
                firstDay: DateTime(
                  dateController.selectedDate.value.year,
                  1,
                  1,
                ),
                lastDay: DateTime(
                  dateController.selectedDate.value.year,
                  12,
                  31,
                ),
                // Set last valid date
                calendarFormat: CalendarFormat.month,
              );
            }),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CustomElevatedButton(
                ontap: () {
                  selectedDateCallback(selectedDate);
                  Navigator.pop(context);
                },
                text: "Next",
              ),
            ),
          ],
        ),
      ),
    );
  }
}