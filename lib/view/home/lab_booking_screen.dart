import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:smart_engineering_lab/enum/view_state_enum.dart';
import 'package:smart_engineering_lab/model/lab_booking_model.dart';
import 'package:smart_engineering_lab/provider/root_change_notifier.dart';
import 'package:smart_engineering_lab/services/database_services.dart';
import 'package:smart_engineering_lab/widget/login_button_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class LabBookingScreen extends StatefulWidget {
  const LabBookingScreen({Key? key}) : super(key: key);

  @override
  _LabBookingScreenState createState() => _LabBookingScreenState();
}

class _LabBookingScreenState extends State<LabBookingScreen> {
  late final ValueNotifier<List<LabBookingModel>> _selectedEvents;
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  bool labRoomSelected = false;
  bool daySelected = false;
  bool timeSlotSelected = false;
  String? room;
  String? timeSlot;

  List<Map<String, dynamic>> listLabRoom = [
    {'name': '1', 'selected': false},
    {'name': '2', 'selected': false},
    {'name': '3', 'selected': false},
    {'name': '4', 'selected': false}
  ];
  Map<String, List<Map<String, dynamic>>> listTimeSlot = {
    'Evening': [
      {'time': '2:00 PM - 3:00 PM', 'selected': false},
      {'time': '3:00 PM - 4:00 PM', 'selected': false},
      {'time': '4:00 PM - 5:00 PM', 'selected': false}
    ],
    'Morning': [
      {'time': '9:00 AM - 10:00 AM', 'selected': false},
      {'time': '10:00 AM - 11:00 AM', 'selected': false},
      {'time': '11:00 AM - 12:00 PM', 'selected': false}
    ]
  };
  var listForADaySubscription;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
    // listForADaySubscription =
    //     DatabaseService().listOfLabBookingForADay(_selectedDay).listen((event) {
    //   _selectedEvents =
    //       ValueNotifier(_getEventsForDay(_selectedDay, list: event));
    // });
  }

  List<LabBookingModel> _getEventsForDay(DateTime? day,
      {List<LabBookingModel>? list}) {
    // Implementation example
    return day == null ? [] : list ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      if (_selectedDay != null) {
        daySelected = true;
      }
      // listForADaySubscription = DatabaseService()
      //     .listOfLabBookingForADay(_selectedDay)
      //     .listen((event) {
      //   _selectedEvents =
      //       ValueNotifier(_getEventsForDay(_selectedDay, list: event));
      // });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.read<User>();
    final changeNotifier = context.read<RootChangeNotifier>();
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 36.0),
        child: Column(
          children: [
            const Text('Lab Booking'),
            Column(
              children: [
                const Text('Lab Room'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: listLabRoom
                      .map((e) => widgetLabRoom(e, () {
                            setState(() {
                              // e['selected'] = !e['selected'];
                              listLabRoom.forEach((element) {
                                element['selected'] = false;
                              });
                              listLabRoom[listLabRoom.indexOf(e)]['selected'] =
                                  !e['selected'];

                              if (listLabRoom[listLabRoom.indexOf(e)]
                                  ['selected']) {
                                room =
                                    listLabRoom[listLabRoom.indexOf(e)]['name'];
                                labRoomSelected = true;
                              } else {
                                labRoomSelected = false;
                              }
                            });
                          }))
                      .toList(),
                ),
              ],
            ),
            Column(
              children: [
                const Text('Date'),
                TableCalendar(
                  // eventLoader: (day){
                  //   return
                  // },
                  calendarStyle: const CalendarStyle(
                      selectedDecoration: BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle)),
                  calendarFormat: calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: _onDaySelected,
                  firstDay: DateTime.utc(2022, 1, 1),
                  lastDay: DateTime.utc(2023, 1, 1),
                  focusedDay: _focusedDay,
                  onFormatChanged: (format) {
                    if (calendarFormat != format) {
                      // Call `setState()` when updating calendar format
                      setState(() {
                        calendarFormat = format;
                      });
                    }
                  },
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Time Slot'),
                const Divider(
                  height: 2,
                  thickness: 1,
                ),
                // listTimeSlot.forEach((key, value) { })
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: listTimeSlot.keys
                      .map((e1) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e1),
                              Row(
                                children: listTimeSlot[e1]!
                                    .map((e2) => Expanded(
                                            child: buildChipSlot(
                                                e2['time'], e2['selected'], () {
                                          setState(() {
                                            listTimeSlot.forEach((key, value) {
                                              value.forEach((element) {
                                                element['selected'] = false;
                                              });
                                            });
                                            listTimeSlot[e1]![listTimeSlot[e1]!
                                                    .indexOf(e2)]['selected'] =
                                                !e2['selected'];

                                            if (listTimeSlot[e1]![
                                                listTimeSlot[e1]!
                                                    .indexOf(e2)]['selected']) {
                                              timeSlot = listTimeSlot[e1]![
                                                  listTimeSlot[e1]!
                                                      .indexOf(e2)]['time'];
                                              timeSlotSelected = true;
                                            } else {
                                              timeSlotSelected = false;
                                            }
                                          });
                                        })))
                                    .toList(),
                              )
                            ],
                          ))
                      .toList(),
                )
              ],
            ),
            // ValueListenableBuilder<List<LabBookingModel>>(
            //   valueListenable: _selectedEvents,
            //   builder: (context, value, _) {
            //     print('VALUE LISTENER BUILDER : $value');
            //     return ListView.builder(
            //       shrinkWrap: true,
            //       itemCount: value.length,
            //       itemBuilder: (context, index) {
            //         return Container(
            //           margin: const EdgeInsets.symmetric(
            //             horizontal: 12.0,
            //             vertical: 4.0,
            //           ),
            //           decoration: BoxDecoration(
            //             border: Border.all(),
            //             borderRadius: BorderRadius.circular(12.0),
            //           ),
            //           child: ListTile(
            //             onTap: () => print('${value[index]}'),
            //             title: Text('${value[index].slot}'),
            //           ),
            //         );
            //       },
            //     );
            //   },
            // ),
            LoginButtonWidget(
                onPressed: () async {
                  if (daySelected && timeSlotSelected && labRoomSelected) {
                    print(
                        'ROOM :$room, TIMESLOT: $timeSlot, DATE: ${_selectedDay.toString()}');

                    await DatabaseService()
                        .createLabBooking(LabBookingModel(
                            room: room,
                            slot: timeSlot,
                            date: _selectedDay,
                            userId: firebaseUser.displayName))
                        .catchError((e) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: Text(e.toString()),
                            );
                          });
                    });
                  }
                },
                child: changeNotifier.getViewState == ViewState.BUSY
                    ? const CircularProgressIndicator()
                    : const Text('Submit'))
          ],
        ),
      ),
    );
  }

  Container widgetLabRoom(Map<String, dynamic> e, Function() onTap) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: e['selected'] ? Colors.red : Colors.grey[200],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          elevation: 2.0,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                e['name'],
                style: TextStyle(
                    color: e['selected'] ? Colors.white : Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildChipSlot(String time, bool selected, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: selected ? Colors.red : Colors.grey[200],
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            time,
            style: TextStyle(color: selected ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
