import 'package:flutter/material.dart';
import 'package:flutter_maps/data/models/places_suggestions.dart';
import 'package:flutter_maps/shared/constants/colors.dart';

class PlacesItem extends StatelessWidget {
  final PlaceSuggestions place;

  const PlacesItem({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String subTitle = place.placeDescription
        .replaceAll(place.placeDescription.split(',')[0], '');
    return Container(
      width: double.infinity,
      margin: const EdgeInsetsDirectional.all(8.0),
      padding: const EdgeInsetsDirectional.all(4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        leading: Container(
          width: 40.0,
          height: 40.0,
          decoration: const BoxDecoration(
            color: MyColors.lightBlue,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.place,
            color: MyColors.blue,
          ),
        ),
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${place.placeDescription.split(',')[0]}\n',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              TextSpan(
                text: subTitle.substring(2),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
