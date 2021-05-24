import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:ism_app/imports.dart';
import 'package:ism_app/src/model/receipt_data.dart';
import 'package:ism_app/src/screens/receipts/details/receipt_details.dart';
import 'package:ism_app/src/screens/receipts/receipts/bloc/receipt_state.dart';
import 'package:ism_app/src/widgets/container/container.dart';
import 'package:ism_app/src/widgets/container/container_shadow.dart';
import 'package:ism_app/src/widgets/container/item_container.dart';
import 'package:ism_app/src/widgets/input/text_field_icon.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc/receipt_event.dart';
import 'bloc/receipts_bloc.dart';

class Receipts extends StatefulWidget {
  List<ReceiptData> listReceiptData;

  Receipts(this.listReceiptData);

  @override
  _ReceiptsState createState() => _ReceiptsState();
}

class _ReceiptsState extends State<Receipts>
    with SingleTickerProviderStateMixin {
  final searchOnChange = new BehaviorSubject<String>();
  TabController tabController;
  int tabIndex = 0;
  ReceiptsBloc _receiptsBloc;
  PageController pageController;
  List<ReceiptData> listReceiptData = [];
  List<ReceiptData> listIncomingData = [];
  List<ReceiptData> listReceiptDataCopy = [];
  List<ReceiptData> listIncomingDataCopy = [];
  var tabTextStyle =
      Style.normal.copyWith(fontWeight: FontWeight.bold, fontSize: 14);
  DateTime dateTime = DateTime.now();

  TextEditingController ctrlSearchReceiptData = TextEditingController();
  TextEditingController ctrlSearchIncomingData = TextEditingController();

  @override
  void initState() {
    super.initState();
    _receiptsBloc = ReceiptsBloc();
    _receiptsBloc.add(GetCachedReceiptDataEvent());
    _receiptsBloc.add(GetCachedIncomingDataEvent());
    pageController = PageController(initialPage: tabIndex);
    tabController = TabController(length: 2, vsync: this);
    tabController.animateTo(0);

    _receiptsBloc.getCachedReceiptData().listen((event) {
      if (event is ReceiptDataState) {
        listReceiptData = event.data;
        listReceiptDataCopy = event.data;
        setState(() {});
      }
    });
    _receiptsBloc.getCachedIncomingData().listen((event) {
      if (event is IncomingDataState) {
        listIncomingDataCopy = event.data;
        listIncomingData = event.data;
        setState(() {});
      }
    });

    searchOnChange.debounceTime(Duration(seconds: 1)).listen((event) {
      if (event.isNotEmpty) {
        search(event);
      } else {
        clearSearchData();
      }
    });
  }

  _onTabChange(int index) {
    pageController.jumpToPage(index);
    tabController.animateTo(index);
  }

  _onSearchTextChanged(String str) {
    searchOnChange.add(str);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReceiptsBloc>(
      create: (context) => _receiptsBloc,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back,
              color: MyColors.color_FFFFFF,
            ),
            onTap: () {
              MyNavigator.navState.pop();
            },
          ),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 56),
            child: TabBar(
              indicatorColor: Colors.white,
              unselectedLabelColor: Colors.black,
              labelColor: Colors.white,
              labelStyle: tabTextStyle,
              unselectedLabelStyle: tabTextStyle,
              onTap: _onTabChange,
              tabs: [
                Tab(
                  child: Text("RECEIPTS"),
                ),
                Tab(
                  child: Text("INTERNAL"),
                ),
              ],
              controller: tabController,
            ),
          ),
          title: MyText(
            Strings.receipts,
            color: MyColors.color_FFFFFF,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        body: MyContainer(
          bgColor: MyColors.color_F8FAFB,
          children: Column(
            children: [
              Expanded(
                child: PageView(
                  onPageChanged: (int index) {
                    tabController.animateTo(index);
                  },
                  controller: pageController,
                  children: [
                    Column(
                      children: [
                        MyTextFieldPrefixSuffix(
                          hint: Strings.search,
                          controller: ctrlSearchReceiptData,
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 26),
                          outlineColor: MyColors.color_E2E9EF,
                          keyboardType: TextInputType.text,
                          onChanged: _onSearchTextChanged,
                          suffix: Container(
                            margin: const EdgeInsets.only(right: 19),
                            child: GestureDetector(
                              onTap: () {},
                              child: Icon(Icons.filter_alt_outlined),
                            ),
                          ),
                          focusedColor: MyColors.color_F18719,
                          prefix: Container(
                            child: Icon(
                              Icons.search,
                              color: MyColors.color_3F4446,
                            ),
                            margin: EdgeInsets.only(left: 19),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return InkWell(
                                borderRadius: MyBorder.commonBorderRadius(),
                                onTap: () {
                                  Get.to(() =>
                                      ReceiptDetails(listReceiptData[index]));
                                },
                                child: ListItem(
                                  index: index,
                                  receiptData: listReceiptData[index],
                                ),
                              );
                            },
                            itemCount: listReceiptData.length,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        MyTextFieldPrefixSuffix(
                          hint: Strings.search,
                          controller: ctrlSearchIncomingData,
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 26),
                          outlineColor: MyColors.color_E2E9EF,
                          keyboardType: TextInputType.text,
                          onChanged: _onSearchTextChanged,
                          suffix: Container(
                            margin: const EdgeInsets.only(right: 19),
                            child: GestureDetector(
                              onTap: () {},
                              child: Icon(Icons.filter_alt_outlined),
                            ),
                          ),
                          focusedColor: MyColors.color_F18719,
                          prefix: Container(
                            child: Icon(
                              Icons.search,
                              color: MyColors.color_3F4446,
                            ),
                            margin: EdgeInsets.only(left: 19),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return ListItem(
                                index: index,
                                receiptData: listIncomingData[index],
                              );
                            },
                            itemCount: listIncomingData.length,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void clearSearchData() {
    if (tabController.index == 0) {
      listReceiptData = listReceiptDataCopy;
    } else {
      listIncomingData = listIncomingDataCopy;
    }
    setState(() {});
  }

  void search(String search) async {
    if (tabController.index == 0) {
      listReceiptData = await filterSearchData(search, listReceiptDataCopy);
    } else {
      listIncomingData = await filterSearchData(search, listIncomingDataCopy);
    }
    setState(() {});
  }

  Future<List<ReceiptData>> filterSearchData(
      String search, List<ReceiptData> listData) async {
    search = search.toLowerCase();
    return await Future.delayed(Duration(seconds: 1), () {
      return listReceiptDataCopy
          .where((element) =>
              element.name.toLowerCase().contains(search) ||
              element.origin.contains(search) ||
              element.location.contains(search))
          .toList();
    });
  }
}

class ListItem extends StatelessWidget {
  final int index;
  ReceiptData receiptData;

  ListItem({this.index, this.receiptData});

  @override
  Widget build(BuildContext context) {
    return MyItemContainer(
      margin: EdgeInsets.only(
        top: index == 0 ? 14 : 0,
        bottom: 14,
        left: 20,
        right: 20,
      ),
      outlineColor: MyColors.color_E2E9EF,
      padding: EdgeInsets.only(left: 14, top: 13, bottom: 12),
      shadowColor: MyColors.color_0A0F3712,
      children: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  receiptData.name,
                  fontWeight: FontWeight.bold,
                  color: MyColors.color_3F4446,
                  fontSize: 16,
                ),
                MyText(
                  receiptData.origin,
                  fontSize: 14,
                  color: MyColors.color_F18719,
                  fontWeight: FontWeight.normal,
                ),
                SizedBox(
                  height: 4,
                ),
                MyText(
                  parseDate(receiptData.date),
                  fontSize: 12,
                  color: MyColors.color_6E7578,
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),
          ),
          Container(
            child: MyShadowContainer(
              shadowColor: MyColors.color_2FA1DB.withOpacity(.2),
              bgColor: MyColors.color_2FA1DB,
              margin: const EdgeInsets.only(right: 14),
              padding:
                  const EdgeInsets.only(left: 21, top: 6, bottom: 5, right: 21),
              borderRadius: BorderRadius.circular(50),
              child: Center(
                child: MyText(
                  "Ready",
                  color: MyColors.color_FFFFFF,
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
