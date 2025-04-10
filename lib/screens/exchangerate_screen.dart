import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExchangerateScreen extends ConsumerStatefulWidget {
  const ExchangerateScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ExchangerateScreenState();
}

class ExchangerateScreenState extends ConsumerState<ExchangerateScreen> {
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
            SizedBox(
              height: 500,
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
            ),
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
