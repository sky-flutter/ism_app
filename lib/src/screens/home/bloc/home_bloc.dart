import 'package:ism_app/imports.dart';
import 'package:ism_app/src/bloc/base_bloc.dart';
import 'package:ism_app/src/bloc/base_event.dart';
import 'package:ism_app/src/model/all_product_lot.dart';
import 'package:ism_app/src/model/base_response.dart';
import 'package:ism_app/src/model/location.dart';
import 'package:ism_app/src/model/product.dart';
import 'package:ism_app/src/screens/home/bloc/home_event.dart';
import 'package:ism_app/src/services/error_code.dart';

class HomeBloc extends BaseBloc<BaseEvent, BaseState> {
  static String boxNameProductLot = "product_lot";
  static String boxNameProduct = "product";
  static String boxNameLocation = "location";

  HomeBloc() : super(UnInitiatedState());

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is GetAllProductEvent) {
      yield* getAllProductData();
    }

    if (event is GetLocationEvent) {
      yield* getLocationData();
    }

    if (event is GetAllProductLotEvent) {
      yield* getAllProductLotData();
    }
  }

  Stream<BaseState> getAllProductData() async* {
    try {
      yield LoadingState();
      if (await isConnectionAvailable()) {
        var response =
            await apiClient.call(url: ApiConstant.ENDPOINT_ALL_PRODUCT);
        if (response is BaseResponse) {
          List<Product> productData = Product.fromJson(response.results);
          await addDataToDatabase<Product>(boxNameProduct, productData);
          yield DataState<List<Product>>(productData);
        } else {
          yield ErrorState(
              errorCode: (response as ErrorResponse).statusCode,
              errorMessage: (response as ErrorResponse).errorMessage);
        }
      } else {
        yield* getCachedData<Product>(boxNameProduct);
      }
    } catch (e) {
      yield ErrorState(errorCode: ErrorCode.SERVER_DOWN);
    }
  }

  Stream<BaseState> getLocationData() async* {
    try {
      yield LoadingState();
      if (await isConnectionAvailable()) {
        var response = await apiClient.call(url: ApiConstant.ENDPOINT_LOCATION);
        if (response is BaseResponse) {
          List<Location> location = Location.fromJson(response.results);
          await addDataToDatabase<Location>(boxNameLocation, location);
          yield DataState<List<Location>>(location);
        } else {
          yield ErrorState(
              errorCode: (response as ErrorResponse).statusCode,
              errorMessage: (response as ErrorResponse).errorMessage);
        }
      } else {
        yield* getCachedData<Location>(boxNameLocation);
      }
    } catch (e) {
      yield ErrorState(errorCode: ErrorCode.SERVER_DOWN);
    }
  }

  Stream<BaseState> getAllProductLotData() async* {
    try {
      yield LoadingState();
      if (await isConnectionAvailable()) {
        var response =
            await apiClient.call(url: ApiConstant.ENDPOINT_ALL_PRODUCT_LOT);
        if (response is BaseResponse) {
          List<AllProductLot> listProductLot =
              AllProductLot.fromJson(response.results);
          await addDataToDatabase<AllProductLot>(
              boxNameProductLot, listProductLot);
          yield DataState<List<AllProductLot>>(listProductLot);
        } else {
          yield ErrorState(
              errorCode: (response as ErrorResponse).statusCode,
              errorMessage: (response as ErrorResponse).errorMessage);
        }
      } else {
        yield* getCachedData<AllProductLot>(boxNameProductLot);
      }
    } catch (e) {
      yield ErrorState(errorCode: ErrorCode.SERVER_DOWN);
    }
  }
}
