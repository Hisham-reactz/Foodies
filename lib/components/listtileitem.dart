import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class _ListTileitemloopState extends State<ListTileitemloop> {
// This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
      child: Container(
        padding: EdgeInsets.all(0.w),
        child: ListTile(
          // leading: Icon(
          //   Icons.circle,
          // ),
          title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Text(
                  widget.cart["dish_name"],
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold),
                )),
                Expanded(
                    child: Container(
                  width: 100.w * 0.35,
                  height: 100.h * 0.05,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0B401A), Color(0xFF0B401A)],
                      stops: [0, 1],
                      begin: Alignment(1, 0),
                      end: Alignment(-1, 0),
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          widget.up(widget.cart, false);
                        },
                        icon: Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 17,
                        ),
                        iconSize: 17,
                      ),
                      Text(
                        widget.cart['dish_Type'] is num
                            ? '0'
                            : widget.cart['dish_Type'].toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          widget.up(widget.cart, true);
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 17,
                        ),
                        iconSize: 17,
                      )
                    ],
                  ),
                ))
              ]),
          subtitle: Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'INR ' +
                              (num.parse(widget.cart["dish_Type"]) *
                                      widget.cart["dish_price"])
                                  .toString(),
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11.sp,
                              color: Colors.black),
                        )),
                    SizedBox(
                      height: 1.h,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.cart['dish_calories'].toString() + ' calories',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontSize: 11.sp),
                      ),
                    )
                  ])),
          trailing: Text(
            'INR ' +
                (num.parse(widget.cart["dish_Type"]) *
                        widget.cart["dish_price"])
                    .toString(),
            style: TextStyle(
                fontSize: 11.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          tileColor: Color(0xFFF5F5F5),
          dense: false,
        ),
      ),
    );
  }
}

class ListTileitemloop extends StatefulWidget {
  final up;
  final cart;
  ListTileitemloop({Key key, this.up, this.cart}) : super(key: key);

  @override
  _ListTileitemloopState createState() => _ListTileitemloopState();
}
