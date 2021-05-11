import 'package:ism_app/src/screens/home/model/menu_type.dart';
import 'package:ism_app/src/screens/home/model/store_type.dart';
import 'package:ism_app/src/widgets/container/container.dart';
import 'package:ism_app/src/widgets/container/container_shadow.dart';
import 'package:ism_app/src/widgets/container/item_container.dart';
import 'package:ism_app/src/widgets/dropdown/dropdown.dart';

import '../../../imports.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<StoreType> storeType;
  List<MenuType> menuType;
  StoreType selectedValue;

  @override
  void initState() {
    super.initState();
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
        received: "3 to Receive",
        routeName: Routes.strReceiptsRoute,
        imagePath: Strings.icReceipt));

    menuType.add(MenuType(
        typeTitle: "Internal Transfers",
        typeSubTitle: "Warehouse Afrobio",
        received: "1 Transfer",
        imagePath: Strings.icInternalTransfer));

    menuType.add(MenuType(
        typeTitle: "Delivery Order",
        typeSubTitle: "Warehouse Afrobio",
        received: "3 To Do",
        imagePath: Strings.icDeliveryOrder));

    menuType.add(MenuType(
        typeTitle: "Inventory Modules",
        typeSubTitle: "Warehouse Afrobio",
        received: "",
        imagePath: Strings.icInventoryModule));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: MyContainer(
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
                  return ListItem(menuType[index]);
                },
                itemCount: menuType.length,
                shrinkWrap: true,
                primary: false,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  MenuType menuType;

  ListItem(this.menuType);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: MyBorder.commonBorderRadius(),
      onTap: () {
        if(menuType.routeName.isNotEmpty){
          MyNavigator.pushNamed(menuType.routeName);
        }
      },
      child: MyItemContainer(
        margin: const EdgeInsets.only(top: 28, left: 20, right: 20),
        outlineColor: MyColors.color_E2E9EF,
        shadowColor: MyColors.color_0A0F3712,
        children: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(
                  top: 23, bottom: 23, left: 15, right: 12),
              child: Image.asset(
                menuType.imagePath,
              ),
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
            if (menuType.received.length > 0)
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
                      menuType.received,
                      color: MyColors.color_FFFFFF,
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            Container(
              child: Icon(Icons.arrow_forward,color: MyColors.color_6E7578,),
              margin: const EdgeInsets.only(right: 15),
            )
          ],
        ),
      ),
    );
  }
}
