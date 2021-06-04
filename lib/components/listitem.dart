import 'dart:async';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:sizer/sizer.dart';

class _ListItemloopWidgetState extends State<ListItemloopWidget> {
// This widget is the root of your application.

  num cartCount = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _modifyCart(val, type) async {
    if (val['dish_Type'] is num) {
      val['dish_Type'] = '0';
    }

    var idx = widget.cart.indexOf(val);
    if (type) {
      setState(() {
        if (idx >= 0) {
          val['dish_Type'] = (num.parse(val['dish_Type']) + 1).toString();
          widget.cart[idx] = val;
        } else {
          widget.cart.add(val);
          cartCount = cartCount + 1;
        }
      });
    } else {
      if (idx >= 0) {
        setState(() {
          val['dish_Type'] = (num.parse(val['dish_Type']) - 1).toString();
          num.parse(val['dish_Type']) >= 1 ? '' : widget.cart.removeAt(idx);
          num.parse(val['dish_Type']) >= 1 ? widget.cart[idx] = val : '';
        });
      } else {
        idx != -1 ? widget.cart.removeAt(idx) : '';
        idx != -1 ? cartCount = cartCount - 1 : '';
      }
    }

    widget.up();
  }

  @override
  Widget build(BuildContext context) {
    // print(data);
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Container(
        width: 100.w,
        height: 100.h * 0.25,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Container(
                  //   width: 15,
                  //   height: 15,
                  //   clipBehavior: Clip.antiAlias,
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.circle,
                  //   ),
                  //   child: Image.network(
                  //     'https://picsum.photos/seed/727/600',
                  //     fit: BoxFit.scaleDown,
                  //   ),
                  // ),
                  Expanded(
                      flex: 5,
                      child: AutoSizeText(
                        widget.data['dish_name'] +
                            '\nINR ' +
                            widget.data['dish_price'].toString(),
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      )),
                  Expanded(
                      flex: 5,
                      child: AutoSizeText(
                        '\n\n ' +
                            widget.data['dish_calories'].toString() +
                            ' Calories',
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 4.sp,
                        ),
                      )),
                  Expanded(
                      flex: 3,
                      child: Image.network(
                        'https://picsum.photos/seed/544/600', //api image url faulty
                        width: 25.w,
                        height: 25.w,
                        fit: BoxFit.cover,
                      ))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 117, 1),
              child: AutoSizeText(
                widget.data['dish_description'],
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 4.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(27, 7, 0, 0),
                child: Container(
                  width: 100.w * 0.35,
                  height: 100.h * 0.05,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF14B15C), Color(0xFF5FD768)],
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
                          _modifyCart(widget.data, false);
                        },
                        icon: Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 17,
                        ),
                        iconSize: 17,
                      ),
                      AutoSizeText(
                        widget.data['dish_Type'] is num
                            ? '0'
                            : widget.data['dish_Type'].toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _modifyCart(widget.data, true);
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
                ),
              ),
            ),
            widget.data['addonCat'] != null &&
                    widget.data['addonCat'].length > 0
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: AutoSizeText(
                      '    Customizations Available',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.deepOrangeAccent,
                          fontSize: 10.sp),
                    ),
                  )
                : SizedBox.shrink(),
            Divider()
          ],
        ),
      ),
    );
  }
}

class ListItemloopWidget extends StatefulWidget {
  final data;
  final up;
  final cart;
  ListItemloopWidget({Key key, this.data, this.up, this.cart})
      : super(key: key);

  @override
  _ListItemloopWidgetState createState() => _ListItemloopWidgetState();
}
