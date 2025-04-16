import 'package:flutter/material.dart';
import 'package:flutter_exchangeamountmanagement/data/exchangerate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExchangerateScreen extends ConsumerStatefulWidget {
  //final Future<List<FetchAndExtract>> futureList;
  final List<FetchAndExtract> futureList;
  const ExchangerateScreen({super.key, required this.futureList});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ExchangerateScreenState();
}

class ExchangerateScreenState extends ConsumerState<ExchangerateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('匯率查詢'),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            /*FutureBuilder<List<FetchAndExtract>>(
              future: widget.futureList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('查無資料');
                }

                // ✅ 有資料的情況下，開始顯示列表
                List<FetchAndExtract> data = snapshot.data!;

                /*return Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return Card(
                        child: ListTile(
                          title: Text(
                              '${item.unitCurrency} → ${item.targetCurrency}'),
                          subtitle: Text(
                              '即期買入: ${item.cashBuyingRate}, 即期賣出: ${item.cashSellingRate}\n'
                              '銀行: ${item.bankName}, 更新時間: ${item.updateTime}'),
                        ),
                      );
                    },
                  ),
                );// */
                return Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];

                      String cashBuyingRate = item.cashBuyingRate == 0
                          ? "-"
                          : item.cashBuyingRate.toString();

                      String cashSellingRate = item.cashSellingRate == 0
                          ? "-"
                          : item.cashSellingRate.toString();

                      String spotBuyingRate = item.spotBuyingRate == 0
                          ? "-"
                          : item.spotBuyingRate.toString();

                      String spotSellingRate = item.spotSellingRate == 0
                          ? "-"
                          : item.spotSellingRate.toString();

                      return ListTile(
                          title: Text(
                              "幣別: ${item.unitCurrencyName}(${item.unitCurrency})"),
                          subtitle: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text("即期買入: $cashBuyingRate")),
                                  Expanded(
                                      child: Text("即期賣出: $cashSellingRate")),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text("現金買入: $spotBuyingRate")),
                                  Expanded(
                                      child: Text("現金賣出: $spotSellingRate")),
                                ],
                              ),
                            ],
                          ));
                    },
                  ),
                );
              },
            ) // */
            Expanded(
              child: ListView.builder(
                itemCount: widget.futureList.length,
                itemBuilder: (context, index) {
                  final item = widget.futureList[index];

                  String cashBuyingRate = item.cashBuyingRate == 0
                      ? "-"
                      : item.cashBuyingRate.toString();

                  String cashSellingRate = item.cashSellingRate == 0
                      ? "-"
                      : item.cashSellingRate.toString();

                  String spotBuyingRate = item.spotBuyingRate == 0
                      ? "-"
                      : item.spotBuyingRate.toString();

                  String spotSellingRate = item.spotSellingRate == 0
                      ? "-"
                      : item.spotSellingRate.toString();

                  return ListTile(
                      title: Text(
                          "幣別: ${item.currencyCodeToName()}(${item.unitCurrency})"),
                      subtitle: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text("即期買入: $cashBuyingRate")),
                              Expanded(child: Text("即期賣出: $cashSellingRate")),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text("現金買入: $spotBuyingRate")),
                              Expanded(child: Text("現金賣出: $spotSellingRate")),
                            ],
                          ),
                        ],
                      ));
                },
              ),
            )
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
