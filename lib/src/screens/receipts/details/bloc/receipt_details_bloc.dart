import 'package:ism_app/imports.dart';
import 'package:ism_app/src/bloc/base_bloc.dart';
import 'package:ism_app/src/bloc/base_event.dart';
import 'package:ism_app/src/model/receipt_data.dart';
import 'package:ism_app/src/screens/home/bloc/home_bloc.dart';
import 'package:ism_app/src/screens/receipts/receipts/bloc/receipts_bloc.dart';

import '../bloc/details_event.dart';

class ReceiptDetailBloc extends BaseBloc<BaseEvent, BaseState> {
  List<AllProductLot> productLotData;
  List<ReceiptData> receiptData;

  ReceiptDetailBloc() : super(UnInitiatedState()) {
    getProductLotData();
    getReceiptData();
  }

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is ReceiptDetailsEvent) {
      yield* increaseQuantity(event);
    }
  }

  getProductLotData() async {
    productLotData = await HiveService.instance.getBoxes<AllProductLot>(HomeBloc.boxNameProductLot);
  }

  getReceiptData() async {
    receiptData = await HiveService.instance.getBoxes<ReceiptData>(ReceiptsBloc.boxNameReceiptData);
  }

  Stream<BaseState> increaseQuantity(ReceiptDetailsEvent event) async* {
    yield LoadingState();
    if (productLotData == null) {
      await getProductLotData();
    }
    if (receiptData == null) {
      await getReceiptData();
    }
    if (productLotData != null && productLotData.isNotEmpty && receiptData != null && receiptData.isNotEmpty) {
      try {
        // event.receiptData.moveLineIds.length
        MoveLineIds moveLineId;
        for (MoveLineIds mData in event.receiptData.moveLineIds) {
          if (mData.lotId == event.productId) {
            moveLineId = mData;
          }
        }
        if (moveLineId != null && moveLineId.productId != null) {
          bool hasProductID = false;
          productLotData.forEach((element) {
            if (element.productId.toString() == moveLineId.productId.toString()) {
              hasProductID = true;
              return;
            }
          });

          if (hasProductID) {
            event.receiptData.isEdited = true;
            event.receiptData.isSynced = false;
            moveLineId.isEdited = true;
            if (moveLineId.quantityDone == null) {
              moveLineId.quantityDone = 1;
            } else {
              moveLineId.quantityDone = moveLineId.quantityDone + 1;
            }
            var moveLineIdIndexOf = event.receiptData.moveLineIds.indexOf(moveLineId);
            event.receiptData.moveLineIds[moveLineIdIndexOf] = moveLineId;
            var receiptIndexOf = receiptData.indexOf(event.receiptData);
            await HiveService.instance.updateValue(event.receiptData, receiptIndexOf, ReceiptsBloc.boxNameReceiptData);
            yield DataState<String>("Quantity updated successfully");
          } else {
            yield ErrorState(errorMessage: "No product available to update the quantity");
          }
        } else {
          var productLot;
          for (AllProductLot mData in productLotData) {
            if (mData.id.toString() == event.productId) {
              productLot = mData;
            }
          }
          if (productLot != null) {
            MoveLineIds mMoveLine = MoveLineIds(
                productId: productLot.productId,
                product: productLot.product,
                lotId: productLot.id.toString(),
                destination: event.receiptData.destocationName,
                locationDestId: event.receiptData.locationId,
                lot: productLot.name);
            event.receiptData.moveLineIds.add(mMoveLine);
            var receiptIndexOf = receiptData.indexOf(event.receiptData);
            await HiveService.instance.updateValue(event.receiptData, receiptIndexOf, ReceiptsBloc.boxNameReceiptData);
            yield DataState<String>("Product added successfully");
          } else {
            yield ErrorState(errorMessage: "Lot ID not found");
          }
        }
      } catch (e) {
        yield ErrorState(errorMessage: "Error in updating quantity");
      }
    } else {
      yield ErrorState(errorMessage: "Error in updating quantity");
    }
  }
}
