import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double starSize;

  const RatingStars({super.key, required this.rating, this.starSize = 16});

  @override
  Widget build(BuildContext context) {
    int fullStars = rating.floor();
    bool halfStar = (rating - fullStars) >= 0.5;
    int emptyStars = 5 - fullStars - (halfStar ? 1 : 0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < fullStars; i++)
          Icon(Icons.star, color: Colors.amber, size: starSize),
        if (halfStar)
          Icon(Icons.star_half, color: Colors.amber, size: starSize),
        for (var i = 0; i < emptyStars; i++)
          Icon(Icons.star_border, color: Colors.amber, size: starSize),
      ],
    );
  }
}
