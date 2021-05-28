import 'package:chattie/AuthServices/AuthenticationService.dart';
import 'package:chattie/DataModels/UserData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class FourthScreen extends StatefulWidget {
  @override
  _FourthScreenState createState() => _FourthScreenState();
}

class _FourthScreenState extends State<FourthScreen> {
  bool darkMode = false;
  bool setOnline = false;

  Future<bool> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                await context
                    .read<AuthenticationService>()
                    .signOut()
                    .then((val) => {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "You are logged out, app will close in 2 seconds"))),
                        });
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () async {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final qrData = context.read<UserData>();
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
                  'My Profile',
                  style: TextStyle(
                    fontSize: 35,
                  ),
                ),
              ),
              Divider(
                height: 3,
                color: Colors.black,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'My QR Code',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              Center(
                child: QrImage(
                  data: qrData.getUid,
                  size: 200,
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text("Dark Mode"),
                leading:
                    darkMode ? Icon(Icons.nights_stay) : Icon(Icons.wb_sunny),
                trailing: Checkbox(
                  checkColor: Colors.amberAccent,
                  value: darkMode,
                  onChanged: (value) {
                    setState(() {
                      darkMode = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text("Do not Disturb"),
                leading: setOnline
                    ? Icon(Icons.do_disturb_alt_outlined)
                    : Icon(Icons.check),
                trailing: Checkbox(
                  checkColor: Colors.amberAccent,
                  value: setOnline,
                  onChanged: (value) {
                    setState(() {
                      setOnline = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: InkWell(
                  onTap: () async {
                    _showConfirmationDialog(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.amberAccent),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Text("Log Out"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
