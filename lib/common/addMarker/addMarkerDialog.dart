import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:life_organizer/constants/markers.dart';
import 'package:life_organizer/services/FirestoreService.dart';

import '../../constants/colors.dart';

class AddMarkerDialog extends ConsumerStatefulWidget {
  const AddMarkerDialog({
    Key? key,
    required this.date,
  }) : super(key: key);

  final DateTime date;

  @override
  ConsumerState createState() => _AddMarkerDialogState();
}

class _AddMarkerDialogState extends ConsumerState<AddMarkerDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 500,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Add Marker",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10,),
                Expanded(
                  child: ListView.separated(
                    itemCount: markers.length,
                    separatorBuilder: (context, index){
                      return const SizedBox(height: 10,);
                    },
                    itemBuilder: (context, index){
                      return Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                color: AppColors().pink,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    markers[index],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                            onPressed: (){
                              FirestoreService().addRecord(widget.date, widget.date.add(Duration(hours: 1)), markers[index], markers[index], []);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors().pink,
                              fixedSize: const Size(55, 55),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Icon(Icons.add, color: Colors.white),
                          )
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}
