import 'package:cached_network_image/cached_network_image.dart';
import 'package:chattie/DataModels/UserData.dart';
import 'package:chattie/DatabaseServices/UserLogin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SecondScreen extends StatefulWidget {
  final chatRequests, uid;

  const SecondScreen({Key key, this.chatRequests, this.uid}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  String whatHappened = "";

  Future<bool> _showConfirmationDialog(
      BuildContext context, String action, index, request) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do you want to $action this request?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                if (action == "Accept")
                  await UserLogin(uid: widget.uid).acceptRequest(
                      index,
                      request,
                      widget.chatRequests[index]['uid'],
                      context.read<UserData>());
                else
                  await UserLogin(uid: widget.uid)
                      .cancelRequest(index, request);
                Navigator.pop(context, true); // showDialog() returns true
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () async {
                Navigator.pop(context, false); // showDialog() returns false
              },
            ),
          ],
        );
      },
    );
  }

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
                  'Chat Requests',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w300),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.separated(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: widget.chatRequests.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.black,
                  ),
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(widget.chatRequests[index]['name']),
                      onDismissed: (direction) {
                        setState(() {
                          widget.chatRequests.removeAt(index);
                        });

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Request of ${widget.chatRequests[index]['name']} is $whatHappened")));
                      },
                      confirmDismiss:
                          (DismissDirection dismissDirection) async {
                        switch (dismissDirection) {
                          case DismissDirection.startToEnd:
                            whatHappened = 'ARCHIVED';
                            return await _showConfirmationDialog(
                                    context,
                                    'Accept',
                                    index,
                                    widget.chatRequests[index]) ==
                                true;
                          case DismissDirection.endToStart:
                            whatHappened = 'DELETED';
                            return await _showConfirmationDialog(
                                    context,
                                    'Decline',
                                    index,
                                    widget.chatRequests[index]) ==
                                true;
                          case DismissDirection.horizontal:
                          case DismissDirection.vertical:
                          case DismissDirection.up:
                          case DismissDirection.down:
                            assert(false);
                        }
                        return false;
                      },
                      background: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        color: Colors.green,
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.check),
                      ),
                      secondaryBackground: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.close),
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        leading: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    widget.chatRequests[index]['image']),
                                fit: BoxFit.contain),
                          ),
                        ),
                        subtitle: Text(
                          "Slide request to respond",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        title: Text(
                          widget.chatRequests[index]['name'],
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                        contentPadding: EdgeInsets.only(right: 25),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
