import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:ism_app/imports.dart';
import 'package:ism_app/src/model/receipt_data.dart';
import 'package:ism_app/src/screens/receipts/details/bloc/details_event.dart';
import 'package:ism_app/src/screens/receipts/details/bloc/receipt_details_bloc.dart';
import 'package:ism_app/src/screens/receipts/item/key_item.dart';
import 'package:ism_app/src/screens/receipts/item/value_item.dart';
import 'package:ism_app/src/screens/receipts/operation/detail_operation.dart';
import 'package:ism_app/src/widgets/container/container.dart';
import 'package:ism_app/src/widgets/container/item_container.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ReceiptDetails extends StatefulWidget {
  ReceiptData receiptData;

  ReceiptDetails(this.receiptData);

  @override
  _ReceiptDetailsState createState() => _ReceiptDetailsState();
}

class _ReceiptDetailsState extends State<ReceiptDetails> {
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isQRCameraShown = false;
  ReceiptDetailBloc _receiptDetailsBloc;

  @override
  void initState() {
    super.initState();
    _receiptDetailsBloc = ReceiptDetailBloc();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      _receiptDetailsBloc
          .add(ReceiptDetailsEvent(scanData.code, widget.receiptData));
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    _receiptDetailsBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReceiptDetailBloc>(
      create: (context) => _receiptDetailsBloc,
      child: BlocListener<ReceiptDetailBloc, BaseState>(
        listener: (context, state) {
          if ((state is LoadingState) == false) {
            Future.delayed(Duration(seconds: 2), () {
              controller.resumeCamera();
            });
          }
          if (state is DataState) {
            showSnackBar("Success", state.data, color: Colors.green);
          }

          if (state is ErrorState) {
            showSnackBar("Error", state.errorMessage);
          }
        },
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
            actions: [
              IconButton(
                icon: Icon(
                  Icons.save,
                  color: MyColors.color_FFFFFF,
                ),
                onPressed: () {
                  Get.to(() => DetailOperations(widget.receiptData));
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.qr_code_scanner,
                  color: MyColors.color_FFFFFF,
                ),
                onPressed: () {
                  // MyNavigator.pushNamed(Routes.strDetailOperationRoute);
                  isQRCameraShown = !isQRCameraShown;
                  setState(() {});
                },
              )
            ],
            title: MyText(
              widget.receiptData.name,
              color: MyColors.color_FFFFFF,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          body: MyContainer(
            bgColor: MyColors.color_F8FAFB,
            children: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Row(
                    children: [
                      MyText(
                        "Warehouse Afrobio : Receipts | ",
                        fontWeight: FontWeight.w500,
                        color: MyColors.color_F18719,
                      ),
                      Expanded(
                        child: MyText(
                          widget.receiptData.name,
                          fontWeight: FontWeight.w500,
                          color: MyColors.color_3F4446,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 27,
                        ),
                        ListItem(
                            index: -1,
                            receiptData: widget.receiptData,
                            moveLine: null),
                        ListView.builder(
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListItem(
                                index: index,
                                receiptData: widget.receiptData,
                                isProductData: true,
                                moveLine:
                                    widget.receiptData.moveLineIds[index]);
                          },
                          primary: false,
                          shrinkWrap: true,
                          itemCount: widget.receiptData.moveLineIds.length,
                        ),
                        SizedBox(
                          height: 160,
                          width: 160,
                          child: isQRCameraShown
                              ? QRView(
                                  key: qrKey,
                                  onQRViewCreated: _onQRViewCreated,
                                )
                              : Icon(
                                  Icons.qr_code_scanner_rounded,
                                  size: 100,
                                ),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final int index;
  final ReceiptData receiptData;
  final MoveLineIds moveLine;
  var isProductData = false;

  ListItem(
      {this.index,
      this.receiptData,
      this.moveLine,
      this.isProductData = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: MyBorder.commonBorderRadius(),
      onTap: () {},
      child: MyItemContainer(
        margin: EdgeInsets.only(
          top: index == 0 ? 27 : 0,
          bottom: index == -1 ? 0 : 27,
          left: 20,
          right: 20,
        ),
        outlineColor: MyColors.color_E2E9EF,
        shadowColor: MyColors.color_0A0F3712,
        children: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                    left: 20, top: 20, bottom: 26, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KeyItem(
                      title: isProductData ? "Product" : "Partner",
                      topMargin: 0,
                    ),
                    KeyItem(
                      title: isProductData ? "Initial Demand" : "Owner",
                    ),
                    KeyItem(
                      title: isProductData
                          ? "[Access-Bur-00001] Modem"
                          : "Destination Location",
                      isHidden: !isProductData,
                    ),
                    KeyItem(
                      title: isProductData ? "Done" : "Scheduled Date",
                    ),
                    KeyItem(
                      title: isProductData
                          ? "Units of measure"
                          : "Document Source",
                    ),
                    if (!isProductData)
                      KeyItem(
                        title: "Operation Branch",
                      ),
                  ],
                ),
                decoration: BoxDecoration(
                    color: MyColors.color_E4E8EB,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(9),
                        bottomLeft: Radius.circular(9))),
              ),
              flex: 5,
            ),
            Expanded(
              flex: 5,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueItem(
                      title: (isProductData
                              ? moveLine.product
                              : receiptData.partner) ??
                          "Not Available",
                      topMargin: 0,
                      textColor: MyColors.color_F18719,
                    ),
                    ValueItem(
                      title: (isProductData
                              ? moveLine.reservedQty.toStringAsFixed(0)
                              : "") ??
                          "",
                      textColor: isProductData
                          ? MyColors.color_F18719
                          : MyColors.color_6E7578,
                    ),
                    ValueItem(
                        title:
                            (isProductData ? "" : receiptData.location) ?? "",
                        isHidden: !isProductData,
                        textColor: isProductData
                            ? MyColors.color_F18719
                            : MyColors.color_F18719),
                    ValueItem(
                        title: (isProductData
                                ? moveLine.quantityDone.toStringAsFixed(0)
                                : "${parseDate(receiptData.date)} | ${parseTime(receiptData.date)}") ??
                            "",
                        textColor: isProductData
                            ? MyColors.color_F18719
                            : MyColors.color_6E7578),
                    ValueItem(
                        title:
                            (isProductData ? "Unit(s)" : receiptData.origin) ??
                                "",
                        textColor: isProductData
                            ? MyColors.color_F18719
                            : MyColors.color_6E7578),
                    if (!isProductData)
                      ValueItem(
                          title: "Not Available",
                          textColor: MyColors.color_F18719),
                  ],
                ),
                padding: const EdgeInsets.only(
                    left: 20, top: 20, bottom: 26, right: 16),
                decoration: BoxDecoration(
                    color: MyColors.color_FFFFFF,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(10))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
