import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomeSlider extends StatelessWidget {
  const HomeSlider({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, info) 
    {
      if(Get.width>768){
        return CarouselSlider(
        items: children,
        options: CarouselOptions(
          height:Get.width>1230?Get.height*.95: Get.height*.7,
          aspectRatio: 16 / 9,
          viewportFraction: 0.99,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 10),
          autoPlayAnimationDuration: const Duration(milliseconds: 1000),
          autoPlayCurve: Curves.easeInOutCirc,
          enlargeCenterPage: true,
          enlargeFactor: 0.3,
          scrollDirection: Axis.horizontal,
        ));
}else{
  return CarouselSlider(
        items: children,
        options: CarouselOptions(
          height: Get.height*.45,
          aspectRatio: 16 / 9,
          viewportFraction: .99,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          enlargeFactor: 0.3,
          scrollDirection: Axis.horizontal,
        ));
  }
    });
  }
}
