import 'package:flutter/material.dart';

class MyMessage extends StatelessWidget {
  final data, time;

  const MyMessage({Key key, this.data, this.time}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(
                minWidth: 50, maxWidth: MediaQuery.of(context).size.width / 2),
            margin: EdgeInsets.only(top: 10, right: 10),
            decoration: BoxDecoration(
              color: Color(0xFFF8A2A2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                "$data",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          Text(time,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
        ],
      ),
    );
  }
}
