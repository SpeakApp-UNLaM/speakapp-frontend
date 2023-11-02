import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TurnsView extends StatefulWidget {
  static const String name = 'messages';
  const TurnsView({super.key});

  @override
  State<TurnsView> createState() => _TurnsView();
}

class _TurnsView extends State<TurnsView> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SfCalendar(
          view: CalendarView.month,
          dataSource: MeetingDataSource(getAppointments(context)),
          monthViewSettings: const MonthViewSettings(showAgenda: true),
        ) /*const ChatPage(),*/
        /*
       Center(
        child: Column(
          children: [
            Text("COMING SOON - NOVIEMBRE 2023",
                style: Theme.of(context).textTheme.headlineMedium),
            Lottie.asset(
              'assets/animations/congrats.json',
              controller: _controller,
              onLoaded: (composition) {
                // Configure the AnimationController with the duration of the
                // Lottie file and start the animation.
                _controller
                  ..duration = composition.duration
                  ..forward();
              },
            ),
          ],
        ),
      ),*/
        );
  }
}

List<Appointment> getAppointments(BuildContext context) {
  List<Appointment> meetings = <Appointment>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));

  meetings.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: 'Turno',
      color: Theme.of(context).primaryColor));

  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
