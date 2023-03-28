import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/retry.dart';
import 'package:http/http.dart' as http;
import 'package:chicaparts/models/model_booking.dart';
import 'package:chicaparts/services/api.dart';

class ApiBooking {
  ApiUrl url = new ApiUrl();
  Future<List<Booking>> getBookings(partner, range, type) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    List<Booking> bookings = [];
    var se = range.split("=>");
    try {
      var data = await client.get(
          Uri.parse(apiUrl +
              'apikey/partners/booking?partner=' +
              partner.toString() +
              '&start=' +
              se[0] +
              '&end=' +
              se[1] +
              '&type=' +
              type),
          headers: {
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': '*',
            'Access-Control-Allow-Methods': 'POST,GET,DELETE,PUT,OPTIONS',
            'X-Authorization': apiKey,
          });
      // print(data.body);
      var jsonData = jsonDecode(data.body);
      for (var book in jsonData["data"]) {
        Booking booking = new Booking(
          book["id"] != null ? book["id"] : 0,
          book["bookId"] != null ? book["bookId"] : 0,
          book["accommodation"] != null ? book["accommodation"] : "",
          book["lastNight"] != null ? book["lastNight"] : "",
          book["firstNight"] != null ? book["firstNight"] : "",
          book["bookingTime"] != null ? book["bookingTime"] : "",
          book["guestFirstName"] != null ? book["guestFirstName"] : "",
          book["guestName"] != null ? book["guestName"] : "",
          book["referer"] != null ? book["referer"] : "",
          book["status"] != null ? book["status"] : 0,
          book["price"] != null ? book["price"] : 0,
          book["currency"] != null ? book["currency"] : "",
          book["guestArrivalTime"] != null ? book["guestArrivalTime"] : "",
          book["numAdult"] != null ? book["numAdult"] : 0,
          book["numChild"] != null ? book["numChild"] : 0,
          book["guestArrivalTime"] != null ? book["guestArrivalTime"] : "",
          book["validation_status"] != null ? book["validation_status"] : "",
          book["notes"] != null ? Text(book["notes"]) : Text(""),
          book["roomId"] != null ? book["roomId"] : 0,
          book["propId"] != null ? book["propId"] : 0,
          book["multiplier"] != null ? book["multiplier"] : "Not defined",
        );

        bookings.add(booking);
      }
    } catch (e) {
      print(e);
      client.close();
    }
    return bookings;
  }

  Future<dynamic> getData(partner) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data = await client.get(
          Uri.parse(apiUrl + "apikey/new/booking/infos/" + partner.toString()),
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

  Future<int> postBlockDate(formData) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data = await client.post(Uri.parse(apiUrl + 'apikey/block/date'),
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json',
            'X-Authorization': apiKey,
          },
          body: jsonEncode(formData));

      return data.statusCode;
    } catch (e) {
      client.close();
      print(e);
      return throw Exception(e);
    }
  }

  Future<int> editBlockDate(formData, id) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data = await client.put(
          Uri.parse(apiUrl + 'apikey/block/date/' + id.toString()),
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json',
            'X-Authorization': apiKey,
          },
          body: jsonEncode(formData));

      return data.statusCode;
    } catch (e) {
      client.close();
      print(e);
      return throw Exception(e);
    }
  }

  Future<dynamic> getOneBooking(id) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data = await client
          .get(Uri.parse(apiUrl + "apikey/booking/" + id.toString()), headers: {
        'Accept': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': '*',
        'X-Authorization': apiKey,
      });
      if (data.statusCode == 200) {
        var jsonData = jsonDecode(data.body);
        var booking = jsonData;
        OneBooking oneBooking = new OneBooking(
            id,
            booking["referer"] != null ? booking["referer"] : "",
            booking["bookId"] != null ? booking["bookId"] : 0,
            booking["propId"] != null ? booking["propId"] : 0,
            booking["roomId"] != null ? booking["roomId"] : 0,
            booking["bookingTime"] != null ? booking["bookingTime"] : "",
            booking["firstNight"] != null ? booking["firstNight"] : "",
            booking["lastNight"] != null ? booking["lastNight"] : "",
            booking["numAdult"] != null ? booking["numAdult"] : 0,
            booking["numChild"] != null ? booking["numChild"] : 0,
            booking["guestArrivalTime"] != null
                ? booking["guestArrivalTime"]
                : "",
            booking["guestTitle"] != null ? booking["guestTitle"] : "",
            booking["guestFirstName"] != null ? booking["guestFirstName"] : "",
            booking["guestName"] != null ? booking["guestName"] : "Partner",
            booking["guestEmail"] != null ? booking["guestEmail"] : "",
            booking["guestPhone"] != null ? booking["guestPhone"] : "",
            booking["guestMobile"] != null ? booking["guestMobile"] : "",
            booking["guestFax"] != null ? booking["guestFax"] : "",
            booking["guestCompagny"] != null ? booking["guestCompagny"] : "",
            booking["guestAddress"] != null ? booking["guestAddress"] : "",
            booking["guestCity"] != null ? booking["guestCity"] : "",
            booking["guestState"] != null ? booking["guestState"] : "",
            booking["guestPostCode"] != null ? booking["guestPostCode"] : "",
            booking["guestCountry"] != null ? booking["guestCountry"] : "",
            booking["guestComments"] != null
                ? Text(booking["guestComments"])
                : Text(""),
            booking["notes"] != null ? Text(booking["notes"]) : Text(""),
            booking["price"] != null ? booking["price"] : 0,
            booking["deposit"] != null ? booking["deposit"] : 0,
            booking["tax"] != null ? booking["tax"] : 0,
            booking["commission"] != null ? booking["commission"] : 0,
            booking["cleaning_fees_partner"] != null
                ? booking["cleaning_fees_partner"]
                : 0,
            booking["transaction_fees"] != null
                ? booking["transaction_fees"]
                : 0,
            booking["booking_fees"] != null ? booking["booking_fees"] : 0,
            booking["currency"] != null ? booking["currency"] : "",
            booking["rateDescription"] != null
                ? Text(booking["rateDescription"])
                : Text(""),
            booking["currency_id"] != null ? booking["currency_id"] : 0,
            booking["validation_status"] != null
                ? booking["validation_status"]
                : "");
        return oneBooking;
      } else {
        return null;
      }
      // accommodations.add(newAcc);
    } catch (e) {
      print(e);
      client.close();
      return e;
    }
  }
}
