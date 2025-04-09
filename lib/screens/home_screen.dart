import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int numberOfPeople = 1;
  int pickerRangeDays = 720;
  DateTime selectedDateBeg = DateTime.now().add(const Duration(days: -30));
  DateTime selectedDateEnd = DateTime.now().add(const Duration(days: 30));
  @override
  Widget build(BuildContext context) {
    //print("selectedDateBeg: $selectedDateBeg");
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
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.currency_exchange,
                              size: 28,
                            )),
                        SizedBox(width: 10),
                        IconButton(
                            onPressed: () {},
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
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '幣別',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(
                              width: 110,
                              height: 51,
                              child: DropdownButtonFormField(
                                value: numberOfPeople,
                                decoration: // rouned all borders
                                    InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: // 0 to 6
                                    List.generate(
                                  7,
                                  (index) => DropdownMenuItem(
                                    value: index + 1,
                                    child: Text('${index + 1}人'),
                                  ),
                                ),
                                onChanged: (v) {
                                  setState(() {
                                    numberOfPeople = v as int;
                                  });
                                  // wait 1 second
                                  Future.delayed(Duration(seconds: 1), () {
                                    setState(() {});
                                  });
                                },
                              ),
                            )
                          ],
                        ),
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
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    // arrow down icon
                                    Icon(Icons.arrow_drop_down),
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
                                    // arrow down icon
                                    Icon(Icons.arrow_drop_down),
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
                SizedBox(
                  height: 450,
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Text("Item $index"),
                          subtitle: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("幣別"),
                                  Text("金額"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("幣別"),
                                  Text("金額"),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                              onPressed: () {},
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
