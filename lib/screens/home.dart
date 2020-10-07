import 'package:driver_app/shared/app_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
        drawer: AppDrawer(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "We Zent",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                height: 173,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "PICKUP",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: 250,
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: "enter pickup location"),
                          ),
                        ),
                      ],
                    ),
                    
                    Row(
                      children: [
                        SizedBox(width: 40,),
                        SizedBox(
                          height: 35,
                          child: VerticalDivider(
                            color: Colors.black,
                            width: 1,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "DROP",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: 250,
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: "enter drop location"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 25,),
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                height: 290,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1,color: Colors.grey)),
               child:Column(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Container(
                     height: 170,
                     decoration: BoxDecoration(
                      
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1,)),
                   ),Container(
                     height: 55,
                     decoration: BoxDecoration(
                      
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1,)),
                   )
                 ],
               ) ,
              ),
              SizedBox(
                width: double.infinity,
                              child: RaisedButton(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "CONTINUE",
                    style: TextStyle(
                      letterSpacing: 2,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    
                  
                  },
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
            
          ),
        ));
  }
}
