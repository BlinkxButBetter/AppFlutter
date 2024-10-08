import 'package:flutter/material.dart';
import 'dart:convert'; // For working with JSON
import 'package:carousel_slider/carousel_slider.dart'; // Carousel package
import 'add_product_dialog.dart'; // Ensure this file exists
import 'main.dart'; // Ensure this file exists

class HomePage extends StatefulWidget {
  final String username;

  HomePage({Key? key, required this.username}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String jsonData = '''
 {
  "hero": {
    "id": "64f1a5dcbcae4d1f9a3d9a1b",
    "Name": "MacBook Air M1",
    "Desc": "Apple MacBook Air with M1 chip, 8GB RAM, 256GB SSD, in excellent condition.",
    "CurPrice": 950.00,
    "preview": [
    "https://springbootbackend-6lib.onrender.com/images/get/6702c9c9aaff2a5a56b8a166/",
    "https://springbootbackend-6lib.onrender.com/images/get/6702c9c9aaff2a5a56b8a166/"
    ]
  },
  "Scroll Area": {
    "Books": [
      {
        "id": "64f1a5dcbcae4d1f9a3d9a2c",
        "Name": "Introduction to Algorithms",
        "Desc": "4th edition, used for CS courses. Slight wear and tear but good condition.",
        "CurPrice": 50.00,
        "preview": [
          "https://springbootbackend-6lib.onrender.com/images/get/6702c9c9aaff2a5a56b8a166/"
        ]
      },
      {
        "id": "64f1a5dcbcae4d1f9a3d9a2d",
        "Name": "Data Structures and Algorithms in Java",
        "Desc": "Hardcover, excellent condition, no marks or annotations.",
        "CurPrice": 45.00,
        "preview": [
          "https://springbootbackend-6lib.onrender.com/images/get/6702c9c9aaff2a5a56b8a166/"
        ]
      }
    ],
    "Stationary": [
      {
        "id": "64f1a5dcbcae4d1f9a3d9a3a",
        "Name": "Calculator - Casio FX-991EX",
        "Desc": "Scientific calculator used for exams, fully functional.",
        "CurPrice": 25.00,
        "preview": [
          "https://springbootbackend-6lib.onrender.com/images/get/6702c9c9aaff2a5a56b8a166/"
        ]
      },
      {
        "id": "64f1a5dcbcae4d1f9a3d9a3b",
        "Name": "A4 Notebooks - 5 Pack",
        "Desc": "Unused notebooks, great for taking notes during lectures.",
        "CurPrice": 10.00,
        "preview": [
          "https://springbootbackend-6lib.onrender.com/images/get/6702c9c9aaff2a5a56b8a166/"
        ]
      }
    ],
    "Electronics": [
      {
        "id": "64f1a5dcbcae4d1f9a3d9a4c",
        "Name": "Wireless Earbuds",
        "Desc": "Bluetooth earbuds with charging case, barely used.",
        "CurPrice": 40.00,
        "preview": [
          "https://springbootbackend-6lib.onrender.com/images/get/6702c9c9aaff2a5a56b8a166/"
        ]
      },
      {
        "id": "64f1a5dcbcae4d1f9a3d9a4d",
        "Name": "External Hard Drive - 1TB",
        "Desc": "Portable 1TB external drive, lightly used.",
        "CurPrice": 60.00,
        "preview": [
          "https://springbootbackend-6lib.onrender.com/images/get/6702c9c9aaff2a5a56b8a166/"
        ]
      }
    ]
  }
}
  ''';

  // Function to parse JSON data
  Map<String, dynamic> _parseJsonData() {
    return jsonDecode(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> jsonDataParsed = _parseJsonData();
    var heroProduct = jsonDataParsed['hero'];
    var scrollAreaData = jsonDataParsed['Scroll Area'];

    List<Map<String, dynamic>> categories = [
      {"name": "Books", "items": scrollAreaData["Books"]},
      {"name": "Stationary", "items": scrollAreaData["Stationary"]},
      {"name": "Electronics", "items": scrollAreaData["Electronics"]}
    ];

    List<String> carouselImages = [
      heroProduct['preview'][0],
      heroProduct['preview'][1]
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFCF3CF),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Welcome, ${widget.username}!',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            // Carousel for product images with titles
            CarouselSlider(
              options: CarouselOptions(
                height: 300.0,
                autoPlay: true,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
              ),
              items: carouselImages.map((imageUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: 250,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          heroProduct['Name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Categories with horizontal scrolling items
            for (var category in categories) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  category['name'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: category['items'].length,
                  itemBuilder: (context, index) {
                    var item = category['items'][index];
                    return Container(
                      width: 200,
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCF3CF),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                            child: Image.network(
                              item['preview'][0],
                              fit: BoxFit.cover,
                              height: 120,
                              width: double.infinity,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['Name'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '\$${item['CurPrice']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  item['Desc'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
     bottomNavigationBar: BottomAppBar(
  color: Colors.white,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      IconButton(
        icon: const Icon(Icons.home, color: Colors.black),
        onPressed: () {
          // Add your logic for Home button
        },
      ),
      IconButton(
        icon: const Icon(Icons.chat_bubble, color: Colors.black),
        onPressed: () {
          // Add your logic for Chat button
        },
      ),
      Container(
        width: 50,  // Adjust the width as needed
        height: 50, // Adjust the height as needed
        child: FloatingActionButton(
          backgroundColor: Colors.orange,
          child: const Icon(Icons.add),
          onPressed: () {
            // Show the add product dialog
            showDialog(
              context: context,
              builder: (context) => AddProductDialog(),
            );
          },
        ),
      ),
      IconButton(
        icon: const Icon(Icons.shopping_cart, color: Colors.black),
        onPressed: () {
          // Add your logic for Cart button
        },
      ),
      IconButton(
        icon: const Icon(Icons.logout, color: Colors.black),
        onPressed: () {
          // Add your logic for Sign Out button
        },
      ),
    ],
  ),
),

    );
  }
}
