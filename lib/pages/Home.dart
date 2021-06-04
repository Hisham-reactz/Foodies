import 'dart:convert';
import 'package:flutter/material.dart';
import '../components/drawer.dart';
import '../components/tabbar.dart';
import '../components/listitem.dart';
import 'package:http/http.dart' as http;
import 'Order.dart';
import 'package:sizer/sizer.dart';

class HomePageWidget extends StatefulWidget {
  final data;
  HomePageWidget({Key key, this.data}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  dynamic dishData;
  int tabLength = 0;
  List tablelist = [];
  List cartData = [];
  int cartCount = 0;
  bool loading = false;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabLength, vsync: this);
    getDishes([]);
    getStore();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> getStore() async {
    setState(() {
      cartData = cartData;
      cartCount = cartData.length;
    });
  }

  updateStore() {
    getStore();
  }

  void getDishes(List<String> arguments) async {
    setState(() {
      loading = true;
    });
    var url = Uri.https('www.mocky.io', '/v2/5dfccffc310000efc8d2c1ad');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null && jsonResponse.length > 0) {
        setState(() {
          dishData = jsonResponse[0];
          tablelist = dishData['table_menu_list'];
          tabLength = tablelist.length;
          _tabController = TabController(length: tabLength, vsync: this);
          loading = false;
        });
        // print(tabLength);
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  getCurData(index) {
    return tablelist[index]['category_dishes'];
  }

  _orderPage(BuildContext context) async {
    final dataFromSecondPage = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              OrderWidget(cartdata: cartData, update: updateStore)),
    );
    // Here we have the data from the second screen
    setState(() {
      if (dataFromSecondPage != null) {
        for (var i = 0; i < cartData.length; i++) {
          cartData[i]['dish_Type'] = '0';
        }
        cartData = dataFromSecondPage["cardata"];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return !loading
        ? Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                dishData != null ? dishData['branch_name'] : '',
                style: TextStyle(color: Colors.black),
              ),
              bottom: PreferredSize(
                  child: TabBarloop(
                    data: {'tab': _tabController, 'tablist': tablelist},
                  ),
                  preferredSize: Size(15.w, 7.h)),
              backgroundColor: Colors.white,
              automaticallyImplyLeading: true,
              leading: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
                onPressed: () {
                  scaffoldKey.currentState.openDrawer();
                },
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 7, 0),
                  child: IconButton(
                    onPressed: () {
                      _orderPage(context);
                    },
                    icon: Stack(children: [
                      Icon(
                        Icons.shopping_cart_rounded,
                        color: Color(0xFF6F747A),
                        size: 4.h,
                      ),
                      Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                color: Colors.red, shape: BoxShape.circle),
                            child: Text(
                              cartCount.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 7.sp),
                            ),
                          )),
                    ]),
                    iconSize: 30,
                  ),
                )
              ],
              centerTitle: true,
              elevation: 4,
            ),
            drawer: AppDrawer(
              data: widget.data,
            ),
            body: SafeArea(
                child: tablelist.length > 0
                    ? TabBarView(
                        controller: _tabController,
                        children: tablelist
                            .asMap()
                            .entries
                            .map<Widget>((zx) => ListView(
                                  children: getCurData(zx.key)
                                      .map<Widget>((d) => ListItemloopWidget(
                                          data: d,
                                          up: updateStore,
                                          cart: cartData))
                                      .toList(),
                                ))
                            .toList())
                    : SizedBox.shrink()),
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
