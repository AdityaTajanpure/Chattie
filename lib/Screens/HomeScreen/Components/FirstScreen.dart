import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FirstScreen extends StatelessWidget {
  final List chatsList;
  const FirstScreen({Key key, this.chatsList}) : super(key: key);

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
                  'Message',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w300),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width - 50,
                  decoration: BoxDecoration(
                    color: Color(0xFFE9E9E9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 45,
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: Center(
                          child: Text("Latest (${chatsList.length})"),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent,
                        ),
                        child: Center(
                          child: Text("Archieved"),
                        ),
                      ),
                    ],
                  ),
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
                  itemCount: chatsList.length,
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
                                  chatsList[index]['image']),
                              fit: BoxFit.contain),
                        ),
                      ),
                      trailing: Text("12:05",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 16)),
                      title: Text(
                        chatsList[index]['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      subtitle: Container(),
                      onTap: () {},
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
