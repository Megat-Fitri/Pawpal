// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/pet.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/shared/animated_route.dart';
import 'package:pawpal/Views/login_screen.dart';
import 'package:pawpal/shared/mydrawer.dart';

class DonationScreen extends StatefulWidget {
  User? user;
  DonationScreen({super.key, required this.user});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  List<Pet> petList = [];
  String status = "Loading...";
  late double screenWidth, screenHeight;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    loadDonationPets();
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
          'Donation',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pinkAccent,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              loadDonationPets();
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
                      child: petList.isEmpty
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
              "Login to access donation requests.",
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
    return Column(
      children: [
        if (widget.user == null || widget.user!.userId == "0")
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.red.shade200,
            child: const Center(
              child: Text(
                "You are not logged in. Please login to donate pets.",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade300, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Wallet Balance',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'RM ${widget.user?.points}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // Buy Credit button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F3C88),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.add, size: 18, color: Colors.white),
                    label: const Text(
                      "Buy",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      showReloadWalletDialog();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Hint Text
              Text(
                "Credits are used for pet donation",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),

        Expanded(
          child: petList.isEmpty
              ? Center(
                  child: Text(
                    "No pets available",
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                  ),
                )
              : ListView.builder(
                  itemCount: petList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: const Color.fromRGBO(230, 234, 239, 1),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => showDetailsDialog(index),
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
                                  height:
                                      screenWidth *
                                      0.28, // balanced aspect ratio
                                  color: Colors.grey[200],
                                  child: Image.network(
                                    // path to retrieve image from server
                                    '${MyConfig.baseUrl}/pawpal/${petList[index].image_paths[0]}',
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

                              const SizedBox(width: 14),

                              // TEXT AREA
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // TITLE
                                    Text(
                                      petList[index].petName.toString(),
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    const SizedBox(height: 6),

                                    // DESCRIPTION
                                    Text(
                                      petList[index].petDesc.toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    const SizedBox(height: 10),

                                    Row(
                                      children: [
                                        // Category Badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.15,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            petList[index].petCategory.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color.fromARGB(
                                                255,
                                                1,
                                                1,
                                                1,
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 10),

                                        // Pet Type Badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.15,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            petList[index].petType.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.15,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            "Age: ${petList[index].petAge}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 6),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                  255,
                                                  152,
                                                  182,
                                                  212,
                                                ),
                                            foregroundColor:
                                                const Color.fromARGB(
                                                  255,
                                                  255,
                                                  255,
                                                  255,
                                                ),

                                            minimumSize: Size(20, 40),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),

                                          onPressed: () {
                                            showDonationDialog(
                                              petList[index].petId,
                                            );
                                          },

                                          child: Text(
                                            'Donation',
                                            style: TextStyle(
                                              color: const Color.fromARGB(
                                                255,
                                                5,
                                                5,
                                                5,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
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

  void loadDonationPets({int page = 1}) {
    petList.clear();
    setState(() {
      status = "Loading...";
    });

    // Build query string with both parameters
    final uri = Uri.parse('${MyConfig.baseUrl}/api/pawpal/get_my_donation.php');

    http.get(uri).then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success' &&
            jsonResponse['data'] != null &&
            jsonResponse['data'].isNotEmpty) {
          petList.clear();
          for (var item in jsonResponse['data']) {
            petList.add(Pet.fromJson(item));
          }
          setState(() {
            status = "";
          });
        } else {
          setState(() {
            petList.clear();
            status = "No donation requests available";
          });
        }
      } else {
        setState(() {
          petList.clear();
          status = "Failed to load list of pets";
        });
      }
    });
  }

  void showDetailsDialog(int index) {
    final pets = petList[index];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.6,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                controller: controller,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // DRAG HANDLE
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: Stack(
                        // children: [
                        //   CarouselSlider(
                        //     items: petList[index].image_paths.map((img) {
                        //       return ClipRRect(
                        //         borderRadius: BorderRadius.circular(14),
                        //         child: Image.network(
                        //           '${MyConfig.baseUrl}/pawpal/$img',
                        //           fit: BoxFit.cover,
                        //           width: double.infinity,
                        //         ),
                        //       );
                        //     }).toList(),
                        //     options: CarouselOptions(
                        //       height: 200,
                        //       enlargeCenterPage: true,
                        //       autoPlay: false,
                        //       onPageChanged: (i, reason) {
                        //         setState(() => currentIndex = i);
                        //       },
                        //     ),
                        //   ),
                        //   Positioned(
                        //     bottom: 10,
                        //     right: 12,
                        //     child: Container(
                        //       padding: const EdgeInsets.symmetric(
                        //         horizontal: 8,
                        //         vertical: 4,
                        //       ),
                        //       decoration: BoxDecoration(
                        //         color: Colors.black.withOpacity(0.5),
                        //         borderRadius: BorderRadius.circular(8),
                        //       ),
                        //       child: Text(
                        //         "${currentIndex + 1}/${petList[index].image_paths.length}",
                        //         style: const TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 12,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // TITLE
                    Text(
                      pets.petName.toString(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // DISTRICT + RATE
                    Row(
                      children: [
                        _chip(Icons.category, pets.petCategory.toString()),
                        const SizedBox(width: 8),
                        _chip(Icons.pets, pets.petType.toString()),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // DESCRIPTION
                    Text(
                      pets.petDesc.toString(),
                      style: const TextStyle(fontSize: 15),
                    ),

                    const SizedBox(height: 20),

                    const Divider(),

                    // INFO SECTION
                    _infoRow("Pet Type", pets.petType),
                    _infoRow("Provider", pets.petName),
                    _infoRow("Phone", pets.userPhone),
                    _infoRow("Email", pets.userEmail),
                    _infoRow("Age", pets.petAge),
                    _infoRow("Health", pets.petHealth),
                    _infoRow("Gender", pets.petGender),

                    const SizedBox(height: 20),

                    // // CONTACT ACTIONS
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     _actionIcon(
                    //       Icons.call,
                    //       () => launchUrl(
                    //         Uri.parse('tel:${pets.phone}'),
                    //         mode: LaunchMode.externalApplication,
                    //       ),
                    //     ),
                    //     _actionIcon(
                    //       Icons.message,
                    //       () => launchUrl(
                    //         Uri.parse('sms:${pets.phone}'),
                    //         mode: LaunchMode.externalApplication,
                    //       ),
                    //     ),
                    //     _actionIcon(
                    //       Icons.email,
                    //       () => launchUrl(
                    //         Uri.parse('mailto:${pets.email}'),
                    //         mode: LaunchMode.externalApplication,
                    //       ),
                    //     ),
                    //     _actionIcon(
                    //       Icons.wechat,
                    //       () => launchUrl(
                    //         Uri.parse('https://wa.me/${pets.phone}'),
                    //         mode: LaunchMode.externalApplication,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.blueGrey),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(child: Text(value ?? "-")),
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon, VoidCallback onTap) {
    return InkResponse(
      onTap: onTap,
      radius: 28,
      child: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.blueGrey.withValues(alpha: 0.15),
        child: Icon(icon, color: Colors.blueGrey),
      ),
    );
  }

  void loadProfile() {
    http
        .get(
          Uri.parse(
            '${MyConfig.baseUrl}/api/pawpal/get_user_details.php?userid=${widget.user?.userId}',
          ),
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            log(response.body);
            if (resarray['status'] == 'success') {
              //print(resarray['data'][0]);
              User user = User.fromJson(resarray['data'][0]);
              widget.user = user;
              setState(() {});
            }
          }
          // Handle successful login here
        });
  }

  void showReloadWalletDialog() {
    int selectedAmount = 10;

    final Map<int, double> topUpPriceMap = {
      5: 5.0,
      10: 10.0,
      15: 15.0,
      20: 20.0,
      30: 30.0,
      40: 40.0,
      50: 50.0,
      100: 100.0,
    };

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: const [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Color(0xFF1F3C88),
                  ),
                  SizedBox(width: 8),
                  Text("Reload Wallet"),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select a top-up package",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),

                  // DROPDOWN
                  DropdownButtonFormField<int>(
                    initialValue: selectedAmount,
                    decoration: InputDecoration(
                      labelText: "Top-up Amount",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: topUpPriceMap.keys.map((topup) {
                      return DropdownMenuItem<int>(
                        value: topup,
                        child: Text("$topup topup"),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedAmount = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // PRICE DISPLAY
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Text("Total:", style: TextStyle(fontSize: 15)),
                        const Spacer(),
                        Text(
                          "RM ${topUpPriceMap[selectedAmount]!.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F3C88),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: const Color(0xFF1F3C88),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //   ),
                //   onPressed: () async {
                //     Navigator.pop(context);
                //     if (widget.user != null) {
                //       await Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (_) => PaymentScreen(
                //             user: widget.user!,
                //             wallet: selectedAmount,
                //           ),
                //         ),
                //       );
                //     }
                //     loadProfile();
                //   },
                //   child: const Text(
                //     "Continue",
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
              ],
            );
          },
        );
      },
    );
  }

  void showDonationDialog(String? petId) {
    String donationType = "Money"; // default
    TextEditingController descController = TextEditingController();
    TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text("Make a Donation"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Donation type dropdown
                  DropdownButtonFormField<String>(
                    value: donationType,
                    decoration: InputDecoration(
                      labelText: "Donation Type",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: ["Money", "Food", "Medical"].map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        donationType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Amount field for Money
                  if (donationType == "Money")
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Amount (RM)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                  // Description field for Food / Medical
                  if (donationType != "Money")
                    TextField(
                      controller: descController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F3C88),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);

                    // Handle donation based on type
                    if (donationType == "Money") {
                      int amount = int.tryParse(amountController.text) ?? 0;
                      if (amount <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Enter a valid amount"),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                        return;
                      }
                      // Call wallet donation
                      donateFromWallet(petId, donationType, amount);
                    } else {
                      // For Food/Medical, just description
                      String desc = descController.text.trim();
                      if (desc.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please enter a description"),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                        return;
                      }
                      donateWithDescription(petId, donationType, desc);
                    }
                  },
                  child: const Text("Donate"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void donateFromWallet(String? petId, String type, int amount) {
    http
        .post(
          Uri.parse(
            '${MyConfig.baseUrl}/api/pawpal/donate.php?userid=${widget.user?.userId}&petid=$petId&amount=$amount&type=$type',
          ),
          body: {
            "userid": widget.user!.userId,
            "petid": petId.toString(),
            "donation_type": type,
            "amount": amount.toString(),
          },
        )
        .then((response) {
          print(response.body);
          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(response.body);

            if (jsonResponse['status'] == 'success') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Donation Successful"),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );

              // Refresh wallet & UI
              loadProfile();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(jsonResponse['message'] ?? "Donation failed"),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }
          }
        });
  }

  void donateWithDescription(String? petId, String type, String description) {
    http
        .post(
          Uri.parse(
            '${MyConfig.baseUrl}/pawpal/API/donate.php?userid=${widget.user?.userId}&petid=$petId&type=$type&description=$description',
          ),
          body: {
            "userid": widget.user!.userId,
            "petid": petId,
            "donation_type": type,
            "description": description,
          },
        )
        .then((response) {
          print(response.body);
          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(
              response.body,
            ); // Decode the JSON response here

            if (jsonResponse['status'] == 'success') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Donation Successful"),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );

              // Refresh wallet & UI
              loadProfile();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(jsonResponse['message'] ?? "Donation failed"),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }
          }
        });
  }
}