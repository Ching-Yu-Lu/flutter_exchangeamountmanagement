import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class FetchAndExtract {
  /// 外幣幣別
  final String unitCurrency;

  /// 幣別
  final String targetCurrency;

  /// 即期買入
  final double cashBuyingRate;

  /// 即期賣出
  final double cashSellingRate;

  /// 現金買入
  final double spotBuyingRate;

  /// 現金賣出
  final double spotSellingRate;

  // 銀行名稱
  final String bankName;

  //final String code;

  /// 更新時間
  final String updateTime;

  //final String link;
  FetchAndExtract(
      {required this.unitCurrency,
      required this.targetCurrency,
      required this.cashBuyingRate,
      required this.cashSellingRate,
      required this.spotBuyingRate,
      required this.spotSellingRate,
      required this.bankName,
      //required this.code,
      required this.updateTime
      //required this.link
      });

/*
"unitCurrency": "USD",
"targetCurrency": "TWD",
"cashBuyingRate": 31.5,
"cashSellingRate": 31.7,
"spotBuyingRate": 31.5,
"spotSellingRate": 31.7,
"bankName": "台新銀行",
"updateTime": "2023-10-01 12:00:00",
 */

  /// 外幣幣別代碼轉名稱
  String currencyCodeToName() {
    String rt = '';

    // 幣別中文名稱
    switch (unitCurrency) {
      case 'All':
        rt = '全部';
        break;
      case 'PleaseSelect':
        rt = '請選擇';
        break;
      case 'USD':
        rt = '美金';
        break;
      case 'TWD':
        rt = '台幣';
        break;
      case 'JPY':
        rt = '日圓';
        break;
      case 'CNY':
        rt = '人民幣';
        break;
      case 'HKD':
        rt = '港幣';
        break;
      case 'EUR':
        rt = '歐元';
        break;
      case 'GBP':
        rt = '英鎊';
        break;
      case 'AUD':
        rt = '澳幣';
        break;
      case 'CAD':
        rt = '加幣';
        break;
      case 'NZD':
        rt = '紐幣';
        break;
      case 'SGD':
        rt = '新幣';
        break;
      case 'CHF':
        rt = '瑞士法郎';
        break;
      case 'THB':
        rt = '泰銖';
        break;
      case 'MYR':
        rt = '馬來幣';
        break;
      case 'PHP':
        rt = '菲律賓比索';
        break;
      case 'IDR':
        rt = '印尼盾';
        break;
      case 'VND':
        rt = '越南盾';
        break;
      case 'KRW':
        rt = '韓元';
        break;
      case 'INR':
        rt = '印度盧比';
        break;
      case 'BRL':
        rt = '巴西雷亞爾';
        break;
      case 'MXN':
        rt = '墨西哥比索';
        break;
      case 'ZAR':
        rt = '南非幣';
        break;
      case 'RUB':
        rt = '俄羅斯盧布';
        break;
      case 'TRY':
        rt = '土耳其里拉';
        break;
      case 'AED':
        rt = '阿聯酋迪拉姆';
        break;
      case 'SAR':
        rt = '沙烏地阿拉伯里亞爾';
        break;
      case 'NOK':
        rt = '挪威克朗';
        break;
      case 'SEK':
        rt = '瑞典克朗';
        break;
      case 'DKK':
        rt = '丹麥克朗';
        break;
      case 'PLN':
        rt = '波蘭茲羅提';
        break;
      case 'CZK':
        rt = '捷克克朗';
        break;
      case 'HUF':
        rt = '匈牙利福林';
        break;
      case 'ILS':
        rt = '以色列新謝克爾';
        break;
      case 'CLP':
        rt = '智利比索';
        break;
      case 'COP':
        rt = '哥倫比亞比索';
        break;
      case 'PEN':
        rt = '秘魯新索爾';
        break;
      case 'ARS':
        rt = '阿根廷比索';
        break;
      case 'DOP':
        rt = '多明尼加比索';
        break;
    }
    return rt;
  }

  /// 外幣幣別名稱轉代碼
  static String currencyNameToCode(String currencyName) {
    String rt = '';

    // 幣別中文名稱
    switch (currencyName) {
      case '全部':
        rt = 'All';
        break;
      case '請選擇':
        rt = 'PleaseSelect';
        break;
      case '美金':
        rt = 'USD';
        break;
      case '台幣':
        rt = 'TWD';
        break;
      case '日圓':
        rt = 'JPY';
        break;
      case '人民幣':
        rt = 'CNY';
        break;
      case '港幣':
        rt = 'HKD';
        break;
      case '歐元':
        rt = 'EUR';
        break;
      case '英鎊':
        rt = 'GBP';
        break;
      case '澳幣':
        rt = 'AUD';
        break;
      case '加幣':
        rt = 'CAD';
        break;
      case '紐幣':
        rt = 'NZD';
        break;
      case '新幣':
        rt = 'SGD';
        break;
      case '瑞士法郎':
        rt = 'CHF';
        break;
      case '泰銖':
        rt = 'THB';
        break;
      case '馬來幣':
        rt = 'MYR';
        break;
      case '菲律賓比索':
        rt = 'PHP';
        break;
      case '印尼盾':
        rt = 'IDR';
        break;
      case '越南盾':
        rt = 'VND';
        break;
      case '韓元':
        rt = 'KRW';
        break;
      case '印度盧比':
        rt = 'INR';
        break;
      case '巴西雷亞爾':
        rt = 'BRL';
        break;
      case '墨西哥比索':
        rt = 'MXN';
        break;
      case '南非幣':
        rt = 'ZAR';
        break;
      case '俄羅斯盧布':
        rt = 'RUB';
        break;
      case '土耳其里拉':
        rt = 'TRY';
        break;
      case '阿聯酋迪拉姆':
        rt = 'AED';
        break;
      case '沙烏地阿拉伯里亞爾':
        rt = 'SAR';
        break;
      case '挪威克朗':
        rt = 'NOK';
        break;
      case '瑞典克朗':
        rt = 'SEK';
        break;
      case '丹麥克朗':
        rt = 'DKK';
        break;
      case '波蘭茲羅提':
        rt = 'PLN';
        break;
      case '捷克克朗':
        rt = 'CZK';
        break;
      case '匈牙利福林':
        rt = 'HUF';
        break;
      case '以色列新謝克爾':
        rt = 'ILS';
        break;
      case '智利比索':
        rt = 'CLP';
        break;
      case '哥倫比亞比索':
        rt = 'COP';
        break;
      case '秘魯新索爾':
        rt = 'PEN';
        break;
      case '阿根廷比索':
        rt = 'ARS';
        break;
      case '多明尼加比索':
        rt = 'DOP';
        break;
    }
    return rt;
  }

  // fromJsonList
  static List<FetchAndExtract> fromJsonList(List<dynamic> list) {
    return list.map((e) {
      //print('FetchAndExtract e => $e');
      //print('FetchAndExtract => ${FetchAndExtract.fromJson(e)}');
      return FetchAndExtract.fromJson(e);
    }).toList();
  }

  // 將 JSON 轉換為 FetchAndExtract 物件
  factory FetchAndExtract.fromJson(Map<String, dynamic> json) {
    String tempUnitCurrency = json['unitCurrency'];
    String tempTargetCurrency = json['targetCurrency'];
    String tempCashBuyingRate = json['cashBuyRate'] ?? "0.0";
    String tempCashSellingRate = json['cashSellRate'] ?? "0.0";
    String tempSpotBuyingRate = json['spotBuyRate'] ?? "0.0";
    String tempSpotSellingRate = json['spotSellRate'] ?? "0.0";
    String tempBankName = json['bankName'];
    //String tempCode = json['code'];
    String tempUpdateTime = json['updatedTs'];
    //String tempLink = json['link'];

    //print('FetchAndExtract.fromJson => $tempUnitCurrency');
    return FetchAndExtract(
      unitCurrency: tempUnitCurrency,
      targetCurrency: tempTargetCurrency,
      cashBuyingRate:
          double.tryParse(tempCashBuyingRate.replaceAll(",", "")) ?? 0.0,
      cashSellingRate:
          double.tryParse(tempCashSellingRate.replaceAll(',', '')) ?? 0.0,
      spotBuyingRate:
          double.tryParse(tempSpotBuyingRate.replaceAll(",", "")) ?? 0.0,
      spotSellingRate:
          double.tryParse(tempSpotSellingRate.replaceAll(',', '')) ?? 0.0,
      bankName: tempBankName,
      //code: tempCode,
      updateTime: tempUpdateTime,
      //link: tempLink,
    );
  }
}

// 非同步資料提供
final fetchAndExtractProvider =
    FutureProvider<List<FetchAndExtract>>((ref) async {
  const String url = 'https://tw.stock.yahoo.com/currency-converter';
  try {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String htmlContent = response.body;

      // ✅ 使用正則表達式擷取 JSON
      RegExp regex = RegExp(r'(\[{"unitCurrency.*?"}\])');
      Match? match = regex.firstMatch(htmlContent);

      if (match != null) {
        String jsonStr = match.group(0)!;
        //print('jsonStr: $jsonStr');

        List<dynamic> dataList = jsonDecode(jsonStr);
        //print('dataList: $dataList[0]');
        List<FetchAndExtract> result = FetchAndExtract.fromJsonList(dataList);
        return result;
      } else {
        //print("找不到 JSON 資料");
      }
    } else {
      //print("HTTP 請求失敗，狀態碼: ${response.statusCode}");
    }
  } catch (e) {
    //print("發生錯誤: $e");
  }
  return [];
});
