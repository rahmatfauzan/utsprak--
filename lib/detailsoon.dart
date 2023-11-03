import 'package:flutter/material.dart';
import 'package:utsprak/datasoon.dart';

class DetailSoon extends StatelessWidget {
  const DetailSoon({super.key, required this.dataSoon});
  final ComingSoon dataSoon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFF393434),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4F88F7),
        title: Text(dataSoon.name), 
      ),
      resizeToAvoidBottomInset: false, // set it to false
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(dataSoon.poster,
                  width: 500.0,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 10),
                Text(dataSoon.name,
                  style:const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                      fontSize: 18),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.book),
                        Text(dataSoon.genre),
                      ],
                    ),
                    Column(
                      children:[
                        const Icon(Icons.access_time_outlined),
                        Text(dataSoon.durasi)
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(dataSoon.desc,
                  style:const TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                      fontSize: 12),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // action to perform when button is pressed
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return const Color(0xFFA1C5EF); //warna pas ditekan
                        }
                        return const Color(0xFF233269);//warna default
                      },
                    ),
                    fixedSize: MaterialStateProperty.all(Size(300, 50)),
                  ),
                  child: const Text('Buy Now',
                    style:TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                        fontSize: 12
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}
