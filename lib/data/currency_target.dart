// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Currencytarget {
  /// 群組ID
  late int groupID;

  /// 群組名稱
  String? groupName;

  /// 幣別
  String? currency;

  /// 預定日期(起)，格式：yyyy-MM-dd
  String? dateBeg;

  /// 預定日期(迄)，格式：yyyy-MM-dd
  String? dateEnd;

  /// 預定總金額
  num targetTotalCost = 0;

  /// 明細資料列表
  List<CurrencytargetDtl>? currencytargetDtlList;

  Currencytarget(
      {required this.groupID,
      this.groupName,
      this.currency,
      this.dateBeg,
      this.dateEnd,
      this.targetTotalCost = 0,
      this.currencytargetDtlList}) {
    currencytargetDtlList ??= <CurrencytargetDtl>[];
  }

  Currencytarget.fromJson(Map<String, dynamic> json) {
    groupID = json['groupID'] ?? 0;
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

  // copyWith
  Currencytarget copyWith(Currencytarget setItem) {
    return Currencytarget(
      groupID: setItem.groupID,
      groupName: setItem.groupName ?? groupName,
      currency: setItem.currency ?? currency,
      dateBeg: setItem.dateBeg ?? dateBeg,
      dateEnd: setItem.dateEnd ?? dateEnd,
      targetTotalCost: setItem.targetTotalCost,
      currencytargetDtlList:
          setItem.currencytargetDtlList ?? currencytargetDtlList,
    );
  }

  /// 計算總金額(外幣)
  double getTotalCost() {
    double totalCost = 0;
    for (var item in currencytargetDtlList!) {
      totalCost += item.exchangeCost ?? 0;
    }
    return totalCost;
  }

  /// 計算總金額
  int getTwTotalCost() {
    int totalCost = 0;
    for (var item in currencytargetDtlList!) {
      totalCost += item.twCost ?? 0;
    }
    return totalCost;
  }

  /// 金額顯示加入千分位
  static String getThousandthsCost(num showCost) {
    String result = '0';
    if (showCost > 0) {
      String strCost = Currencytarget.currentNumber(showCost.toString());
      num numValue = num.tryParse(strCost) ?? 0;
      String strValue = numValue.toString();
      var formatter = NumberFormat('0,000');

      // 整數部分
      String beforePoint = '';
      // 小數部分
      String afterPoint = '';

      // 取得整數/小數部分數字
      if (strValue.contains('.')) {
        int pointIndex = strValue.indexOf('.');
        beforePoint = strValue.substring(0, pointIndex);
        afterPoint = strValue.substring(pointIndex + 1, strValue.length);
      } else {
        beforePoint = strValue;
      }

      // 整數
      int intBeforePoint = int.tryParse(beforePoint) ?? 0;

      // 小數
      dynamic doubleAfterPoint = double.tryParse(('0.$afterPoint')) ?? 0.0;

      if (doubleAfterPoint > 0) {
        if (intBeforePoint >= 1000) {
          result = '${formatter.format(intBeforePoint)}.$afterPoint';
        } else {
          result = '$intBeforePoint.$afterPoint';
        }
      } else {
        result = formatter.format(intBeforePoint);
      }
    }
    return result;
  }

  /// 調整數字顯示格式, 10.0 => 10, 010.50 => 10.5
  static String currentNumber(String inputValue) {
    String result = '0';

    // 整數部分
    String beforePoint = '';
    // 小數部分
    String afterPoint = '';

    // 取得整數/小數部分數字
    if (inputValue.contains('.')) {
      int pointIndex = inputValue.indexOf('.');
      beforePoint = inputValue.substring(0, pointIndex);
      afterPoint = inputValue.substring(pointIndex + 1, inputValue.length);
    } else {
      beforePoint = inputValue;
    }

    // 整數
    int intBeforePoint = int.tryParse(beforePoint) ?? 0;

    // 小數
    dynamic doubleAfterPoint = double.tryParse(('0.$afterPoint')) ?? 0.0;

    if (doubleAfterPoint > 0) {
      dynamic curNum = intBeforePoint + doubleAfterPoint;
      result = curNum.toString();
    } else {
      result = intBeforePoint.toString();
    }

    return result;
  }
}

class CurrencytargetDtl {
  /// 編號
  int? dtlId;

  /// 兌換日期
  String? exchangeDate;

  /// 台幣金額
  int? twCost;

  /// 兌換匯率
  num? exchangeRate;

  /// 現金賣出
  num? cashSellingRate;

  /// 即期賣出
  num? spotSellingRate;

  /// 兌換外幣金額
  num? exchangeCost;

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

  CurrencytargetDtl copyWith(CurrencytargetDtl dtlItem) {
    return CurrencytargetDtl(
        dtlId: dtlItem.dtlId,
        exchangeDate: dtlItem.exchangeDate,
        twCost: dtlItem.twCost,
        exchangeRate: dtlItem.exchangeRate,
        cashSellingRate: dtlItem.cashSellingRate,
        spotSellingRate: dtlItem.spotSellingRate,
        exchangeCost: dtlItem.exchangeCost);
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
    List<String>? dataStrList = prefs.getStringList('currencytargetList');

    if (dataStrList == null) {
      state = [];
    } else {
      state = dataStrList.map((currencytarget) {
        return Currencytarget.fromJson(jsonDecode(currencytarget));
      }).toList();
    }
  }

  void add(Currencytarget setItem) {
    state = [...state, setItem];
    saveToSharedPreferences();
  }

  void change(Currencytarget setItem) {
    state = state
        .map((currencytarget) => currencytarget.groupID == setItem.groupID
            ? currencytarget.copyWith(setItem)
            : currencytarget)
        .toList();
    //print('state => gid: ${setItem.groupID}, name: ${setItem.groupName}');
    saveToSharedPreferences();
  }
/*
  void changeDtl(Currencytarget setItem, CurrencytargetDtl dtlItem) {
    

    state = state
        .map((currencytarget) => () {
          return [];
        })
        .toList();
    //print('state => gid: ${setItem.groupID}, name: ${setItem.groupName}');
    saveToSharedPreferences();
  }*/

  /*void addMultiple(List<Currencytarget> currencytarget) {
    state = [
      ...state,
      ...currencytarget,
    ];
    saveToSharedPreferences();
  }*/

  /*void toggle(int gid) {
    state = state
        .map((currencytarget) => currencytarget.groupID == gid
            ? currencytarget.copyWith(isDone: !currencytarget.isDone)
            : currencytarget)
        .toList();
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
class CurrencytargetDtlNotifier extends StateNotifier<List<CurrencytargetDtl>> {
  CurrencytargetDtlNotifier() : super([]);

  void addnote(CurrencytargetDtl setDtlItem) {
    state = [...state, setDtlItem];
    //print("===============> addnote");
  }

  void change(CurrencytargetDtl setDtlItem) {
    state = state
        .map((currencytarget) => currencytarget.dtlId == setDtlItem.dtlId
            ? currencytarget.copyWith(setDtlItem)
            : currencytarget)
        .toList();
  }

  void removenote(int dtlId) {
    var newList = state.where((x) => x.dtlId != dtlId);
    state = newList.toList();
  }
}

final currencytargetDtlProvider =
    StateNotifierProvider<CurrencytargetDtlNotifier, List<CurrencytargetDtl>>(
        (ref) {
  return CurrencytargetDtlNotifier();
});
