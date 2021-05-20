import 'package:chattie/Screens/LoginScreen/Login.dart';
import 'package:chattie/Services/Intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GetStarted extends StatefulWidget {
  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  int item = 0;

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: 0);
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      body: Stack(
        children: [
          PageView(
            scrollDirection: Axis.horizontal,
            controller: controller,
            children: <Widget>[
              Center(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      "assets/images/show.svg",
                      height: 450,
                    ),
                    Text('Your Anytime Chatting Partner.'),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      "assets/images/show2.svg",
                      height: 450,
                    ),
                    Text(
                      'Form Groups with your friend circle and stay connected..',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: 400,
                      width: MediaQuery.of(context).size.width - 100,
                    ),
                    Text(
                      "Chattie",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    Text(
                      "Your place to talk and hang out with friends and groups",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
            onPageChanged: (index) {
              setState(() {
                item = index;
              });
            },
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 270,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xFFf4f2f7),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(55.0),
                  topRight: Radius.circular(55.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Find Your Best\nFriends with us",
                      style: TextStyle(
                        fontSize: 26,
                      ),
                    ),
                    Text(
                      "Life is incomplete without weird best friends, Stay connected with them here...",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFC5C5C5),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                AppIntents.createRoute(widget: Login()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.amberAccent,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Text("Get Started"),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: item == 0 ? 20 : 10,
                              color:
                                  item == 0 ? Colors.amberAccent : Colors.grey,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.circle,
                              size: item == 1 ? 20 : 10,
                              color:
                                  item == 1 ? Colors.amberAccent : Colors.grey,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.circle,
                              size: item == 2 ? 20 : 10,
                              color:
                                  item == 2 ? Colors.amberAccent : Colors.grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
