import 'package:flutter/material.dart';
import 'package:flutter_getx_project_template/constant/app_colors.dart';
import 'package:flutter_getx_project_template/utils/app_size.dart';
import 'package:flutter_getx_project_template/utils/error_log.dart';
import 'package:flutter_getx_project_template/utils/gap.dart';
import 'package:flutter_getx_project_template/widgets/texts/app_text.dart';

class CalendarView extends StatefulWidget {
  final DateTime initialDate;
  final bool isSecond;
  final Function(DateTime) onDateSelected;

  const CalendarView({super.key, required this.initialDate, required this.onDateSelected, required this.isSecond});

  @override
  State createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime selectedDate = DateTime.now();
  DateTime selectedCurrentDate = DateTime.now();
  int? selectedYear;
  List<String> months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

  List<String> weekdays = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"];

  @override
  void initState() {
    selectedDate = widget.initialDate;
    selectedYear = selectedDate.year;
    super.initState();
  }

  // Handle the year change
  void _changeYear(int year) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        selectedYear = year;
        selectedDate = DateTime(year, selectedDate.month, selectedDate.day);
      });
    });
  }

  // Handle the month change
  void _changeMonth(int delta) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        selectedDate = DateTime(selectedDate.year, selectedDate.month + delta, selectedDate.day);
      });
    });
  }

  bool _active({required DateTime dateTime}) {
    try {
      if (widget.isSecond) {
        if (dateTime.isBefore(widget.initialDate.add(Duration(days: 1)))) {
          return true;
        } else {
          return false;
        }
      } else {
        if (dateTime.isBefore(widget.initialDate.subtract(const Duration(days: 1)))) {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      errorLog("message", e);
    }
    return true;
  }

  // Build the days for the current month
  List<Widget> _buildDays() {
    int daysInMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    int firstWeekdayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1).weekday;
    int lastWeekdayOfMonth = DateTime(selectedDate.year, selectedDate.month, daysInMonth).weekday;

    // Determine the number of days needed from the previous and next months
    int prevMonthDays = firstWeekdayOfMonth == 7 ? 0 : firstWeekdayOfMonth;
    int nextMonthDays = (6 - lastWeekdayOfMonth);

    List<Widget> dayWidgets = [];

    // Add empty containers for the previous month's days before the start of the current month
    for (int i = prevMonthDays; i > 0; i--) {
      DateTime prevMonthDay = DateTime(selectedDate.year, selectedDate.month, -i);
      dayWidgets.add(Center(child: AppText(data: prevMonthDay.day.toString(), color: AppColors.instance.dark200)));
    }

    // Actual days of the current month
    for (int day = 1; day <= daysInMonth; day++) {
      DateTime currentDay = DateTime(selectedDate.year, selectedDate.month, day);
      bool isSelected = currentDay.day == selectedCurrentDate.day && currentDay.year == selectedCurrentDate.year && currentDay.month == selectedCurrentDate.month;
      dayWidgets.add(
        GestureDetector(
          // onTap: currentDay.month == selectedDate.month ? () => _onDaySelected(currentDay) : null,
          onTap: () => _onDaySelected(currentDay),
          child: Container(
            decoration: BoxDecoration(color: _active(dateTime: currentDay) ? AppColors.instance.dark200 : AppColors.instance.primary100),
            child: Container(
              margin: EdgeInsets.all(AppSize.width(value: 5)),
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 2, color: isSelected ? AppColors.instance.primary500 : AppColors.instance.transparent)),
              child: Center(child: AppText(data: day.toString())),
            ),
          ),
        ),
      );
    }

    // Add empty containers for the next month's days after the end of the current month
    for (int i = 1; i <= nextMonthDays; i++) {
      DateTime nextMonthDay = DateTime(selectedDate.year, selectedDate.month + 1, i);
      dayWidgets.add(Center(child: AppText(data: nextMonthDay.day.toString(), color: AppColors.instance.dark200)));
    }

    // Ensure the total number of items is a multiple of 7 (for 7 columns) by adding empty containers if necessary
    while (dayWidgets.length % 7 != 0) {
      dayWidgets.add(Container()); // Empty container to fill the last row
    }

    return dayWidgets;
  }

  // Handle day selection
  void _onDaySelected(DateTime day) {
    try {
      if (_active(dateTime: day)) {
        return;
      }
      setState(() {
        selectedDate = day;
        widget.onDateSelected(selectedDate);
      });
      Navigator.pop(context);
    } catch (e) {
      errorLog("_onDaySelected", e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            margin: EdgeInsets.all(AppSize.width(value: 20)),
            padding: EdgeInsets.all(AppSize.width(value: 20)),
            decoration: BoxDecoration(
              color: AppColors.instance.blue2_50,
              borderRadius: BorderRadius.circular(AppSize.width(value: 10)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top bar: Year and Month with change buttons
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          PopupMenuButton(
                            color: AppColors.instance.primary300,
                            position: PopupMenuPosition.under,
                            child: AppText(data: selectedYear.toString(), fontSize: 24, fontWeight: FontWeight.bold),
                            onSelected: (value) {
                              _changeYear(value);
                            },
                            itemBuilder: (context) {
                              return List.generate(5, (index) {
                                int year = DateTime.now().year + index;
                                return PopupMenuItem(value: year, child: AppText(data: year.toString()));
                              });
                            },
                          ),
                          AppText(data: "  -  ", fontSize: 24, fontWeight: FontWeight.bold),
                          PopupMenuButton(
                            color: AppColors.instance.primary500,
                            position: PopupMenuPosition.under,
                            child: AppText(data: months[selectedDate.month - 1], fontSize: 24, fontWeight: FontWeight.bold),
                            onSelected: (value) {
                              setState(() {
                                selectedDate = DateTime(selectedDate.year, value + 1, 1);
                              });
                            },
                            itemBuilder: (context) {
                              return List.generate(months.length - 1, (index) {
                                return PopupMenuItem(value: index, child: AppText(data: months[index]));
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Gap(width: 20),
                          IconButton(
                            onPressed: () {
                              _changeMonth(-1);
                            },
                            icon: Icon(Icons.arrow_back_ios, color: AppColors.instance.dark500),
                          ),
                          IconButton(
                            onPressed: () {
                              _changeMonth(1);
                            },
                            icon: Icon(Icons.arrow_forward_ios, color: AppColors.instance.dark500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Gap(height: 10),
                // Weekday labels row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: weekdays.map((day) => Expanded(child: Container(alignment: Alignment.center, child: AppText(data: day, fontWeight: FontWeight.bold)))).toList(),
                ),
                SizedBox(height: 8),

                GridView.count(shrinkWrap: true, crossAxisCount: 7, padding: EdgeInsets.zero, mainAxisSpacing: 2, crossAxisSpacing: 2, children: _buildDays()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showCustomCalendarView(BuildContext context, {required DateTime initialDate, required Function(DateTime) onDateSelected, bool isSecond = false}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CalendarView(initialDate: initialDate, onDateSelected: onDateSelected, isSecond: isSecond);
    },
  );
}
