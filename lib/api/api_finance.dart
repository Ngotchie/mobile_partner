import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/retry.dart';
import 'package:chicaparts/models/model_finance.dart';
import 'package:chicaparts/services/api.dart';
import 'package:http/http.dart' as http;

class ApiFinance {
  ApiUrl url = new ApiUrl();
  Future<dynamic> getMonthlyReports(partner, filter) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data = await client.get(
          Uri.parse(apiUrl +
              "apikey/partners/monthly-report?partner=" +
              partner.toString() +
              "&keyword=" +
              filter),
          headers: {
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': '*',
            'X-Authorization': apiKey,
          });
      var jsonData = jsonDecode(data.body);
      return jsonData;
    } catch (e) {
      print(e);
      client.close();
      return e;
    }
  }

  Future<dynamic> getOneReport(id) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data = await client.get(
          Uri.parse(apiUrl +
              "apikey/partners/monthly-report/" +
              id.toString() +
              "?no-relation=1"),
          headers: {
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': '*',
            'X-Authorization': apiKey,
          });
      if (data.statusCode == 200) {
        var jsonData = jsonDecode(data.body);
        var getData = jsonData['data'];
        MonthlyRepport mr = new MonthlyRepport(
          id,
          getData['accommodationRef'] != null
              ? getData['accommodationRef']
              : "",
          getData['external_name'] != null ? getData['external_name'] : "",
          getData['description'] != null
              ? Text(getData['description'])
              : Text(""),
          getData['type_accommodation'] != null
              ? getData['type_accommodation']
              : "",
          getData['address1'] != null ? getData['address1'] : "",
          getData['address2'] != null ? getData['address2'] : "",
          getData['address3'] != null ? getData['address3'] : "",
          getData['ref'] != null ? getData['ref'] : "",
          getData['name'] != null ? getData['name'] : "",
          getData['start_date_str'] != null ? getData['start_date_str'] : "",
          getData['end_date_str'] != null ? getData['end_date_str'] : "",
          getData['report_lines'] != null ? getData['report_lines'] : [],
          getData['occasional_losses'] != null
              ? getData['occasional_losses']
              : [],
          getData['occasional_gains'] != null
              ? getData['occasional_gains']
              : [],
          getData['status'] != null ? getData['status'] : "",
          getData['code'] != null ? getData['code'] : "",
          getData['total_payout'] != null ? getData['total_payout'] : "",
          getData['total_supplies_price'] != null
              ? getData['total_supplies_price']
              : 0,
          getData['total_occasional_fees'] != null
              ? getData['total_occasional_fees']
              : 0,
          getData['total_occasional_gains'] != null
              ? getData['total_occasional_gains']
              : 0,
          getData['total_chic_partner'] != null
              ? getData['total_chic_partner']
              : 0,
          getData['blocked_nights'] != null ? getData['blocked_nights'] : 0,
          getData['total_available_nights'] != null
              ? getData['total_available_nights']
              : 0,
          getData['total_occupied_nights'] != null
              ? getData['total_occupied_nights']
              : 0,
          getData['occupacy_rate'] != null ? getData['occupacy_rate'] : 0,
          getData['iban'] != null ? getData['iban'] : "",
          getData['bank_owner'] != null ? getData['bank_owner'] : "",
          getData['bic'] != null ? getData['bic'] : "",
          getData['supplies_base_price'] != null
              ? getData['supplies_base_price']
              : 0,
        );
        return mr;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      client.close();
      return e;
    }
  }

  Future<dynamic> getPaymentOrders(partner, filter) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data = await client.get(
          Uri.parse(apiUrl +
              "apikey/partners/payment-orders?partner=" +
              partner.toString() +
              "&keyword=" +
              filter),
          headers: {
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': '*',
            'X-Authorization': apiKey,
          });
      var jsonData = jsonDecode(data.body);
      return jsonData;
    } catch (e) {
      print(e);
      client.close();
      return e;
    }
  }

  Future<dynamic> getPayouts(partner, filter) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data = await client.get(
          Uri.parse(apiUrl +
              "apikey/partners/payouts?partner=" +
              partner.toString() +
              "&no-relation=-1&keyword=" +
              filter),
          headers: {
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': '*',
            'X-Authorization': apiKey,
          });
      var jsonData = jsonDecode(data.body);
      return jsonData;
    } catch (e) {
      print(e);
      client.close();
      return e;
    }
  }

  Future<dynamic> getYearlyPayouts(partner, filter) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data = await client.get(
          Uri.parse(apiUrl +
              "apikey/partners/payouts?partner=" +
              partner.toString() +
              "&no-relation=1&keyword=" +
              filter +
              "&year=1"),
          headers: {
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': '*',
            'X-Authorization': apiKey,
          });
      var jsonData = jsonDecode(data.body);
      return jsonData;
    } catch (e) {
      print(e);
      client.close();
      return e;
    }
  }

  Future<dynamic> getOnePayout(id) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data = await client.get(
          Uri.parse(apiUrl +
              "apikey/partners/payout/" +
              id.toString() +
              "?no-relation=1"),
          headers: {
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': '*',
            'X-Authorization': apiKey,
          });
      if (data.statusCode == 200) {
        var jsonData = jsonDecode(data.body);
        var getData = jsonData['data'];
        Payout pt = new Payout(
            id,
            getData['ref'],
            getData['contract_ref'],
            getData['accommodation_ref'],
            getData['internal_name'],
            getData['period_start'],
            getData['period_end'],
            getData['code'],
            getData['amount'],
            getData['supplies'],
            getData['chic_partner'],
            getData['og_amount'],
            getData['ol_amount'],
            getData['payout_date']);

        return pt;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      client.close();
      return e;
    }
  }

  Future<dynamic> dataForPdf(accommodation) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data = await client.get(
          Uri.parse(apiUrl +
              "apikey/partners/yearly_pdf?accommodation=" +
              accommodation.toString()),
          headers: {
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': '*',
            'X-Authorization': apiKey,
          });
      var jsonData = jsonDecode(data.body);
      return jsonData;
    } catch (e) {
      print(e);
      client.close();
      return e;
    }
  }

  // Future<File> generatePdf(contract, year) async {
  //   String apiUrl = url.getUrl();
  //   String apiKey = url.getKey();
  //   var client = RetryClient(http.Client());
  //   var data = await client.get(
  //       Uri.parse(apiUrl +
  //           'tools/document/download?document=DOC00006&object=' +
  //           contract.toString() +
  //           '&year=' +
  //           year +
  //           '&save=false'),
  //       headers: {
  //         'Accept': 'application/json',
  //         'Access-Control-Allow-Origin': '*',
  //         'Access-Control-Allow-Headers': '*',
  //         'X-Authorization': apiKey,
  //       });
  //   // var jsonData = jsonDecode(data.body);
  //   Directory tempDir = await getTemporaryDirectory();
  //   String tempPath = tempDir.path;
  //   File file = new File('$tempPath/$year.pdf');
  //   await file.writeAsBytes(data.bodyBytes);
  //   return file;
  // }
}
