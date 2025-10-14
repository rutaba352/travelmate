import 'package:flutter/material.dart';

class HotelList extends StatelessWidget{
  const HotelList({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hotel List"),
      ),
      body: const Center(
        child: Text(
            "Hotel List UI coming soon"
        ),
      ),
    );
  }
}