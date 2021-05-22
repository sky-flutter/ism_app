import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ism_app/src/model/receipt_data.dart';
import 'package:ism_app/src/screens/home/bloc/home_bloc.dart';
import 'package:ism_app/src/screens/home/bloc/home_event.dart';
import 'package:ism_app/src/screens/home/model/menu_type.dart';
import 'package:ism_app/src/screens/home/model/store_type.dart';
import 'package:ism_app/src/screens/receipts/receipts/bloc/receipt_event.dart';
import 'package:ism_app/src/screens/receipts/receipts/bloc/receipts_bloc.dart';
import 'package:ism_app/src/screens/receipts/receipts/receipts.dart';
import 'package:ism_app/src/utils/error_handler.dart';
import 'package:ism_app/src/widgets/container/container.dart';
import 'package:ism_app/src/widgets/container/container_shadow.dart';
import 'package:ism_app/src/widgets/container/item_container.dart';
import 'package:ism_app/src/widgets/dropdown/dropdown.dart';
import 'package:ism_app/src/widgets/error.dart';
import 'package:ism_app/src/widgets/loading/loader.dart';

import '../../../imports.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<StoreType> storeType;
  List<MenuType> menuType;
  StoreType selectedValue;
  ReceiptsBloc receiptBloc;
  HomeBloc homeBloc;

  List<ReceiptData> listReceiptData;
  List<int> listCount = [0, 1, 3, -1];

  @override
  void initState() {
    super.initState();
    homeBloc = HomeBloc();
    receiptBloc = ReceiptsBloc();
    homeBloc.add(GetAllProductLotEvent());
    homeBloc.add(GetAllProductEvent());
    homeBloc.add(GetLocationEvent());
    receiptBloc.add(GetAllReceiptsEvent());
    createStoreType();
    createMenuType();
  }

  createStoreType() {
    storeType = [];
    storeType.add(StoreType("Warehouse"));
    storeType.add(StoreType("Purchase"));
    storeType.add(StoreType("Sales"));
    storeType.add(StoreType("Marketing"));
    selectedValue = storeType[0];
  }

  createMenuType() {
    menuType = [];
    menuType.add(MenuType(
        typeTitle: "Receipts",
        typeSubTitle: "Warehouse Afrobio",
        received: "to Receive",
        routeName: Routes.strReceiptsRoute,
        imagePath: Strings.icReceipt));

    menuType.add(MenuType(
        typeTitle: "Internal Transfers",
        typeSubTitle: "Warehouse Afrobio",
        received: "Transfer",
        imagePath: Strings.icInternalTransfer));

    menuType.add(MenuType(
        typeTitle: "Delivery Order",
        typeSubTitle: "Warehouse Afrobio",
        received: "To Do",
        imagePath: Strings.icDeliveryOrder));

    menuType.add(MenuType(
        typeTitle: "Inventory Modules",
        typeSubTitle: "Warehouse Afrobio",
        received: "",
        imagePath: Strings.icInventoryModule));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (BuildContext context) => homeBloc,
        ),
        BlocProvider<ReceiptsBloc>(
          create: (BuildContext context) => receiptBloc,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ReceiptsBloc, BaseState>(listener: (context, state) {
            if (state is DataState) {
              listReceiptData = state.data;
              countReceiptData();
            }
          })
        ],
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: Icon(Icons.menu),
            title: MyText(
              Strings.home,
              color: MyColors.color_FFFFFF,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          body: BlocBuilder<HomeBloc, BaseState>(
            builder: (context, state) {
              return AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: getView(state),
              );
            },
          ),
        ),
      ),
    );
  }

  getView(BaseState state) {
    if (state is DataState) {
      return MyContainer(
        bgColor: MyColors.color_F8FAFB,
        children: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: MyShadowContainer(
                  margin: const EdgeInsets.only(top: 18, right: 17),
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: MyDropDown<StoreType>(
                    storeType,
                    selectedValue,
                    onChangeListener: (data) {
                      selectedValue = data;
                      setState(() {});
                    },
                  ),
                  borderRadius: BorderRadius.circular(90),
                  shadowColor: Color(0x0A0F3712),
                ),
              ),
              ListView.builder(
                itemBuilder: (context, index) {
                  return ListItem(menuType[index], () {
                    if (menuType[index].routeName == Routes.strReceiptsRoute) {
                      if (listReceiptData != null) {
                        Get.to(() => Receipts(listReceiptData));
                      } else {
                        showSnackBar(
                            "Loading", "Please wait until data loaded");
                      }
                    }
                  }, count: listCount[index]);
                },
                itemCount: menuType.length,
                shrinkWrap: true,
                primary: false,
              )
            ],
          ),
        ),
      );
    }
    if (state is ErrorState) {
      return ErrorView(state.errorMessage ??
          ErrorHandler.getErrorMessage(state.errorCode) ??
          "");
    }
    if (state is LoadingState) {
      return Loader();
    }
    return Container();
  }

  void countReceiptData() {
    int receiptCount = listReceiptData
        .where((element) => element.internalType.toLowerCase() == "receipt")
        .toList()
        .length;
    listCount[0] = receiptCount;
    setState(() {});
  }

  @override
  void dispose() {
    homeBloc.close();
    receiptBloc.close();
    super.dispose();
  }
}

class ListItem extends StatelessWidget {
  MenuType menuType;
  Function onTap;
  int count;

  ListItem(this.menuType, this.onTap, {this.count});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: MyBorder.commonBorderRadius(),
      onTap: onTap,
      child: MyItemContainer(
        margin: const EdgeInsets.only(top: 28, left: 20, right: 20),
        outlineColor: MyColors.color_E2E9EF,
        shadowColor: MyColors.color_0A0F3712,
        children: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(
                  top: 23, bottom: 23, left: 15, right: 12),
              child: SvgPicture.asset(menuType.imagePath),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    menuType.typeTitle,
                    fontWeight: FontWeight.bold,
                    color: MyColors.color_F18719,
                    fontSize: 16,
                  ),
                  MyText(
                    menuType.typeSubTitle,
                    fontSize: 14,
                    color: MyColors.color_6E7578,
                    fontWeight: FontWeight.normal,
                  )
                ],
              ),
            ),
            if (count >= 0)
              Container(
                width: 100,
                child: MyShadowContainer(
                  shadowColor: MyColors.color_2FA1DB.withOpacity(.2),
                  bgColor: MyColors.color_2FA1DB,
                  margin: const EdgeInsets.only(right: 14),
                  padding: const EdgeInsets.only(
                      left: 13, top: 6, bottom: 5, right: 12),
                  borderRadius: BorderRadius.circular(50),
                  child: Center(
                    child: MyText(
                      "$count ${menuType.received}",
                      color: MyColors.color_FFFFFF,
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            Container(
              child: Icon(
                Icons.arrow_forward,
                color: MyColors.color_6E7578,
              ),
              margin: const EdgeInsets.only(right: 15),
            )
          ],
        ),
      ),
    );
  }
}
