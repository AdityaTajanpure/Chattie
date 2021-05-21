import 'package:flutter/material.dart';

class ThirdScreen extends StatelessWidget {
  String userId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Text(
                  'Add a Friend',
                  style: TextStyle(
                    fontSize: 35,
                  ),
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Text(
                "Ask your friend for their User Id or Scan their QR Code",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 50,
              ),
              TextField(
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 18),
                maxLength: 10,
                decoration: new InputDecoration(
                  labelText: "Enter User Tag",
                  border: OutlineInputBorder(),
                ),

                onChanged: (value) => this.userId = value,
                // Only numbers can be entered
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.amberAccent,
                        borderRadius: BorderRadius.circular(45),
                      ),
                      child: Icon(
                        Icons.add_a_photo,
                        size: 30,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Scan QR Code")
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
