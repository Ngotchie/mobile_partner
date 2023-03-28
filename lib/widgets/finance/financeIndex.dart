import 'package:flutter/material.dart';
import 'package:chicaparts/models/user/user.dart';
import 'package:chicaparts/widgets/finance/monthlyReport.dart';
import 'package:chicaparts/widgets/finance/paymentOders.dart';
import 'package:chicaparts/widgets/finance/payouts.dart';
import 'package:chicaparts/widgets/finance/yearlyPayouts.dart';
import 'package:chicaparts/widgets/menu/appBar.dart';
import 'package:chicaparts/widgets/menu/drawer.dart';

class FinanceIndexWidget extends StatefulWidget {
  const FinanceIndexWidget({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  _FinanceIndexWidgetState createState() => _FinanceIndexWidgetState();
}

class _FinanceIndexWidgetState extends State<FinanceIndexWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar("FINANCES", context, 1),
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
                    icon: Icon(Icons.money),
                    label: Text('Payment Orders'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFFFBD107)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  PaymentOrderWidget(user: widget.user)));
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
                    icon: Icon(Icons.monetization_on_outlined),
                    label: Text('Monthly Reports'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF05A8CF)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  MonthlyReportWidget(user: widget.user)));
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
                    icon: Icon(Icons.attach_money),
                    label: Text('Payouts'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF8B1FA9)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => PayoutWidget(user: widget.user)));
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
                    icon: Icon(Icons.payments_outlined),
                    label: Text('Yearly Payouts Reports'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF54bf31)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  YearlyPayoutWidget(user: widget.user)));
                    },
                  ),
                ),
              ],
            ),
          )),
        ));
  }
}
