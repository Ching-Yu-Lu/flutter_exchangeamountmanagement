import 'package:flutter/material.dart';
import 'package:flutter_exchangeamountmanagement/data/currencyTarget.dart';
import 'package:flutter_exchangeamountmanagement/data/exchangerate.dart';
import 'package:flutter_exchangeamountmanagement/screens/addrategroup_screen.dart';
import 'package:flutter_exchangeamountmanagement/screens/exchangerate_screen.dart';
import 'package:flutter_exchangeamountmanagement/screens/modifygroupcontent_screen.dart';
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
  //late Future<List<FetchAndExtract>> futureDataList;

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
    final List<Currencytarget> currencyTargetList =
        ref.watch(currencyTargetProvider);

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
                                      currencyRateList: currencyRateDataList),
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
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(
                            width: 100,
                            height: 51,
                            child: DropdownButtonFormField(
                              value: currencySelect,
                              decoration: // rouned all borders
                                  InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              items: currencySelectListList.map((item) {
                                return DropdownMenuItem(
                                  value: item.unitCurrency,
                                  child: Text(item.unitCurrency),
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
                            ),
                          )
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
                                        '${selectedDateBeg.year}-${selectedDateBeg.month.toString().padLeft(2, '0')}-${selectedDateBeg.day.toString().padLeft(2, '0')}',
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
        body: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "待完成: {.length}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
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
                            value: false, //widget.switchStatus,
                            onChanged: (v) {
                              setState(() {
                                /*ref
                                    .read(isShowAllProvider.notifier)
                                    .toggle(!widget.switchStatus);*/
                                //print("BuildSwitchState Change Stataus is: ${widget.switchStatus}");
                              });
                            })
                      ],
                    ))
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: currencyTargetList.length,
                    itemBuilder: (context, index) {
                      Currencytarget showItem = currencyTargetList[index];
                      return ListTile(
                          title: Text("名稱: ${showItem.groupName}"),
                          subtitle: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("預定日期: "),
                                  Expanded(
                                      child: Text("2025-01-01 ~ 2025-06-01"))
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("目標金額: "),
                                  Expanded(child: Text("10000/100000(10%) JPY"))
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ModifygroupcontentScreen(
                                            groupID: index,
                                            currencyRateList:
                                                currencyRateDataList),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.edit,
                                size: 20,
                              )));
                    },
                  ),
                )
              ],
            )));
  }
}
