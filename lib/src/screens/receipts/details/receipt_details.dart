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
import 'package:ism_app/src/widgets/container/container_shadow.dart';
import 'package:ism_app/src/widgets/container/item_container.dart';
import 'package:ism_app/src/widgets/dropdown/dropdown.dart';
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
  Location selectedLocation;

  List<Location> listLocationData;

  @override
  void initState() {
    super.initState();
    _receiptDetailsBloc = ReceiptDetailBloc();
    fetchLocation();
  }

  fetchLocation() async {
    listLocationData = await _receiptDetailsBloc.getCachedLocationData();
    selectedLocation = _receiptDetailsBloc.getSelectedLocation(widget.receiptData.destocationName);
    if (selectedLocation == null) {
      selectedLocation = listLocationData[0];
    }
    setState(() {});
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      _receiptDetailsBloc.add(ReceiptDetailsEvent(scanData.code, widget.receiptData));
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
            setState(() {});

            showSnackBar(S.current.success, state.data, color: Colors.green);
          }

          if (state is ErrorState) {
            showSnackBar(S.current.error, state.errorMessage);
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
                        "${S.current.warehouse_afrobio} : ${S.current.receipts} | ",
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
                        if (listLocationData != null)
                          MyShadowContainer(
                            borderRadius: BorderRadius.circular(90),
                            alignment: Alignment.centerLeft,
                            shadowColor: Color(0x0A0F3712),
                            margin: const EdgeInsets.only(top: 27, bottom: 16, left: 16, right: 24),
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: MyDropDown<Location>(
                              listLocationData,
                              selectedLocation,
                              icon: Icon(Icons.arrow_drop_down_outlined),
                              onChangeListener: (data) {
                                selectedLocation = data;
                                setState(() {});
                              },
                            ),
                          ),
                        ListItem(index: -1, receiptData: widget.receiptData, moveLine: null),
                        ListView.builder(
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListItem(
                                index: index,
                                onTap: () {
                                  Get.to(() => DetailOperations(widget.receiptData));
                                },
                                receiptData: widget.receiptData,
                                isProductData: true,
                                moveLine: widget.receiptData.moveLineIds[index]);
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
  Function onTap;

  ListItem({this.index, this.receiptData, this.moveLine, this.onTap, this.isProductData = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: MyBorder.commonBorderRadius(),
      onTap: () {
        onTap?.call();
      },
      child: MyItemContainer(
        margin: EdgeInsets.only(
          top: index == 0 ? 27 : 0,
          bottom: index == -1 ? 0 : 27,
          left: 20,
          right: 20,
        ),
        outlineColor: MyColors.color_E2E9EF,
        shadowColor: MyColors.color_0A0F3712,
        children: Stack(
          children: [
            Positioned.fill(
              child: Row(
                children: [
                  Expanded(
                    flex: 45,
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyColors.color_E2E9EF,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 55,
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, top: 20, bottom: 26, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 45,
                        child: KeyItem(
                          title: isProductData ? S.current.product : S.current.partner,
                          topMargin: 0,
                        ),
                      ),
                      Expanded(
                        child: Container(),
                        flex: 05,
                      ),
                      Expanded(
                        flex: 50,
                        child: ValueItem(
                          title: (isProductData ? moveLine.product : receiptData.partner) ?? "Not Available",
                          topMargin: 0,
                          textColor: MyColors.color_F18719,
                        ),
                      ),
                    ],
                  ),
                  if (!isProductData)
                    Row(
                      children: [
                        Expanded(
                          flex: 45,
                          child: KeyItem(
                            title: S.current.initial_demand,
                          ),
                        ),
                        Expanded(
                          child: Container(),
                          flex: 05,
                        ),
                        Expanded(
                          flex: 50,
                          child: ValueItem(
                            title: moveLine?.reservedQty?.toStringAsFixed(0) ?? "0",
                            textColor: isProductData ? MyColors.color_F18719 : MyColors.color_6E7578,
                          ),
                        ),
                      ],
                    ),
                  Row(
                    children: [
                      Expanded(
                        flex: 45,
                        child: KeyItem(
                          title: isProductData ? S.current.access_bur_00001_modem : S.current.destination_location,
                          isHidden: !isProductData,
                        ),
                      ),
                      Expanded(
                        child: Container(),
                        flex: 05,
                      ),
                      Expanded(
                        flex: 50,
                        child: ValueItem(
                            title: (isProductData ? "" : receiptData.destocationName) ?? "",
                            isHidden: !isProductData,
                            textColor: isProductData ? MyColors.color_F18719 : MyColors.color_F18719),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 45,
                        child: KeyItem(
                          title: isProductData ? S.current.done : S.current.scheduled_date,
                        ),
                      ),
                      Expanded(
                        child: Container(),
                        flex: 05,
                      ),
                      Expanded(
                        flex: 50,
                        child: ValueItem(
                            title: (isProductData
                                    ? moveLine?.quantityDone?.toStringAsFixed(0)??"0"
                                    : "${parseDate(receiptData.date)} | ${parseTime(receiptData.date)}") ??
                                "",
                            textColor: isProductData ? MyColors.color_F18719 : MyColors.color_6E7578),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 45,
                        child: KeyItem(
                          title: isProductData ? S.current.units_of_measure : S.current.document_source,
                        ),
                      ),
                      Expanded(
                        child: Container(),
                        flex: 05,
                      ),
                      Expanded(
                        flex: 50,
                        child: ValueItem(
                            title: (isProductData ? S.current.units : receiptData.origin) ?? "",
                            textColor: isProductData ? MyColors.color_F18719 : MyColors.color_6E7578),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
