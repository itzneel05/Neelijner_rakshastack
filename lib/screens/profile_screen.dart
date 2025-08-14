import 'package:flutter/material.dart';
import 'package:pg_application/animations/routeanimation.dart';
import 'package:pg_application/screens/edit_profile_screen.dart';
// import 'package:pg_application/screens/main_page.dart';
// import 'package:pg_application/screens/view_details.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool darkMode = false;
  bool notifications = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 201, 226, 253),
            Color.fromARGB(255, 218, 222, 225),
          ],
          stops: [0.0, 0.4],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(62.0),
          child: AppBar(
            elevation: 2.5,
            shadowColor: Colors.black,
            automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: Color.fromRGBO(25, 118, 210, 1),
            title: Text(
              "My Profile",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 370,
              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile avatar
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      child: Column(
                        children: [
                          const SizedBox(height: 22),
                          CircleAvatar(
                            foregroundImage: AssetImage(
                              'assets/images/profile.jpg',
                            ),
                            radius: 46,
                            backgroundColor: Colors.grey[300],
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey[500],
                            ),
                          ),
                          SizedBox(height: 14),
                          Text(
                            "Neel Ijner",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "neelijner@gmail,com",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            "+917984609311",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 15,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.pin_drop, size: 22),
                              Text(
                                "Surat, Gujarat",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "Member since July 2023",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[500],
                            ),
                          ),
                          SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 27),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'My Reviews (2)',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  SizedBox(height: 7),
                  Card(
                    elevation: 0.5,
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: SizedBox(
                      height: 80,
                      child: ListTile(
                        title: Text(
                          'Sunshine PG',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          'Very good facilities and friendly owner.',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 19),
                            Icon(Icons.star, color: Colors.amber, size: 19),
                            Icon(Icons.star, color: Colors.amber, size: 19),
                            Icon(Icons.star, color: Colors.amber, size: 19),
                            Icon(
                              Icons.star_half,
                              color: Colors.amber,
                              size: 19,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '4.5',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        trailing: Text(
                          'Aug 20, 2024',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ),

                  Card(
                    elevation: 0.5,
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: SizedBox(
                      height: 80,
                      child: ListTile(
                        title: Text(
                          'Cozy Nook Stay',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          'Decent place, but a bit noisy at night.',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 19),
                            Icon(Icons.star, color: Colors.amber, size: 19),
                            Icon(Icons.star, color: Colors.amber, size: 19),
                            Icon(Icons.star, color: Colors.amber, size: 19),
                            Icon(
                              Icons.star_border,
                              color: Colors.amber,
                              size: 19,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '4.0',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        trailing: Text(
                          'Jul 15, 2024',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 28),
                  // Settings section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Edit Profile row
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.edit, color: Colors.blue),
                          title: Text('Edit Profile'),
                          trailing: Icon(Icons.arrow_forward_ios, size: 18),
                          onTap: () {
                            Navigator.push(
                              context,
                              fadeAnimatedRoute(EditProfilePage()),
                            );
                          },
                        ),
                        // Divider(),
                        SwitchListTile(
                          value: notifications,
                          onChanged: (val) =>
                              setState(() => notifications = val),
                          activeColor: Colors.blue,
                          title: Text("Notifications"),
                          secondary: Icon(
                            Icons.notifications_none,
                            color: Colors.black54,
                          ),
                        ),
                        // Dark Mode toggle
                        SwitchListTile(
                          value: darkMode,
                          onChanged: (val) => setState(() => darkMode = val),
                          activeColor: Colors.blue,
                          title: Text("Dark Mode"),
                          secondary: Icon(
                            Icons.dark_mode,
                            color: Colors.black54,
                          ),
                        ),
                        // Privacy & Security
                        ListTile(
                          leading: Icon(
                            Icons.security_outlined,
                            color: Colors.black54,
                          ),
                          title: Text('Privacy & Security'),
                          trailing: Icon(Icons.arrow_forward_ios, size: 18),
                          onTap: () {},
                        ),
                        // Logout
                        ListTile(
                          leading: Icon(Icons.logout, color: Colors.red),
                          title: Text(
                            'Logout',
                            style: TextStyle(color: Colors.red),
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
