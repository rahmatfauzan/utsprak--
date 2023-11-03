import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utsprak/detailsoon.dart';
import 'package:utsprak/model/dataclass.dart';
import 'datasoon.dart';
import 'list.dart';
import 'datamovie.dart';
import 'detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //ngilangin appbar
        elevation: 0,
        toolbarHeight: 0,
        //ngubah warna status bar
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFF4F88F7),
        ),
      ),
      body:
      Container(
          padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Halo",
                style:TextStyle(
                    color: Color(0xFF393434),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                    fontSize: 28),
              ),
              const Text("Mau nonton apa hari ini?",
                style:TextStyle(
                    color: Color(0xFF393434),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                    fontSize: 16),
              ),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Database.getData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            const Color.fromARGB(115, 206, 43, 43),
                          ),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      // Filter items based on 'kategori' here (assuming it's a field in your data).
                      List<DocumentSnapshot> items = snapshot.data!.docs
                          .where((mv) => mv["kategori"] == "soon")
                          .toList();

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: items
                            .length, // Set the itemCount to the filtered items.
                        itemBuilder: (context, index) {
                          DocumentSnapshot mv = items[index];
                          String lvnama = mv["nama"];
                          String lvposter = mv["banner"];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Detail(nama: lvnama),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Image.network(
                                  lvposter,
                                  width: 320.0,
                                  height: 200.0,
                                  fit: BoxFit.fill,
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          const Color.fromARGB(115, 206, 43, 43),
                        ),
                      ),
                    );
                  },
                ),
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text("Now Showing",
                    style: TextStyle(
                        color: Color(0xFF393434),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                        fontSize: 16),
                  ),
                  //biar bisa dipush pas teks ditekan
                  // GestureDetector(
                  //   child: const Text("See All",
                  //     style: TextStyle(
                  //         color: Color(0xFF4F88F7),
                  //         fontWeight: FontWeight.bold,
                  //         fontFamily: 'OpenSans',
                  //         fontSize: 12),
                  //   ),
                  //     onTap: (){
                  //       Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const ListMovie()));
                  //     },
                  // )
                ],
              ),

              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: Database.getData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                const Color.fromARGB(115, 206, 43, 43),
                              ),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          // Filter items based on 'kategori' here (assuming it's a field in your data).
                          List<DocumentSnapshot> items = snapshot.data!.docs
                              .where((mv) => mv["kategori"] == "now")
                              .toList();

                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: items
                                .length, // Set the itemCount to the filtered items.
                            itemBuilder: (context, index) {
                              DocumentSnapshot mv = items[index];
                              String lvnama = mv["nama"];
                              String lvposter = mv["poster"];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Detail(nama: lvnama),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Image.network(
                                      lvposter,
                                      width: 150.0,
                                      height: 220.0,
                                      fit: BoxFit.fill,
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  const Color.fromARGB(115, 206, 43, 43))),
                        );
                      })),

            ],
          )
      ),
    );

  }
}
