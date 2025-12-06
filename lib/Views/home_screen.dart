import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/Views/home_screen.dart';
import 'package:pawpal/Views/login_screen.dart';
import 'package:pawpal/models/pet.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/Views/submit_pet_screen_new.dart';

class MainScreen extends StatefulWidget {
  final User? user;

  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainPageState();
}

class _MainPageState extends State<MainScreen> {
  List<Pet> listPets = [];
  String status = "Loading...";
  late double screenWidth, screenHeight;

  @override
  void initState() {
    super.initState();
    loadPets();
  }

  Future<void> loadPets() async {
    if (widget.user?.userId == null || widget.user?.userId == '0') {
      setState(() {
        status = "No submissions yet.";
        listPets = [];
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
          '${MyConfig.baseUrl}/api/pawpal/get_my_pets.php?userid=${widget.user?.userId}',
        ),
      );

      print('HTTP ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResponse = response.body;
        var resarray = jsonDecode(jsonResponse);

        if (resarray['status'] == 'success') {
          List<dynamic> petsData = resarray['data'] ?? [];
          if (petsData.isEmpty) {
            setState(() {
              status = "No submissions yet.";
              listPets = [];
            });
          } else {
            List<Pet> pets =
                petsData.map((pet) => Pet.fromJson(pet)).toList();
            setState(() {
              listPets = pets;
            });
          }
        } else {
          setState(() {
            status = resarray['message'] ?? "Failed to load pets";
            listPets = [];
          });
        }
      } else {
        setState(() {
          status = "Server error: ${response.statusCode}";
          listPets = [];
        });
      }
    } catch (e) {
      print('Error loading pets: $e');
      setState(() {
        status = "Error: $e";
        listPets = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if (screenWidth > 600) {
      screenWidth = 600;
    } else {
      screenWidth = screenWidth;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'), backgroundColor: Colors.pinkAccent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            icon: Icon(Icons.login),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: screenWidth,
          child: Column(
            children: [
              listPets.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.find_in_page_outlined, size: 64),
                            SizedBox(height: 12),
                            Text(
                              status,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: listPets.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // IMAGE
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      width:
                                          screenWidth * 0.28, // more responsive
                                      height:
                                          screenWidth *
                                          0.22, // balanced aspect ratio
                                      color: Colors.grey[200],
                                      child: Image.network(
                                        '${MyConfig.baseUrl}/pawpal/pet/pet_${listPets[index].petId}.png',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.broken_image,
                                                size: 60,
                                                color: Colors.grey,
                                              );
                                            },
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  // TEXT AREA
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // PETNAME
                                        Text(
                                          listPets[index].petName
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        const SizedBox(height: 4),

                                        // PETTYPE
                                        Text(
                                          listPets[index].petType
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        const SizedBox(height: 6),
                                        
                                        //CATEGORY
                                        Text(
                                          listPets[index].petCategory
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        const SizedBox(height: 6),

                                        //DESCRIPTION
                                        Text(
                                          listPets[index].petDesc
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        const SizedBox(height: 6),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Action for the button
          if (widget.user?.userId == '0') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Please login first/or register first"),
                backgroundColor: Colors.red,
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          } else {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubmitPetScreen(user: widget.user),
              ),
            );
            setState(() {}); 
          }
        },
        child: Icon(Icons.add),
      ),
      //drawer: MyDrawer(user: widget.user),
    );
  }



  Future<User> getPetOwnerDetails(int index) async {
    String ownerid = listPets[index].userId.toString();
    User owner = User();
    try {
      final response = await http.get(
        Uri.parse(
          '${MyConfig.baseUrl}/api/pawpal/get_my_pets.php?userid=$ownerid',
        ),
      );
      if (response.statusCode == 200) {
        var jsonResponse = response.body;
        var resarray = jsonDecode(jsonResponse);
        if (resarray['status'] == 'success') {
          owner = User.fromJson(resarray['data'][0]);
        }
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
    return owner;
  }
}