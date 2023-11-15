
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animations/loading_animations.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: Get.height-50,
      child: Center(child: LoadingFlipping.circle(
      borderColor: Colors.cyan,
      borderSize: 3.0,
      size: 80.0,
      backgroundColor: Colors.cyanAccent,
      duration: const Duration(milliseconds: 500),
    ),),
    );
  }
}


class Nothing extends StatelessWidget {
  const Nothing({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("لا يوجد اي منتج",style: GoogleFonts.cairo(),),);
  }
}