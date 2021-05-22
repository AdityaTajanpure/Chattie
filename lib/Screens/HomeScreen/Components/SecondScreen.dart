import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  final chatRequests;

  const SecondScreen({Key key, this.chatRequests}) : super(key: key);

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
                  itemCount: chatRequests.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.black,
                  ),
                  itemBuilder: (context, index) {
                    return ListTile(
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
                                  chatRequests[index]['image']),
                              fit: BoxFit.contain),
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.check_box_outlined),
                                  onPressed: () {
                                    print("Accept");
                                  }),
                              Text('Accept'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    print("Decline");
                                  }),
                              Text('Decline'),
                            ],
                          ),
                        ],
                      ),
                      title: Text(
                        chatRequests[index]['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      contentPadding: EdgeInsets.only(right: 25),
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
