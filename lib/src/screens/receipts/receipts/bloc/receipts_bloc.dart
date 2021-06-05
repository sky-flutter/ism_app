import 'package:ism_app/imports.dart';
import 'package:ism_app/src/bloc/base_bloc.dart';
import 'package:ism_app/src/bloc/base_event.dart';
import 'package:ism_app/src/model/base_response.dart';
import 'package:ism_app/src/model/receipt_data.dart';
import 'package:ism_app/src/screens/receipts/receipts/bloc/receipt_event.dart';
import 'package:ism_app/src/screens/receipts/receipts/bloc/receipt_state.dart';
import 'package:ism_app/src/services/error_code.dart';

class ReceiptsBloc extends BaseBloc<BaseEvent, BaseState> {
  static String boxNameReceiptData = "receipts";
  List<ReceiptData> listReceiptData;

  ReceiptsBloc() : super(UnInitiatedState());

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is GetAllReceiptsEvent) {
      yield* getReceiptData();
    }
    if (event is GetCachedReceiptDataEvent) {
      yield* getCachedReceiptData();
    }
    if (event is GetCachedIncomingDataEvent) {
      yield* getCachedIncomingData();
    }
  }

  Stream<BaseState> getReceiptData() async* {
    try {
      yield LoadingState();
      if (await isConnectionAvailable()) {
        var response =
            await apiClient.call(url: ApiConstant.ENDPOINT_ALL_PICKING);
        if (response is BaseResponse) {
          List<ReceiptData> listReceiptData =
              ReceiptData.fromJson(response.results);
          await addDataToDatabase<ReceiptData>(
              boxNameReceiptData, listReceiptData);
          yield DataState<List<ReceiptData>>(listReceiptData);
        } else {
          yield ErrorState(
              errorCode: (response as ErrorResponse).statusCode,
              errorMessage: (response as ErrorResponse).errorMessage);
        }
      } else {
        yield* getCachedData<ReceiptData>(boxNameReceiptData);
      }
    } catch (e) {
      yield ErrorState(errorCode: ErrorCode.SERVER_DOWN);
    }
  }

  Stream<BaseState> getCachedReceiptData() async* {
    if (listReceiptData == null) {
      listReceiptData =
          await getCachedDataFuture<ReceiptData>(boxNameReceiptData);
    }
    var data = listReceiptData
        .where((element) => element.type.toLowerCase() == "incoming")
        .toList();

    if (data != null) {
      yield ReceiptDataState<List<ReceiptData>>(data);
    } else {
      yield ErrorState(errorMessage: "No data available");
    }
  }

  Stream<BaseState> getCachedIncomingData() async* {
    if (listReceiptData == null) {
      listReceiptData =
          await getCachedDataFuture<ReceiptData>(boxNameReceiptData);
    }
    var data = listReceiptData
        .where((element) => element.internalType.toLowerCase() == "receipt")
        .toList();

    if (data != null) {
      yield IncomingDataState<List<ReceiptData>>(data);
    } else {
      yield ErrorState(errorMessage: "No data available");
    }
  }
}
