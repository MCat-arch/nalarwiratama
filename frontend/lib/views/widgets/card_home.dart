import 'package:flutter/material.dart';

class CardHome extends StatelessWidget {
  const CardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      shadowColor: Colors.black,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: const Color.fromARGB(255, 248, 248, 248),
      child: Column(
        children: [
          SizedBox(height: 10, width: double.infinity),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image(
                height: 200,
                width: double.infinity,
                image: AssetImage(
                  '/images/home_card.png',
                ), // Replace with your image URL
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
          SizedBox(height: 10, width: double.infinity),
          Text(
            'Title',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 16, 16, 16),
            ),
          ),
          Text(
            'Description',
            style: TextStyle(
              fontSize: 16,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: (Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                TextButton(onPressed: () {}, child: Text('Progress')),
                Padding(padding: EdgeInsets.only(left: 10)),
                FilledButton(
                  child: Text('Start', style: TextStyle(color: Colors.white)),
                  onPressed: () {},
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
