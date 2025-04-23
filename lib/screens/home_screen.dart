import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exchangeamountmanagement/data/currency_target.dart';
import 'package:flutter_exchangeamountmanagement/data/exchange_rate.dart';
import 'package:flutter_exchangeamountmanagement/screens/addrate_group_screen.dart';
import 'package:flutter_exchangeamountmanagement/screens/exchange_rate_screen.dart';
import 'package:flutter_exchangeamountmanagement/screens/modify_group_content_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  String currencySelect = 'All';
  int pickerRangeDays = 720;
  DateTime selectedDateBeg = DateTime.now().add(const Duration(days: -30));
  DateTime selectedDateEnd = DateTime.now().add(const Duration(days: 30));
  bool completeShowStatus = false;

  @override
  Widget build(BuildContext context) {
    // 監聽(取得幣別匯率資料)
    final futureDataList = ref.watch(fetchAndExtractProvider);
    // 幣別匯率資料
    final List<FetchAndExtract> currencyRateDataList =
        futureDataList.value ?? [];
    // 幣別選單資料
    final List<FetchAndExtract> currencySelectListList = [
      FetchAndExtract(
          unitCurrency: 'All',
          targetCurrency: 'All',
          cashBuyingRate: 0.0,
          cashSellingRate: 0.0,
          spotBuyingRate: 0.0,
          spotSellingRate: 0.0,
          bankName: '',
          updateTime: ''),
    ];
    currencySelectListList.addAll(currencyRateDataList);
    // 群組資料
    final currencyTargetDataList = ref.watch(currencyTargetProvider);

    // 根據查詢條件顯示資料
    final filteredTargetDataList = currencyTargetDataList.where((targetData) {
      bool showYN = true;

      // 顯示已完成 N
      if (showYN && !completeShowStatus) {
        showYN = targetData.isComplete();
      }

      // 非全選
      if (showYN && currencySelect != 'All') {
        showYN = targetData.currency == currencySelect;
      }

      // 查詢日期
      String strselectBeg = formatDate(selectedDateBeg, [yyyy, '', mm, '', dd]);
      int numselectBeg = int.parse(strselectBeg);

      String strselectEnd = formatDate(selectedDateEnd, [yyyy, '', mm, '', dd]);
      int numselectEnd = int.parse(strselectEnd);

      // 列表日期
      DateTime dataBeg = DateTime.parse(targetData.dateBeg);
      String strDataBeg = formatDate(dataBeg, [yyyy, '', mm, '', dd]);
      int numDataBeg = int.parse(strDataBeg);

      DateTime dataEnd = DateTime.parse(targetData.dateEnd);
      String strDataEnd = formatDate(dataEnd, [yyyy, '', mm, '', dd]);
      int numDataEnd = int.parse(strDataEnd);

      // 日期區間
      if (showYN) {
        showYN = ((numselectBeg <= numDataBeg && numselectEnd >= numDataBeg) ||
            (numselectBeg <= numDataEnd && numselectEnd >= numDataEnd) ||
            (numDataBeg <= numselectBeg && numDataEnd >= numselectBeg) ||
            (numDataBeg <= numselectEnd && numDataEnd >= numselectEnd));
      }

      return showYN;
    }).toList();

    // 兌換目標資料(未完成)
    final unCompletedList = currencyTargetDataList
        .where((items) => items.getTotalCost() < items.targetTotalCost)
        .toList();

    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 150,
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(
                      "兌換目標",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    )),
                    Row(
                      children: [
                        /* 兌換倍率資料頁面按鈕 */
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ExchangerateScreen(
                                      futureList: currencyRateDataList),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.currency_exchange,
                              size: 28,
                            )),
                        SizedBox(width: 10),
                        /* 群組新增頁面按鈕 */
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AddrategroupScreen(
                                      currencyRateList: currencyRateDataList,
                                      currencyTargetList:
                                          currencyTargetDataList),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.add_to_photos,
                              size: 28,
                            )),
                      ],
                    )
                  ],
                ),
                /* 查詢條件 */
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Row(
                    spacing: 5,
                    children: [
                      /* 幣別 */
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '幣別',
                            style: TextStyle(fontSize: 13),
                          ),
                          SizedBox(
                              width: 100,
                              height: 52,
                              child: DropdownButtonFormField(
                                isExpanded: true, // 選項 Overflow 要開這個
                                value: currencySelect,
                                decoration: // rouned all borders
                                    InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: currencySelectListList.map((item) {
                                  String unitCurrencyName =
                                      FetchAndExtract.currencyCodeToNameStatic(
                                          item.unitCurrency);
                                  return DropdownMenuItem(
                                    value: item.unitCurrency,
                                    child: Text(
                                      unitCurrencyName,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (v) {
                                  setState(() {
                                    currencySelect = v as String;
                                    //print('currencySelect => $currencySelect');
                                  });
                                  // wait 1 second
                                  /*Future.delayed(Duration(seconds: 1), () {
                                  setState(() {});
                                });*/
                                },
                              ))
                        ],
                      ),
                      /* 查詢日期(起) */
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '查詢日期(起)',
                              style: TextStyle(fontSize: 14),
                            ),
                            InkWell(
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: selectedDateBeg,
                                  firstDate: DateTime.now()
                                      .add(Duration(days: -pickerRangeDays)),
                                  lastDate: DateTime.now()
                                      .add(Duration(days: pickerRangeDays)),
                                ).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      selectedDateBeg = value;

                                      Duration difference = selectedDateBeg
                                          .difference(selectedDateEnd);
                                      if (difference.inSeconds > 0) {
                                        selectedDateEnd = selectedDateBeg;
                                      }
                                    });
                                    // wait 1 second
                                    Future.delayed(Duration(seconds: 1), () {
                                      setState(() {});
                                    });
                                  }
                                });
                              },
                              child: Container(
                                decoration: // rouned all borders
                                    BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 15),
                                      child: Text(
                                          '${selectedDateBeg.year}-${selectedDateBeg.month.toString().padLeft(2, '0')}-${selectedDateBeg.day.toString().padLeft(2, '0')}',
                                          style: TextStyle(fontSize: 14)),
                                    ),
                                  ],
                                ),
                              ),
                            ), // */
                          ],
                        ),
                      ),
                      /* 查詢日期(迄) */
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '查詢日期(迄)',
                              style: TextStyle(fontSize: 14),
                            ),
                            InkWell(
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: selectedDateEnd,
                                  firstDate: DateTime.now()
                                      .add(Duration(days: -pickerRangeDays)),
                                  lastDate: DateTime.now()
                                      .add(Duration(days: pickerRangeDays)),
                                ).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      selectedDateEnd = value;

                                      Duration difference = selectedDateBeg
                                          .difference(selectedDateEnd);
                                      if (difference.inSeconds > 0) {
                                        selectedDateEnd = selectedDateBeg;
                                      }
                                    });
                                    // wait 1 second
                                    Future.delayed(Duration(seconds: 1), () {
                                      setState(() {});
                                    });
                                  }
                                });
                              },
                              child: Container(
                                decoration: // rouned all borders
                                    BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 15),
                                      child: Text(
                                        '${selectedDateEnd.year}-${selectedDateEnd.month.toString().padLeft(2, '0')}-${selectedDateEnd.day.toString().padLeft(2, '0')}',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ), // */
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                /* 灰色格線 */
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  child: Divider(),
                ),
              ],
            )),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "待完成: ${unCompletedList.length}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "顯示已完成",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Switch(
                          value: completeShowStatus,
                          onChanged: (v) {
                            setState(() {
                              completeShowStatus = !completeShowStatus;
                            });
                          })
                    ],
                  ))
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTargetDataList.length,
                itemBuilder: (context, index) {
                  Currencytarget showItem = filteredTargetDataList[index];

                  /// 群組編號
                  int gid = showItem.groupID;

                  /// 總金額
                  double totalCost = showItem.getTotalCost();

                  /// 達成率
                  int persent =
                      ((totalCost / showItem.targetTotalCost) * 100).toInt();
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// 資料顯示區塊
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ID: ${showItem.groupID},名稱: ${showItem.groupName}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Text("預定日期: "),
                                    Flexible(
                                      child: Text(
                                          "${showItem.dateBeg} ~ ${showItem.dateEnd}"),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Text("目標金額: "),
                                    Flexible(
                                      child: Text(
                                        "${Currencytarget.getThousandthsCost(totalCost)}/${Currencytarget.getThousandthsCost(showItem.targetTotalCost)} ($persent%) ${FetchAndExtract.currencyCodeToNameStatic('${showItem.currency}')}",
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          /// 按鈕區塊
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /// 編輯按鈕
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ModifygroupcontentScreen(
                                        groupID: gid,
                                        currencyRateList: currencyRateDataList,
                                      ),
                                    ),
                                  );
                                },
                              ),

                              /// 刪除按鈕
                              IconButton(
                                icon: const Icon(Icons.delete, size: 20),
                                onPressed: () {
                                  setState(() {
                                    ref
                                        .read(currencyTargetProvider.notifier)
                                        .remove(gid);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }
}
