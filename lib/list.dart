import 'package:flutter/material.dart';
import 'datamovie.dart';
import 'detail.dart';

class ListMovie extends StatelessWidget {
  const ListMovie({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF233269),
        appBar: AppBar(
          backgroundColor: const Color(0xFF4F88F7),
          title: const Text("Now Showing"),
        ),
        body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: dataMovie.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                      // onTap: () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) =>
                      //           Detail(dataMovie: dataMovie[index]),
                      //     ),
                      //   );
                      // },
                               child: Card(
                                 elevation: 3.0,
                                 margin: const EdgeInsets.symmetric(vertical: 3),
                                   child: Row(
                                    children: [
                                      Image.asset(dataMovie[index].poster,
                                        width: 80.0,
                                        height : 120.0,
                                        fit: BoxFit.fill,
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            dataMovie[index].name,
                                            style:const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'OpenSans',
                                                fontSize: 12),
                                          ),
                                          Text(
                                            dataMovie[index].genre,
                                            style:const TextStyle(
                                                color: Color(0xFF3B51A2),
                                                fontFamily: 'OpenSans',
                                                fontSize: 10),
                                          ),
                                          Text(
                                            dataMovie[index].durasi,
                                            style:const TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'OpenSans',
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                    ]
                            )
                              ),
                              //)   Card
                            );
                          }
                      )),
                    ]
                  )
    );
  }
}
