// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Currencytarget {
  int? groupID;
  String? groupName;
  String? currency;
  String? dateBeg;
  String? dateEnd;
  dynamic targetTotalCost;
  List<CurrencytargetDtl>? currencytargetDtlList;

  Currencytarget(
      {this.groupID = 0,
      this.groupName,
      this.currency,
      this.dateBeg,
      this.dateEnd,
      this.targetTotalCost,
      this.currencytargetDtlList}) {
    currencytargetDtlList ??= <CurrencytargetDtl>[];
  }

  Currencytarget.fromJson(Map<String, dynamic> json) {
    groupID = json['groupID'];
    groupName = json['groupName'];
    currency = json['currency'];
    dateBeg = json['dateBeg'];
    dateEnd = json['dateEnd'];
    targetTotalCost = json['targetTotalCost'];
    currencytargetDtlList = (json['currencytargetDtlList'] as List)
        .map((e) => CurrencytargetDtl.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['groupID'] = groupID;
    data['groupName'] = groupName;
    data['currency'] = currency;
    data['dateBeg'] = dateBeg;
    data['dateEnd'] = dateEnd;
    data['targetTotalCost'] = targetTotalCost;
    if (currencytargetDtlList != null) {
      data['currencytargetDtlList'] =
          currencytargetDtlList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CurrencytargetDtl {
  int? dtlId;

  /// 兌換日期
  String? exchangeDate;

  /// 台幣金額
  dynamic twCost;

  /// 兌換匯率
  dynamic exchangeRate;

  /// 即期賣出
  dynamic cashSellingRate;

  /// 現金賣出
  dynamic spotSellingRate;

  /// 兌換外幣金額
  dynamic exchangeCost;

  CurrencytargetDtl(
      {this.dtlId = 0,
      this.exchangeDate,
      this.twCost,
      this.exchangeRate,
      this.cashSellingRate,
      this.spotSellingRate,
      this.exchangeCost});

  CurrencytargetDtl.fromJson(Map<String, dynamic> json) {
    exchangeDate = json['exchangeDate'];
    twCost = json['twCost'];
    exchangeRate = json['exchangeRate'];
    cashSellingRate = json['cashSellingRate'];
    spotSellingRate = json['spotSellingRate'];
    exchangeCost = json['exchangeCost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['exchangeDate'] = exchangeDate;
    data['twCost'] = twCost;
    data['exchangeRate'] = exchangeRate;
    data['spotSellingRate'] = spotSellingRate;
    data['exchangeCost'] = exchangeCost;
    return data;
  }
}

///***********************************************************************
///                         CurrencyStateNotifier
///***********************************************************************
class CurrencyStateNotifier extends StateNotifier<List<Currencytarget>> {
  CurrencyStateNotifier() : super([]) {
    loadFromSharedPreferences();
  }
  void loadFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? currencytargetList =
        prefs.getStringList('currencytargetList');

    if (currencytargetList == null)
      state = [];
    else {
      state = currencytargetList.map((currencytarget) {
        return Currencytarget.fromJson(jsonDecode(currencytarget));
      }).toList();
    }
  }

  void add(int gid) {
    state = [
      ...state,
      Currencytarget(groupID: gid),
    ];
    saveToSharedPreferences();
  }

  void addMultiple(List<Currencytarget> currencytarget) {
    state = [
      ...state,
      ...currencytarget,
    ];
    saveToSharedPreferences();
  }

  /*void toggle(int gid) {
    /*state = state
        .map((currencytarget) => currencytarget.groupID == gid
            ? currencytarget.copyWith(isDone: !currencytarget.isDone)
            : currencytarget)
        .toList();*/
    saveToSharedPreferences();
  }*/

  void remove(int gid) {
    state =
        state.where((currencytarget) => currencytarget.groupID != gid).toList();
    saveToSharedPreferences();
  }

  /// 儲存資料到 SharedPreferences
  void saveToSharedPreferences() {
    /*SharedPreferences.getInstance().then((prefs) {
      // store the todolist as a json object to shared preferences
      List<String> currencytargetList = state.map((currencytarget) {
        return jsonEncode(currencytarget);
      }).toList();
      prefs.setStringList('currencytargetList', currencytargetList);
    });*/
  }
}

final currencyTargetProvider =
    StateNotifierProvider<CurrencyStateNotifier, List<Currencytarget>>(
  (ref) => CurrencyStateNotifier(),
);

///***********************************************************************
///                         CurrencyStateNotifier
///***********************************************************************
