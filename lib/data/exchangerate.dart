import 'package:http/http.dart' as http;

Future<String> fetchAndExtractJson() async {
  const String url = 'https://tw.stock.yahoo.com/currency-converter';
  try {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String htmlContent = response.body;

      // ✅ 使用正則表達式擷取 JSON
      RegExp regex = RegExp(r'(\[{"unitCurrency.*?"}\])');
      Match? match = regex.firstMatch(htmlContent);

      if (match != null) {
        return match.group(1) ?? "";
      }
    } else {
      print("HTTP 請求失敗，狀態碼: ${response.statusCode}");
    }
  } catch (e) {
    print("發生錯誤: $e");
  }
  return "";
}


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



