import 'package:flutter/material.dart';

class Booking {
  int id;
  int bookId;
  String accommodation;
  String lastNight;
  String firstNight;
  String bookedAt;
  String guestFirstName;
  String guestName;
  String referer;
  int status;
  num price;
  String currency;
  String arrivalTime;
  int adult;
  int child;
  String arriveTime;
  String validationStatus;
  Text note;
  int roomId;
  int propId;

  dynamic multiplier;

  Booking(
    this.id,
    this.bookId,
    this.accommodation,
    this.lastNight,
    this.firstNight,
    this.bookedAt,
    this.guestFirstName,
    this.guestName,
    this.referer,
    this.status,
    this.price,
    this.currency,
    this.arrivalTime,
    this.adult,
    this.child,
    this.arriveTime,
    this.validationStatus,
    this.note,
    this.roomId,
    this.propId,
    this.multiplier,
  );
}

class OneBooking {
  int id;
  String referer;
  int bookId;
  int propId;
  int roomId;
  String bookedAt;
  String firstNight;
  String lastNight;
  int adult;
  int child;
  String arriveTime;

  String title;
  String guestFirstName;
  String guestName;
  String email;
  String phone;
  String mobile;
  String fax;
  String compagny;
  String address;
  String city;
  String state;
  String postCode;
  String country;
  Text comment;
  Text note;

  num price;
  num deposit;
  num tax;
  num commission;
  num cleaningFees;
  num transactionFees;
  num bookingFees;
  String currency;
  Text rateDescription;
  int currencyId;
  String validationStatus;

  OneBooking(
      this.id,
      this.referer,
      this.bookId,
      this.propId,
      this.roomId,
      this.bookedAt,
      this.firstNight,
      this.lastNight,
      this.adult,
      this.child,
      this.arriveTime,
      this.title,
      this.guestFirstName,
      this.guestName,
      this.email,
      this.phone,
      this.mobile,
      this.fax,
      this.compagny,
      this.address,
      this.city,
      this.state,
      this.postCode,
      this.country,
      this.comment,
      this.note,
      this.price,
      this.deposit,
      this.tax,
      this.commission,
      this.cleaningFees,
      this.transactionFees,
      this.bookingFees,
      this.currency,
      this.rateDescription,
      this.currencyId,
      this.validationStatus);
}
