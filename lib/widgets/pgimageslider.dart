import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
class PGImageSlider extends StatelessWidget {
  final List<String> images;
  const PGImageSlider({super.key, required this.images});
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: images.map((imgPath) {
        return ClipRRect(
          child: imgPath.isEmpty
              ? Image.asset(
                  'assets/images/pg_01.jpg',
                  width: double.infinity,
                  height: 210,
                  fit: BoxFit.fill,
                )
              : Image.network(
                  imgPath,
                  width: double.infinity,
                  height: 210,
                  fit: BoxFit.fill,
                ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 280,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 1500),
        viewportFraction: 0.99,
      ),
    );
  }
}

