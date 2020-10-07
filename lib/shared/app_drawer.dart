import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("sachintha sandaruwan"),
            accountEmail: Text("sachinthas674@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                "S",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          
          ListTile(
            leading: FaIcon(FontAwesomeIcons.boxOpen),
            title: Text('Booking'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.wallet),
            title: Text('Wallet'),
            onTap: () {
              // Navigator.of(context)
              //     .pushReplacementNamed(OrdersScreen.routeName);
//            Navigator.of(context).pushReplacement(CustomRoute(builder: (ctx)=>OrdersScreen()));
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.newspaper),
            title: Text('News & Promotions'),
            onTap: () {
              // Navigator.of(context)
              //     .pushReplacementNamed(ManageProductsScreen.routName);
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.cog),
            title: Text('Settings'),
            onTap: () {
              // Navigator.of(context)
              //     .pushReplacementNamed(OrdersScreen.routeName);
//            Navigator.of(context).pushReplacement(CustomRoute(builder: (ctx)=>OrdersScreen()));
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.signOutAlt),
            title: Text('LogOut'),
            onTap: () {
              // Navigator.of(context).pop();
              // Provider.of<Auth>(context,listen: false).logOut();
            },
          ),
        ],
      ),
    );
  }
}
