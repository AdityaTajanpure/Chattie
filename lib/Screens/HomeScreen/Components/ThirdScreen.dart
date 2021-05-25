import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:chattie/DataModels/UserData.dart';
import 'package:chattie/DatabaseServices/UserLogin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThirdScreen extends StatefulWidget {
  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userData = context.read<UserData>();
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
                controller: _textController,
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 18),
                maxLength: 28,
                decoration: new InputDecoration(
                  labelText: "Enter User Tag",
                  border: OutlineInputBorder(),
                ),
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
                      child: IconButton(
                        icon: Icon(
                          Icons.add_a_photo,
                          size: 30,
                        ),
                        onPressed: () async {
                          String codeSanner =
                              await BarcodeScanner.scan(); //barcode scnner
                          setState(() {
                            _textController.text = codeSanner;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Scan QR Code"),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        if (_textController.text.length < 15) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Enter Correct User Tag")));
                        } else {
                          UserLogin().sendRequest(
                              userData, _textController.text, context);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.amberAccent),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Text("Send Request"),
                        ),
                      ),
                    ),
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
