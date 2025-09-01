import 'package:flutter/material.dart';

class DynamicAppBar extends AppBar {
  DynamicAppBar({
    super.key,
    required Color start,
    required bool showTitle,
    required String title,
  }) : super(
         backgroundColor: start,
         elevation: 10,
         toolbarHeight: 50,
         leading: const BackButton(color: Colors.white),
         actions: [
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 8.0),
             child: IconButton(
               icon: const Icon(Icons.favorite_border, color: Colors.white),
               onPressed: () {},
             ),
           ),
         ],
         title: showTitle
             ? Text(
                 title,
                 style: const TextStyle(
                   color: Colors.white,
                   fontSize: 20,
                   fontWeight: FontWeight.bold,
                 ),
                 maxLines: 1,
                 overflow: TextOverflow.ellipsis,
               )
             : const SizedBox.shrink(),
       );
}
