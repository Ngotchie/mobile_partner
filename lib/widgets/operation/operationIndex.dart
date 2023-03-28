import 'package:flutter/material.dart';
import 'package:chicaparts/models/user/user.dart';
import 'package:chicaparts/widgets/menu/appBar.dart';
import 'package:chicaparts/widgets/menu/drawer.dart';
import 'package:chicaparts/widgets/operation/maintenance.dart';
import 'package:chicaparts/widgets/operation/sinister.dart';

class OperationIndexWidget extends StatefulWidget {
  const OperationIndexWidget({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _OperationIndexWidgetState createState() => _OperationIndexWidgetState();
}

class _OperationIndexWidgetState extends State<OperationIndexWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar("OPERATIONS", context, 1),
        drawer: drawer(widget.user, context),
        body: SingleChildScrollView(
          child: Center(
              child: Container(
            padding: EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 50,
                  width: 250,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.settings_suggest_sharp),
                    label: Text('Maintenance'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xFF8B1FA9)), //0xFFd1b690
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  MaintenanceWidget(user: widget.user)));
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 50,
                  width: 250,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.bug_report),
                    label: Text('Sinisters'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xFF54bf31)), //0xFFd49f55
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  SinisterWidget(user: widget.user)));
                    },
                  ),
                ),
              ],
            ),
          )),
        ));
  }
}
