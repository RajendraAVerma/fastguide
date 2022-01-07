import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fastguide/app/widgets/slidder_depart/slidder_image_model.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageSlidder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    void _launchURL({required String url}) async => await canLaunch(url)
        ? await launch(url)
        : throw 'Could not launch $url';
    return StreamBuilder<List<SlidderModel>>(
      stream: database.slidders(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final imageLink = snapshot.data;
          return Container(
              child: CarouselSlider(
            options: CarouselOptions(
              //height: 300,
              aspectRatio: 16 / 9,
              viewportFraction: 0.9,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
            items: imageLink!
                .map((item) => GestureDetector(
                      onTap: () => _launchURL(
                        url: item.link,
                      ),
                      child: Container(
                        child: Center(
                            child: Image.network(item.imageLink,
                                fit: BoxFit.cover, width: 1000)),
                      ),
                    ))
                .toList(),
          ));
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
