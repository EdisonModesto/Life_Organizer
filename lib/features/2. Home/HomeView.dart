import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:go_router/go_router.dart';
import 'package:life_organizer/common/addEvent/addEventSheet.dart';
import 'package:life_organizer/common/addMarker/addMarkerDialog.dart';
import 'package:life_organizer/common/viewEvent/viewEvent.dart';
import 'package:life_organizer/constants/colors.dart';
import 'package:life_organizer/services/AuthService.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:intl/intl.dart' as intl;

import '../../viewmodels/EventsViewModel.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    var eventsData = ref.watch(eventsProvider);

    return Scaffold(
      body: eventsData.when(
        data: (data){

          var filteredEvents = data.docs.where((element) => element["StartDate"].toDate().day == _selectedDay.day && element["StartDate"].toDate().month == _selectedDay.month && element["StartDate"].toDate().year == _selectedDay.year).toList();
          filteredEvents.sort((a, b) => a["StartDate"].toDate().compareTo(b["StartDate"].toDate()));
          //print(filteredEvents.length);

          var upcomingEvents = data.docs.where((element) => element["StartDate"].toDate().isAfter(_selectedDay)).toList();
          upcomingEvents.sort((a, b) => a["StartDate"].toDate().compareTo(b["StartDate"].toDate()));

          return SafeArea(
              child: ColoredBox(
                color: AppColors().blueBg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        color:const Color.fromRGBO(255, 255, 255, 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TableCalendar(
                        onDayLongPressed: (date, date1){
                          print(date);
                          showDialog(context: context, builder: (builder){
                            return AddMarkerDialog(
                              date: date,
                            );
                          });
                        },
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2030, 3, 14),
                        focusedDay: DateTime.now(),
                        headerVisible:  true,
                        eventLoader: (day){
                          var filteredEvents2 = data.docs.where((element) => element["StartDate"].toDate().day == day.day && element["StartDate"].toDate().month == day.month && element["StartDate"].toDate().year == day.year).toList();
                          return filteredEvents2;
                        },
                        headerStyle: HeaderStyle(
                            titleTextStyle: GoogleFonts.poppins(
                              color: AppColors().dark2,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            headerPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                            formatButtonVisible: false,
                            formatButtonShowsNext: false,
                            leftChevronVisible: false,
                            rightChevronVisible: false
                        ),
                        daysOfWeekStyle: const DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                              color: Colors.black
                          ),
                          weekendStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        calendarStyle: CalendarStyle(
                          outsideDecoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          markerDecoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          defaultDecoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          weekendDecoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          selectedDecoration: BoxDecoration(
                            color: AppColors().lightGrey,
                            shape: BoxShape.rectangle,
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                          ),
                          todayDecoration: BoxDecoration(
                            color: AppColors().lightGrey,
                            shape: BoxShape.rectangle,
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay; // update `_focusedDay` here as well
                          });
                        },
                        calendarFormat: _calendarFormat,
                        onFormatChanged: (format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        children: [
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20,),
                                  Row(
                                    children: [
                                      Text(
                                        DateTime.now().day == _selectedDay.day && DateTime.now().month == _selectedDay.month && DateTime.now().year == _selectedDay.year ? "Today" : "${intl.DateFormat('EEEE').format(_selectedDay)}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          color: AppColors().dark2,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Text(
                                        "${intl.DateFormat('MMMM').format(_selectedDay)} ${_selectedDay.day}, ${_selectedDay.year}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          color: AppColors().dark,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: SizedBox(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: ListView.builder(
                                            itemCount: filteredEvents.length,
                                            itemBuilder: (context, index){
                                              return TimelineTile(
                                                isFirst: index == 0 ? true : false,
                                                alignment: TimelineAlign.start,
                                                endChild: InkWell(
                                                  onTap: (){
                                                    showMaterialModalBottomSheet(
                                                      context: context,
                                                      builder: (context) => ViewEventSheet(
                                                        event: filteredEvents[index],
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 75,
                                                    margin: const EdgeInsets.only(left: 20, bottom: 20),
                                                    decoration: BoxDecoration(
                                                      color: AppColors().pink,
                                                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                    ),
                                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12.5),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          "${filteredEvents[index]["EventName"]}",
                                                          style: GoogleFonts.poppins(
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                        Text(
                                                          "${filteredEvents[index]["StartDate"].toDate().hour}:${filteredEvents[index]["StartDate"].toDate().minute} - ${filteredEvents[index]["EndDate"].toDate().hour}:${filteredEvents[index]["EndDate"].toDate().minute}",
                                                          style: GoogleFonts.poppins(
                                                            fontSize: 14,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20,),
                                  Text(
                                    "Upcoming events",
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      color: AppColors().dark2,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: SizedBox(
                                      height: 175,
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: ListView.builder(
                                            itemCount: upcomingEvents.length,
                                            itemBuilder: (context, index){
                                              return ListTile(
                                                onTap: (){
                                                  showMaterialModalBottomSheet(
                                                    context: context,
                                                    builder: (context) => ViewEventSheet(
                                                      event: upcomingEvents[index],
                                                    ),
                                                  );
                                                },
                                                leading: Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: AppColors().pink,
                                                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                  ),
                                                ),
                                                title: Text(
                                                  upcomingEvents[index]["EventName"],
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    color: AppColors().dark2,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  upcomingEvents[index]["EventNote"],
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: AppColors().dark2,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20,),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              children: [
                                const SizedBox(height: 20,),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        AuthService().signOut();
                                        context.go("/auth");
                                      },
                                      child: Text(
                                        DateTime.now().day == _selectedDay.day && DateTime.now().month == _selectedDay.month && DateTime.now().year == _selectedDay.year ? "Today" : "${intl.DateFormat('EEEE').format(_selectedDay)}",

                                        //"Today" : "${intl.DateFormat('MMMM').format(_selectedDay)} ${_selectedDay.day}, ${_selectedDay.year}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          color: AppColors().dark2,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    Text(
                                      "${intl.DateFormat('MMMM').format(_selectedDay)} ${_selectedDay.day}, ${_selectedDay.year}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: AppColors().dark,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: DayView(
                                      events: List.generate(filteredEvents.length, (index){
                                      return FlutterWeekViewEvent(
                                          title: filteredEvents[index]["EventName"],
                                          description: filteredEvents[index]["EventNote"],
                                          start: filteredEvents[index]["StartDate"].toDate(),
                                          end: filteredEvents[index]["EndDate"].toDate(),
                                        );
                                      }),
                                      date: _selectedDay,
                                      hoursColumnStyle: HoursColumnStyle(
                                        color: AppColors().blueBg,
                                        textStyle: GoogleFonts.poppins(
                                          color: AppColors().dark2,
                                        ),
                                      ),
                                      style: DayViewStyle(
                                        backgroundColor: AppColors().blueBg,
                                        backgroundRulesColor: AppColors().blueBg,
                                        headerSize: 0,
                                        hourRowHeight: 60,
                                      )
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
          );
        },
        error: (error, stack){
          return Center(
            child: Text(
              error.toString(),
            ),
          );
        },
        loading: (){
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showMaterialModalBottomSheet(
            context: context,
            builder: (context) => const AddEventSheet(),
          );
        },
        backgroundColor: AppColors().darkBlue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
