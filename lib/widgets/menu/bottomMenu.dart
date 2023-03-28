import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:chicaparts/widgets/accommodation/accommodationIndex.dart';
import 'package:chicaparts/services/user.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:chicaparts/widgets/booking/bookingIndex.dart';
import 'package:chicaparts/widgets/finance/financeIndex.dart';
import 'package:chicaparts/widgets/operation/operationIndex.dart';

class BottomMenu extends StatefulWidget {
  const BottomMenu({Key? key, required this.index}) : super(key: key);
  final int index;
  @override
  _BottomMenuState createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  CurrentUser currentUser = new CurrentUser();
  var user;
  int selectedPos = 0;
  double bottomNavBarHeight = 60;
  String menuTitle = "";

  List<TabItem> tabItems = List.of([
    new TabItem(Icons.home, "Accommodations", Color(0xFF05A8CF),
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
    new TabItem(Icons.ballot_outlined, "Bookings", Color(0xFF05A8CF),
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
    new TabItem(Icons.euro, "Finances", Color(0xFF05A8CF),
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
    new TabItem(Icons.assignment, "Operations", Color(0xFF05A8CF),
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
  ]);

  late CircularBottomNavigationController _navigationController;
  @override
  void initState() {
    super.initState();
    currentUser.getCurrentUser().then((result) {
      setState(() {
        user = result;
      });
    });
    selectedPos = this.widget.index;
    _navigationController = new CircularBottomNavigationController(selectedPos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Padding(
            child: bodyContainer(),
            padding: EdgeInsets.only(bottom: bottomNavBarHeight),
          ),
          Align(alignment: Alignment.bottomCenter, child: bottomNav())
        ],
      ),
    );
  }

  Widget bodyContainer() {
    Color selectedColor = tabItems[selectedPos].circleColor;
    var _page;
    switch (selectedPos) {
      case 1:
        _page = BookingIndexWidget(user: user);
        menuTitle = "BOOKINGS";
        break;
      case 2:
        _page = FinanceIndexWidget(user: user);
        menuTitle = "FINANCES";
        break;
      case 3:
        _page = OperationIndexWidget(user: user);
        menuTitle = "OPERATIONS";
        break;
      case 0:
        _page = AccommodationIndexWidget(user: user);
        menuTitle = "ACCOMMODATIONS";
        break;
    }

    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: selectedColor,
        child: Center(child: _page),
      ),
      onTap: () {
        if (_navigationController.value == tabItems.length - 1) {
          _navigationController.value = 0;
        }
      },
    );
  }

  Widget bottomNav() {
    return CircularBottomNavigation(
      tabItems,
      controller: _navigationController,
      barHeight: bottomNavBarHeight,
      barBackgroundColor: Colors.white,
      animationDuration: Duration(milliseconds: 300),
      selectedCallback: (int? selectedPos) {
        setState(() {
          this.selectedPos = selectedPos != null ? selectedPos : 0;
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _navigationController.dispose();
  }
}
