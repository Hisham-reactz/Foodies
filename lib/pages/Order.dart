import 'package:flutter/material.dart';
import '../components/listtileitem.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class OrderWidget extends StatefulWidget {
  dynamic cartdata;
  final update;
  OrderWidget({Key key, this.cartdata, this.update}) : super(key: key);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _modifyCart(val, type) async {
    if (val['dish_Type'] is num) {
      val['dish_Type'] = '0';
    }

    var idx = widget.cartdata.indexOf(val);
    if (type) {
      setState(() {
        if (idx >= 0) {
          val['dish_Type'] = (num.parse(val['dish_Type']) + 1).toString();
          widget.cartdata[idx] = val;
        } else {
          widget.cartdata.add(val);
        }
      });
    } else {
      if (idx >= 0) {
        setState(() {
          val['dish_Type'] = (num.parse(val['dish_Type']) - 1).toString();
          num.parse(val['dish_Type']) >= 1 ? '' : widget.cartdata.removeAt(idx);
          num.parse(val['dish_Type']) >= 1 ? widget.cartdata[idx] = val : '';
        });
      } else {
        widget.cartdata.removeAt(idx);
      }
    }

    widget.update();
  }

  @override
  Widget build(BuildContext context) {
    double sum = 0;
    for (var i = 0; i < widget.cartdata.length; i++) {
      sum += num.parse(widget.cartdata[i]['dish_Type']) *
          widget.cartdata[i]['dish_price'].toDouble();
    }
    Future<void> _askedToLead() async {
      switch (await showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
                title: const Text('Order successfully placed'),
                children: <Widget>[
                  SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context, 'finished');
                      },
                      child: const Text('Go Home')),
                ]);
          })) {
        case 'finished':
          Navigator.pop(context, {"cardata": []});
          break;
        default:
          Navigator.pop(context, {"cardata": []});
          break;
      }
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Order Summary",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        actions: [],
        // centerTitle: true,
        elevation: 4,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(7, 7, 7, 7),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFEEEEEE),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(7, 7, 7, 7),
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Color(0xFFF5F5F5),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(7, 7, 7, 7),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 100.w * 0.75,
                                height: 100.h * 0.07,
                                decoration: BoxDecoration(
                                  color: Color(0xFF0B401A),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Align(
                                  alignment: Alignment(0, 0),
                                  child: Text(
                                    widget.cartdata.length.toString() +
                                        ' Dishes - ' +
                                        widget.cartdata.length.toString() +
                                        ' Items',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                  children: widget.cartdata
                                      .map<Widget>((d) => Column(children: [
                                            ListTileitemloop(
                                              cart: d,
                                              up: _modifyCart,
                                            ),
                                            Divider(),
                                          ]))
                                      .toList()),
                              ListTile(
                                title: Text(
                                  'Total Amount',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                trailing: Text(
                                  'INR ' + sum.toString(),
                                  style: TextStyle(
                                    color: Color(0xFF009F49),
                                  ),
                                ),
                                tileColor: Color(0xFFF5F5F5),
                                dense: false,
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 13, 1, 0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 15.sp),
                        primary: Color(0xFF0B401A),
                        fixedSize: Size(350, 50),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      onPressed: widget.cartdata.length == 0
                          ? null
                          : () {
                              _askedToLead();
                            },
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Place Order',
                          ))),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
