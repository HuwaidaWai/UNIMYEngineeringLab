import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:smart_engineering_lab/constant/color_constant.dart';
import 'package:smart_engineering_lab/model/swiper_model.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  List<SwiperModel> swiperModels = [
    SwiperModel(
        pathImage: 'assets/img1.png',
        title: 'Smart Engineering Lab',
        description:
            'Enhancing lecture and student experience in our engineering lab'),
    SwiperModel(
        pathImage: 'assets/img2.png',
        title: 'Lab Module & Report',
        description:
            'Instantly submit your lab module and report for all your experiments through here!'),
    SwiperModel(
        pathImage: 'assets/img3.png',
        title: 'Lab Booking System & Automated Attendance',
        description:
            'You can book your own lab slot here and take your attendance automatically!')
  ];
  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 36.0),
      child: SizedBox(
        // height: height * 0.6,
        child: Swiper(
          axisDirection: AxisDirection.left,
          itemCount: swiperModels.length,

          itemBuilder: (context, index) {
            return Column(
              children: [
                Image.asset(swiperModels[index].pathImage),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    swiperModels[index].title,
                    style: titleStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    swiperModels[index].description,
                    style: subtitleStyle2Small,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            );
          },

          pagination: const SwiperPagination(
            margin: EdgeInsets.only(bottom: 2.0),
            builder: DotSwiperPaginationBuilder(
                color: Colors.grey, activeColor: Colors.red),
          ),
          // control: const SwiperControl(),
        ),
      ),
    );
  }
}
