import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:chicaparts/models/model_operation.dart';
import 'dart:convert';
import 'dart:async';

import 'package:chicaparts/services/api.dart';

class ApiOperation {
  ApiUrl url = new ApiUrl();

  Future<dynamic> getMaintenances(partner, pending, nature) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data = await client.get(
          Uri.parse(apiUrl +
              "apikey/partners/maintenances?partner=" +
              partner.toString() +
              "&pending=" +
              pending.toString() +
              "&keyword=" +
              nature),
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

  Future<dynamic> getSinisters(partner, pending, filter) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data = await client.get(
          Uri.parse(apiUrl +
              "apikey/partners/sinisters?partner=" +
              partner.toString() +
              "&pending=" +
              pending.toString() +
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

  Future<dynamic> getOneMaintenance(id) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data = await client.get(
          Uri.parse(apiUrl + "apikey/one/maintenance/" + id.toString()),
          headers: {
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': '*',
            'X-Authorization': apiKey,
          });
      if (data.statusCode == 200) {
        var jsonData = jsonDecode(data.body);
        Maintenance mt = new Maintenance(
          id,
          jsonData["ref"] != null ? jsonData["ref"] : "",
          jsonData["accommodation"] != null ? jsonData["accommodation"] : "",
          jsonData["title"] != null ? jsonData["title"] : "",
          jsonData["estimation"] != null ? jsonData["estimation"] : 0,
          jsonData["real_cost"] != null ? jsonData["real_cost"] : 0,
          jsonData["handler"] != null ? jsonData["handler"] : "",
          jsonData["priority"] != null ? jsonData["priority"] : "",
          jsonData["step"] != null ? jsonData["step"] : "",
          jsonData["natures"] != null ? jsonData["natures"] : "",
          jsonData["status"] != null ? jsonData["status"] : "",
          jsonData["fixed_date"] != null ? jsonData["fixed_date"] : "",
          jsonData["fixed_percentage"] != null
              ? int.parse(jsonData["fixed_percentage"])
              : 0,
          jsonData["log_date"] != null ? jsonData["log_date"] : "",
          jsonData["description"] != null
              ? Text(jsonData["description"])
              : Text(""),
          jsonData["currency"] != null ? jsonData["currency"] : "",
          jsonData["ref_accommodation"] != null
              ? jsonData["ref_accommodation"]
              : "",
        );

        return mt;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      client.close();
      return e;
    }
  }

  Future<dynamic> getOneSinister(id) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data = await client.get(
          Uri.parse(apiUrl + "apikey/one/sinister/" + id.toString()),
          headers: {
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': '*',
            'X-Authorization': apiKey,
          });
      if (data.statusCode == 200) {
        var jsonData = jsonDecode(data.body);
        Sinister sn = new Sinister(
            id,
            jsonData["ref"] != null ? jsonData["ref"] : "",
            jsonData["author"] != null ? jsonData["author"] : "",
            jsonData["ref_accommodation"] != null
                ? jsonData["ref_accommodation"]
                : "",
            jsonData["accommodation"] != null ? jsonData["accommodation"] : "",
            jsonData["referer"] != null ? jsonData["referer"] : "",
            jsonData["apiReference"] != null ? jsonData["apiReference"] : "",
            jsonData["guestFirstName"] != null
                ? jsonData["guestFirstName"]
                : "",
            jsonData["guestName"] != null ? jsonData["guestName"] : "",
            jsonData["firstNight"] != null ? jsonData["firstNight"] : "",
            jsonData["lastNight"] != null ? jsonData["lastNight"] : "",
            jsonData["currency"] != null ? jsonData["currency"] : "",
            jsonData["title"] != null ? jsonData["title"] : "",
            jsonData["status"] != null ? jsonData["status"] : "",
            jsonData["found_date"] != null ? jsonData["found_date"] : "",
            jsonData["folder_link"] != null ? jsonData["folder_link"] : "",
            jsonData["description"] != null
                ? Text(jsonData["description"])
                : Text(""),
            jsonData["guarantee_type"] != null
                ? jsonData["guarantee_type"]
                : "",
            jsonData["payment_status"] != null
                ? jsonData["payment_status"]
                : "",
            jsonData["refunded_amount"] != null
                ? jsonData["refunded_amount"]
                : 0,
            jsonData["ticket_ref"] != null ? jsonData["ticket_ref"] : "",
            jsonData["ticket_link"] != null ? jsonData["ticket_link"] : "",
            jsonData["requested_amount"] != null
                ? jsonData["requested_amount"]
                : 0,
            jsonData["start_date"] != null ? jsonData["start_date"] : "",
            jsonData["close_date"] != null ? jsonData["close_date"] : "",
            jsonData["actions"] != null ? jsonData["actions"] : []);

        return sn;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      client.close();
      return e;
    }
  }
}
