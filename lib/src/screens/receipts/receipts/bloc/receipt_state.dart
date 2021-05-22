import 'package:ism_app/imports.dart';

class ReceiptDataState<T> extends DataState {
  T data;

  ReceiptDataState(this.data) : super(data);
}

class IncomingDataState<T> extends DataState {
  T data;

  IncomingDataState(this.data) : super(data);
}
