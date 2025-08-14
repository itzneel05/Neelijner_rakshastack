import 'package:flutter/material.dart';
import 'package:pg_application/animations/routeanimation.dart';
import 'package:pg_application/screens/main_page.dart';
import 'package:pg_application/screens/view_details.dart';
import 'package:pg_application/widgets/amenities_filter_widget.dart';
import 'package:pg_application/widgets/genderpref_widget.dart';
import 'package:pg_application/widgets/pglisting_widget.dart';
import 'package:pg_application/widgets/pricerange_widget.dart';
import 'package:pg_application/widgets/roomtype_filter_widget.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(62.0),
        child: AppBar(
          elevation: 2.5,
          shadowColor: Colors.black,
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromRGBO(25, 118, 210, 1),
          title: Text(
            "PGFinder",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => MainPage(initialTab: 3),
                  ),
                  (route) => false,
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Search for PG, location…',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF1C79D3),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),
                        onSubmitted: (query) {},
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Filter Button
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: Material(
                      color: Color.fromARGB(255, 26, 112, 198),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 2,
                      child: IconButton(
                        icon: const Icon(
                          size: 30,
                          Icons.filter_list,
                          color: Colors.white,
                        ),
                        tooltip: 'Filter',
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.white,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            builder: (BuildContext context) {
                              bool isFurnished = false;

                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              onPressed: () {},
                                              child: Text(
                                                "Reset All",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: const Color.fromARGB(
                                                    255,
                                                    123,
                                                    123,
                                                    123,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "Filters",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: Icon(Icons.close),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        PriceRangeSlider(),
                                        const SizedBox(height: 16),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Amenities",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              FilterAmenities(
                                                onApply:
                                                    (
                                                      wifi,
                                                      ac,
                                                      parking,
                                                      housekeeping,
                                                      laundry,
                                                      food,
                                                    ) {},
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        RoomTypeSelector(),
                                        const SizedBox(height: 16),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Text(
                                            "Additional Filters",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Text(
                                            "Gender Preference",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: const Color.fromARGB(
                                                255,
                                                111,
                                                111,
                                                111,
                                              ),
                                            ),
                                          ),
                                        ),
                                        GenderPreferenceSelector(),
                                        const SizedBox(height: 8),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Furnished/Unfurnished",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Switch(
                                                value: isFurnished,
                                                onChanged: (val) {
                                                  setState(
                                                    () => isFurnished = val,
                                                  );
                                                },
                                                activeColor: Color(0xFF1C79D3),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color(
                                                0xFF1C79D3,
                                              ),
                                              foregroundColor: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 10,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              elevation: 2,
                                            ),
                                            onPressed: () {},
                                            child: Text(
                                              "Apply Filters",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 50),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return PglistingWidget();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
