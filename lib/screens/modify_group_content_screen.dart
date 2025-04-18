import 'package:flutter/material.dart';
import 'package:flutter_exchangeamountmanagement/data/currency_target.dart';
import 'package:flutter_exchangeamountmanagement/data/exchange_rate.dart';
import 'package:flutter_exchangeamountmanagement/screens/addrate_group_screen.dart';
import 'package:flutter_exchangeamountmanagement/screens/modify_group_contentdtl_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModifygroupcontentScreen extends ConsumerStatefulWidget {
  /// 群組ID
  final int groupID;

  /// 幣別匯率列表
  final List<FetchAndExtract> currencyRateList;

  /// 目標資料列表
  //final List<Currencytarget> currencyTargetList;

  const ModifygroupcontentScreen(
      {super.key,
      required this.groupID,
      required this.currencyRateList /*,
      required this.currencyTargetList*/
      });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ModifygroupcontentScreenState();
}

class ModifygroupcontentScreenState
    extends ConsumerState<ModifygroupcontentScreen> {
  @override
  Widget build(BuildContext context) {
    // 群組資料
    final List<Currencytarget> currencyTargetDataList =
        ref.watch(currencyTargetProvider);

    /*Currencytarget showData = widget.currencyTargetList
        .firstWhere((element) => element.groupID == widget.groupID);*/
    Currencytarget showData = currencyTargetDataList
        .firstWhere((element) => element.groupID == widget.groupID);

    /// 總金額
    double totalCost = showData.getTotalCost();

    /// 達成率
    int persent = ((totalCost / showData.targetTotalCost) * 100).toInt();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text('${showData.groupName}')),
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddrategroupScreen(
                          groupID: widget.groupID,
                          currencyRateList: widget.currencyRateList,
                          currencyTargetList:
                              currencyTargetDataList /*widget.currencyTargetList*/),
                    ),
                  );
                },
                icon: Icon(Icons
                    .edit)) /*,
            IconButton(
                onPressed: () {
                  setState(() {
                    // 刪除資料
                    ref
                        .read(currencyTargetProvider.notifier)
                        .remove(showData.groupID ?? 0);
                    Navigator.of(context).pop();
                  });
                },
                icon: Icon(Icons.delete_forever))*/
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            /* 兌換總資訊 */
            Card(
                child: Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                        child: Text(
                            "預定日期: ${showData.dateBeg} ~ ${showData.dateEnd}"),
                      ),
                      SizedBox(
                        height: 20,
                        child: Text(
                            "目標金額: ${Currencytarget.getThousandthsCost(totalCost)}/${Currencytarget.getThousandthsCost(showData.targetTotalCost)} ($persent%) ${showData.currency}"),
                      ),
                      SizedBox(
                        height: 20,
                        child: Text("已兌換金額: ${showData.getTwTotalCost()} TWD"),
                      ),
                    ],
                  )),
                ],
              ),
            )),
            /* 灰色格線 & 明細新增 */
            Row(
              children: [
                Expanded(
                  child: Divider(),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ModifygroupcontentdtlScreen(
                              groupID: widget.groupID,
                              dtlID: 0,
                              currencyRateList: widget.currencyRateList,
                              currencyTargetList:
                                  currencyTargetDataList /*widget.currencyTargetList*/),
                        ),
                      );
                    },
                    icon: Icon(Icons.playlist_add))
              ],
            ),
            /* 明細列表 */
            Expanded(
              child: ListView.builder(
                itemCount: showData.currencytargetDtlList!.length,
                itemBuilder: (context, index) {
                  //CurrencytargetDtl dtlItem = showData.currencytargetDtlList![index];

                  return ListTile(
                      title: Text(
                        "兌換日期 2025-01-02",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("當日匯率: 0.20"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("兌換金額: 100 TWD"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("外幣金額: 500 JPY"),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.delete,
                            size: 20,
                          )));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
