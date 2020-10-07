import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Hexcolor('#F0FFF0'),
      appBar: AppBar(
      iconTheme: IconThemeData(color: Colors.white),
        elevation: 0.0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: _deviceSize.height * 0.39,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: _deviceSize.height * 0.26,
                  color: Theme.of(context).primaryColor,
                ),
                Positioned(
                  top: _deviceSize.height * 0.09,
                  left: (_deviceSize.width - (_deviceSize.width * 0.92)) / 2,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: (_deviceSize.width * 0.92) / 2,
                          height: _deviceSize.height*0.135,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '3250',
                                style: TextStyle(
                                    fontSize: _deviceSize.height * 0.035),
                              ),
                              Text(
                                'Total Trips',
                                style: TextStyle(
                                    fontSize: _deviceSize.height * 0.035,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                             border: Border(
                              top: BorderSide(width: 0.5, color: Colors.grey),
                              right: BorderSide(width: 0.5, color: Colors.grey),
                            ),
                          ),
                        ),
                        Container(
                          width: (_deviceSize.width * 0.92) / 2,
                          height: _deviceSize.height*0.135,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '2.5',
                                style: TextStyle(
                                    fontSize: _deviceSize.height * 0.035),
                              ),
                              Text(
                                'Years',
                                style: TextStyle(
                                    fontSize: _deviceSize.height * 0.035,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 0.5, color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                    width: _deviceSize.width * 0.92,
                    height: _deviceSize.height * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                            blurRadius: 3)
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Positioned(
                  left: _deviceSize.width / 2 - (_deviceSize.width * 0.358 / 2),
                  bottom: _deviceSize.height * 0.16,
                  child: Column(
                    children: [
                      CircleAvatar(
                        //backgroundImage: Image.asset('assets/images/rider.jpg'),

                        // radius: _deviceSize.height * 0.09,
                        radius: _deviceSize.height * 0.09,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: _deviceSize.height * 0.085,
                          backgroundImage: AssetImage('images/rider.jpg'),
                        ),
                      ),
                      Container(
                        width: _deviceSize.width * 0.358,
                        child: Text(
                          "Jems Smith",
                          style: TextStyle(fontSize: _deviceSize.height * 0.04),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: _deviceSize.height * 0.035,
                horizontal:
                    (_deviceSize.width - (_deviceSize.width * 0.92)) / 2),
            child: Text(
              "PERSONAL INFO",
              style: TextStyle(fontSize: _deviceSize.height * 0.04),
            ),
          ),
          Container(
            color: Colors.white,
            width: double.infinity,
            height: _deviceSize.height * 0.3,
            padding: EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Icon(Icons.phone),
                    SizedBox(
                      width: _deviceSize.width * 0.1,
                    ),
                    Text(
                      '+1 87 564 565',
                      style: TextStyle(
                        fontSize: _deviceSize.height * 0.035,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.email),
                    SizedBox(
                      width: _deviceSize.width * 0.1,
                    ),
                    Text(
                      'james@abc.com',
                      style: TextStyle(
                        fontSize: _deviceSize.height * 0.035,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.location_on),
                    SizedBox(
                      width: _deviceSize.width * 0.1,
                    ),
                    Text(
                      '1450 Hall velly Drive',
                      style: TextStyle(
                        fontSize: _deviceSize.height * 0.035,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
