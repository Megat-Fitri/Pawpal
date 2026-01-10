import 'dart:convert';
import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/donation.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/shared/animated_route.dart';
import 'package:pawpal/Views/login_screen.dart';
import 'package:pawpal/shared/mydrawer.dart';

class MyDonationScreen extends StatefulWidget {
  final User? user;
  const MyDonationScreen({super.key, required this.user});

  @override
  State<MyDonationScreen> createState() => _MyDonationScreenState();
}

class _MyDonationScreenState extends State<MyDonationScreen> {
  List<Donation> donationList = [];
  late double screenWidth, screenHeight;
  String status = "Loading...";

  void initState() {
    super.initState();
    loadHistory();
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
        title: Text(
          'My Donation List',
        ),
        backgroundColor: Colors.pinkAccent,
        actions: [
          IconButton(
            onPressed: () {
              loadHistory();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: widget.user!.userId.toString() == '0'
          ? buildNotLoggedInState(context)
          : Center(
              child: SizedBox(
                width: screenWidth,
                child: Column(
                  children: [
                    Expanded(
                      child: donationList.isEmpty
                          ? _buildEmptyState()
                          : _buildPetList(),
                    ),
                  ],
                ),
              ),
            ),
      drawer: MyDrawer(user: widget.user),
    );
  }

  Widget buildNotLoggedInState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with soft shadow
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.lock_outline,
                size: 64,
                color: Color(0xFF1F3C88),
              ),
            ),

            const SizedBox(height: 24),

            // Title
            const Text(
              "You're Not Logged In",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 12),

            // Subtitle
            Text(
              "Login to access Donation History.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 32),

            // Action button
            SizedBox(
              width: 220,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F3C88),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                ),
                icon: const Icon(Icons.login, size: 20),
                label: const Text(
                  "Login",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    AnimatedRoute.slideFromRight(const LoginScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetList() {
    return ListView.builder(
      itemCount: donationList.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: const Color.fromRGBO(230, 234, 239, 1),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: screenWidth * 0.28, // more responsive
                      height: screenWidth * 0.22, // balanced aspect ratio
                      color: Colors.grey[200],
                      child: Image.network(
                        // path to retrieve image from server
                        '${MyConfig.baseUrl}/pawpal/${donationList[index].imagesPath[0]}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LEFT CONTENT
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 6),

                              Text(
                                "Pet ID: ${donationList[index].petId}",
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 4),

                              Text(
                                "Pet Name: ${donationList[index].petName}",
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 4),

                              Text(
                                "Donation Type: ${donationList[index].donationType}",
                                style: const TextStyle(fontSize: 15),
                              ),

                              const SizedBox(height: 6),

                              if (donationList[index].donationType != "Money")
                                Text(
                                  "Description: ${donationList[index].description}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),

                              const SizedBox(height: 6),

                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      donationList[index].createdAt.toString(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // RIGHT AMOUNT
                        if (donationList[index].donationType == "Money")
                          SizedBox(
                            width: 90, // adjust ikut UI
                            height: 90,
                            child: Center(
                              child: Text(
                                "- RM ${donationList[index].amount}",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.find_in_page_outlined, size: 64),
          const SizedBox(height: 12),
          Text(
            status,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  void loadHistory() {
    donationList.clear();
    setState(() {
      status = "Loading...";
    });

    http
        .get(
          Uri.parse(
            '${MyConfig.baseUrl}/pawpal/API/load_history.php?userid=${widget.user?.userId}',
          ),
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            log(response.body);
            if (resarray['status'] == 'success') {
              for (var item in resarray['data']) {
                Donation donation = Donation.fromJson(item);
                donationList.add(donation);
              }
              setState(() {
                status = "History";
              });
            } else {
              setState(() {
                donationList.clear();
                status = "No history available";
              });
            }
          }
        });
  }
}