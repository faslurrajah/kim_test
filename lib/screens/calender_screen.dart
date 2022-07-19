

import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderView extends StatefulWidget {
  const CalenderView({Key? key}) : super(key: key);

  @override
  CalenderViewState createState() => CalenderViewState();
}

class CalenderViewState extends State<CalenderView> {
  late final ValueNotifier<List<String>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<String> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  Widget weekDayBuilder(String day, Color colors) {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 7,
        child: Center(
            child: Text(
          day,
          style: TextStyle(color: colors, fontWeight: FontWeight.bold),
        )));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Card(
              elevation: 8,
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Icon(Icons.notifications),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(Icons.menu)
                    ],
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Row(
                        children: const [
                          Text(
                            'May 2022',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.keyboard_arrow_down)
                        ],
                      )),
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50))),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          weekDayBuilder('Sun', Colors.red),
                          weekDayBuilder('Mon', Colors.grey),
                          weekDayBuilder('Tue', Colors.grey),
                          weekDayBuilder('Wed', Colors.grey),
                          weekDayBuilder('Thu', Colors.grey),
                          weekDayBuilder('Fri', Colors.grey),
                          weekDayBuilder('Sat', Colors.blue),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TableCalendar<String>(
              daysOfWeekHeight: 0,
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              onDaySelected: _onDaySelected,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                formatButtonShowsNext: false,
                leftChevronVisible: false,
                rightChevronVisible: false,
                headerMargin: EdgeInsets.zero,
                headerPadding: EdgeInsets.zero,
              ),
              calendarStyle: const CalendarStyle(
                // Use `CalendarStyle` to customize the UI
                outsideDaysVisible: false,
              ),
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, DateTime date1, DateTime date2) {
                return Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: kEvents.containsKey(date1)
                              ? Colors.redAccent.withOpacity(0.3)
                              : Colors.grey.withOpacity(0.03),
                          border: Border.all(
                              color: date1.isAtSameMomentAs(_selectedDay!)
                                  ? Colors.lightBlueAccent
                                  : Colors.transparent)),
                      width: MediaQuery.of(context).size.width * 0.9 / 7,
                      height: MediaQuery.of(context).size.width * 0.9 / 7,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              date1.day.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: DateFormat.EEEE()
                                          .format(date1)
                                          .contains("Sunday")
                                      ? Colors.redAccent
                                      : kEvents.containsKey(date1)
                                          ? Colors.white
                                          : DateFormat.EEEE()
                                                  .format(date1)
                                                  .contains("Saturday")
                                              ? Colors.blue
                                              : Colors.grey),
                            ),
                            kEvents.containsKey(date1)
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        right: 5, bottom: 3, top: 3),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Icon(
                                          Icons.ac_unit,
                                          size: 13,
                                          color: Colors.blue,
                                        ),
                                        Icon(
                                          Icons.access_alarms_rounded,
                                          size: 13,
                                          color: Colors.orange,
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        ),
                      )),
                );
              }, markerBuilder: (context, DateTime date1, List events) {
                return const Text('');
              }, outsideBuilder: (context, DateTime date1, DateTime date2) {
                return const Text('Hi');
              }, todayBuilder: (context, DateTime date1, DateTime date2) {
                return Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.lightBlueAccent)),
                      width: MediaQuery.of(context).size.width * 0.9 / 7,
                      height: MediaQuery.of(context).size.width * 0.9 / 7,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(date1.day.toString()),
                      )),
                );
              }, selectedBuilder: (context, DateTime date1, DateTime date2) {
                return Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: kEvents.containsKey(date1)
                              ? Colors.redAccent.withOpacity(0.3)
                              : Colors.grey.withOpacity(0.03),
                          border: Border.all(
                              color: date1.isAtSameMomentAs(_selectedDay!)
                                  ? Colors.lightBlueAccent
                                  : Colors.transparent)),
                      width: MediaQuery.of(context).size.width * 0.9 / 7,
                      height: MediaQuery.of(context).size.width * 0.9 / 7,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              date1.day.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: DateFormat.EEEE()
                                          .format(date1)
                                          .contains("Sunday")
                                      ? Colors.redAccent
                                      : DateFormat.EEEE()
                                              .format(date1)
                                              .contains("Saturday")
                                          ? Colors.blue
                                          : Colors.grey),
                            ),
                            kEvents.containsKey(date1)
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        right: 5, bottom: 3, top: 3),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Icon(
                                          Icons.ac_unit,
                                          size: 13,
                                          color: Colors.blue,
                                        ),
                                        Icon(
                                          Icons.access_alarms_rounded,
                                          size: 13,
                                          color: Colors.orange,
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        ),
                      )),
                );
              }, headerTitleBuilder: (context, date) {
                return const Text('');
              }, dowBuilder: (context, DateTime date) {
                return const SizedBox();
              }),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: kElevationToShadow[24],
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 8),
                            child: Row(
                              children: [
                                Text(
                                  DateFormat.MMMd().format(_selectedDay!),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          const Divider()
                        ],
                      )),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: ValueListenableBuilder<List<String>>(
                        valueListenable: _selectedEvents,
                        builder: (context, value, _) {
                          return ListView.builder(
                            itemCount: value.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Column(
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.ac_unit,
                                          size: 15,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'AM 10:00 Hospital Reservation',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.class_,
                                          size: 15,
                                          color: Colors.orange,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Brushed teeth 3 times',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final kEvents = LinkedHashMap<DateTime, List<String>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = {
  for (var item in List.generate(50, (index) => index))
    DateTime.utc(kFirstDay.year, kFirstDay.month, item + 5):
        List.generate(1, (index) => 'Test')
}..addAll({
    kToday: [
      'Test',
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
