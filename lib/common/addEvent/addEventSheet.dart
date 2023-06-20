import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:life_organizer/constants/colors.dart';
import 'package:life_organizer/services/FirestoreService.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:uuid/uuid.dart';

import '../../services/CloudService.dart';
import '../../services/FilePickerService.dart';

class AddEventSheet extends ConsumerStatefulWidget {
  const AddEventSheet({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AddEventSheetState();
}

class _AddEventSheetState extends ConsumerState<AddEventSheet> {

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController noteCtrl = TextEditingController();

  var key = GlobalKey<FormState>();
  List<String> url = [];

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Form(
        key: key,
        child: Column(
          children: [
            Expanded(
              flex: 12,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 50, bottom: 20, left: 40, right: 40),
                decoration: BoxDecoration(
                  color: AppColors().darkBlue,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "New Event",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15,),
                    SizedBox(
                      height: 50,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: nameCtrl,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '';
                          }
                          return null;
                        },
                        style: const TextStyle(
                            fontSize: 14,
                          color: Colors.white,

                        ),
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(height: 0),
                          label: Text(
                            "Name of Event",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1.0,
                            ),
                          ),

                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Row(
                      children: [
                        Text(
                          "Start Date: ",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () async {
                            startDate = (await showOmniDateTimePicker(
                              context: context,
                              initialDate: startDate,
                              firstDate:
                              DateTime(1600).subtract(const Duration(days: 3652)),
                              lastDate: DateTime.now().add(
                                const Duration(days: 3652),
                              ),
                              is24HourMode: false,
                              isShowSeconds: false,
                              minutesInterval: 1,
                              secondsInterval: 1,
                              borderRadius: const BorderRadius.all(Radius.circular(16)),
                              constraints: const BoxConstraints(
                                maxWidth: 350,
                                maxHeight: 650,
                              ),
                              transitionBuilder: (context, anim1, anim2, child) {
                                return FadeTransition(
                                  opacity: anim1.drive(
                                    Tween(
                                      begin: 0,
                                      end: 1,
                                    ),
                                  ),
                                  child: child,
                                );
                              },
                              transitionDuration: const Duration(milliseconds: 200),
                              barrierDismissible: true,
                              selectableDayPredicate: (dateTime) {
                                // Disable 25th Feb 2023
                                if (dateTime == DateTime(2023, 2, 25)) {
                                  return false;
                                } else {
                                  return true;
                                }
                              },
                            ))!;
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "${startDate.day}/${startDate.month}/${startDate.year}",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 5,),
                    Row(
                      children: [
                        Text(
                          "End Date: ",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () async {
                            endDate = (await showOmniDateTimePicker(
                              context: context,
                              initialDate: endDate,
                              firstDate:
                              DateTime(1600).subtract(const Duration(days: 3652)),
                              lastDate: DateTime.now().add(
                                const Duration(days: 3652),
                              ),
                              is24HourMode: false,
                              isShowSeconds: false,
                              minutesInterval: 1,
                              secondsInterval: 1,
                              borderRadius: const BorderRadius.all(Radius.circular(16)),
                              constraints: const BoxConstraints(
                                maxWidth: 350,
                                maxHeight: 650,
                              ),
                              transitionBuilder: (context, anim1, anim2, child) {
                                return FadeTransition(
                                  opacity: anim1.drive(
                                    Tween(
                                      begin: 0,
                                      end: 1,
                                    ),
                                  ),
                                  child: child,
                                );
                              },
                              transitionDuration: const Duration(milliseconds: 200),
                              barrierDismissible: true,
                              selectableDayPredicate: (dateTime) {
                                // Disable 25th Feb 2023
                                if (dateTime == DateTime(2023, 2, 25)) {
                                  return false;
                                } else {
                                  return true;
                                }
                              },
                            ))!;
                            setState(() {});

                          },
                          icon: const Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "${endDate.day}/${endDate.month}/${endDate.year}",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15,),

                  ],
                ),
              ),
            ),
            Expanded(
              flex: 15,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 20, bottom: 20, left: 40, right: 40),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Notes",
                        style: GoogleFonts.poppins(
                          color: AppColors().darkBlue,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: noteCtrl,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '';
                          }
                          return null;
                        },
                        style: const TextStyle(
                            fontSize: 14
                        ),
                        maxLines: 4,
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(height: 0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide: BorderSide(
                              color: AppColors().darkBlue,
                              width: 1.0,
                            ),
                          ),

                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide: BorderSide(
                              color: AppColors().darkBlue,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      url.isNotEmpty ?
                      GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        padding: const EdgeInsets.all(0),
                        children: List.generate(url.length, (index){
                          return Stack(
                            children: [
                              Image.network(
                                url[index],
                                fit: BoxFit.cover,
                              ),
                              Align(
                                  alignment: Alignment.topRight,
                                  child: Transform.translate(
                                    offset: const Offset(8, -8),
                                    child: InkWell(
                                      onTap: (){
                                        url.removeAt(index);
                                        setState(() {});
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  )
                              )
                            ],
                          );
                        }),
                      ) : const SizedBox(),
                      const SizedBox(height: 10,),

                      ElevatedButton(
                        onPressed: () async {
                          var image = await FilePickerService().pickPhoto();

                          if (image != null) {
                            var uuid = const Uuid();
                            var id = uuid.v4();

                            url.add(await CloudService().uploadFile(id, image));
                            setState(() {});

                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: AppColors().darkBlue),
                          ),
                          fixedSize: Size(MediaQuery.of(context).size.width, 50),
                        ),
                        child: Text(
                          "Upload Image",
                          style: GoogleFonts.poppins(
                            color: AppColors().darkBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      ElevatedButton(
                        onPressed: () async {
                          if (key.currentState!.validate()){
                            FirestoreService().addRecord(
                                startDate,
                                endDate,
                                nameCtrl.text,
                                noteCtrl.text,
                                url
                            );
                            await AwesomeNotifications().createNotification(
                                content: NotificationContent(
                                  id: 1,
                                  channelKey: 'scheduled',
                                  title: nameCtrl.text,
                                  body: noteCtrl.text,
                                  wakeUpScreen: true,
                                  category: NotificationCategory.Reminder,
                                  notificationLayout: NotificationLayout.Default,
                                  //bigPicture: 'asset://assets/images/delivery.jpeg',
                                  payload: {'uuid': 'uuid-test'},
                                  autoDismissible: false,
                                ),
                                schedule: NotificationCalendar.fromDate(date: startDate));
                            Navigator.pop(context);
                          } else {
                            Fluttertoast.showToast(msg: "Please fill all fields and add Photos");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors().darkBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          fixedSize: Size(MediaQuery.of(context).size.width, 50),
                        ),
                        child: Text(
                          "Create Event",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )

                    ],
                  ),
                ),
              ),

            )
          ],
        ),
      ),
    );
  }
}
