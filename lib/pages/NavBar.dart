import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Oflutter.com'),
            accountEmail: Text('example@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
            ),
          ),
          ListTile(
            leading: Icon(Icons.qr_code),
            title: Text('QR কোড স্ক্যান'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.list_alt_sharp),
            title: Text('ভোক্তার তালিকা'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.password_sharp),
            title: Text('পাসওয়ার্ড পরিবর্তন'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            title: Text('প্রস্থান'),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}