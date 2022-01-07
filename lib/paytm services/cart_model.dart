import 'dart:collection';
import 'package:fastguide/admin/screens/team/model/member.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  final List<double> _courseSelectedPrice = [];
  final List<double> _courseSelectedMRP = [];
  final List<String> _courseIdList = [];
  final List<Member> _couponMember = [];
  final List<double> _couponCodeOff = [];
  bool _isClickTermAndCondition = true;

  UnmodifiableListView<double> get items =>
      UnmodifiableListView(_courseSelectedPrice);

  double get totalCoursePriceWhenCouponAdded =>
      _totalPriceOfCourse() -
      (_totalPriceOfCourse() * _totalPriceOfCouponCodeOff()) / 100;
  double get totalCoursePrice => _totalPriceOfCourse();
  double get totalCourseMRPOnly => _totalMRPOfCourse();
  String get courseIds => _courseIdList.toString();
  List get courseIdsList => _courseIdList;
  Member get member => _couponMember.first;
  List get memberList => _couponMember;
  List get couponCodeList => _couponCodeOff;

  bool get isClickedTermsAndCondition => _isClickTermAndCondition;

  void clickedTerms() {
    _isClickTermAndCondition = !_isClickTermAndCondition;
    notifyListeners();
  }

  _totalPriceOfCourse() {
    double sum = 0;
    for (var i = 0; i < _courseSelectedPrice.length; i++) {
      sum += _courseSelectedPrice[i];
    }
    return sum;
  }

  _totalMRPOfCourse() {
    double sum = 0;
    for (var i = 0; i < _courseSelectedMRP.length; i++) {
      sum += _courseSelectedMRP[i];
    }
    return sum;
  }

  void addMRP(double price) {
    _courseSelectedMRP.add(price);
    notifyListeners();
  }

  _totalPriceOfCouponCodeOff() {
    double sum = 0;
    for (var i = 0; i < _couponCodeOff.length; i++) {
      sum += _couponCodeOff[i];
    }
    return sum;
  }

  void add(double price) {
    _courseSelectedPrice.add(price);
    notifyListeners();
  }

  void removeAll() {
    _courseSelectedPrice.clear();
    notifyListeners();
  }

  void addCouponCodeOff(double price) {
    _couponCodeOff.add(price);
    notifyListeners();
  }

  void removeAllCouponCodeOff() {
    _couponCodeOff.clear();
    notifyListeners();
  }

  void addCodeRedeemUser(Member member) {
    _couponMember.add(member);
    notifyListeners();
  }

  void removeCodeRedeemUser() {
    _couponMember.clear();
    notifyListeners();
  }

  void addCourseId(String courseId) {
    _courseIdList.add(courseId);
    notifyListeners();
  }

  void removeCourseId(String courseId) {
    _courseIdList.remove(courseId);
    notifyListeners();
  }
}
