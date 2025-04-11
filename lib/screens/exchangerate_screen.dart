import 'package:flutter/material.dart';
import 'package:flutter_exchangeamountmanagement/data/exchangerate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExchangerateScreen extends ConsumerStatefulWidget {
  const ExchangerateScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ExchangerateScreenState();
}

class ExchangerateScreenState extends ConsumerState<ExchangerateScreen> {
  late Future<String> futureHtml;

  @override
  void initState() {
    super.initState();
    futureHtml = fetchAndExtractJson(); // ✅ 在 initState() 執行非同步請求
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('rate'),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            /*FutureBuilder<String>(
              future: futureHtml,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // 顯示 loading
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // 顯示錯誤
                } else {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      snapshot.data ?? "No Data",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ); // 顯示 HTML 內容
                }
              },
            ) // */
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text("幣別 TWD"),
                      subtitle: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text("即期買入: ＄Rate1")),
                              Expanded(child: Text("即期賣出: ＄Rate2")),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text("現金買入: ＄Rate3")),
                              Expanded(child: Text("現金賣出: ＄Rate4")),
                            ],
                          ),
                        ],
                      ));
                },
              ),
            ), // */
          ],
        ),
      ),
    );
  }
}
/*
  現金匯率 vs 即期匯率 差異
    現金匯率 => 將手上的實體台幣或外幣，向銀行買入或賣出外幣，金額以變動的匯率為主，但匯率比較高。
    即期匯率 => 是用帳戶中的台幣或外幣，直接在帳戶中做進出交易，不會有實體的鈔票，但匯率比較低。
*/
