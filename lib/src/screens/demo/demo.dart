import 'package:ism_app/imports.dart';
import 'package:ism_app/src/model/base_response.dart';
import 'package:ism_app/src/screens/demo/bloc/demo_bloc.dart';
import 'package:ism_app/src/screens/receipts/receipts/bloc/receipts_bloc.dart';
import 'package:ism_app/src/screens/receipts/receipts/model/receipt_data.dart';
import 'package:ism_app/src/widgets/error.dart';
import 'package:ism_app/src/widgets/loading/loader.dart';

class Demo extends StatefulWidget {
  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  DemoBloc _demoBloc;
  ReceiptsBloc _receiptsBloc;

  Future<ApiResponse> userData;

  @override
  void initState() {
    super.initState();
    _demoBloc = DemoBloc();
    _receiptsBloc = ReceiptsBloc();
    userData = _receiptsBloc.fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: loadData(),
      ),
    );
  }

  loadData() {
    return FutureBuilder(
      builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: _buildChild(snapshot),
        );
      },
      future: userData,
    );
  }

  _buildChild(AsyncSnapshot<ApiResponse> snapshot) {
    if (snapshot.hasData) {
      var data = snapshot.data;
      if (data is BaseResponse) {
        var listData = data.data as List<ReceiptResponse>;
        return ListView.builder(
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(top: 24),
              child: Text(listData[index].firstName),
            );
          },
          itemCount: listData.length,
        );
      } else {
        ErrorResponse response = (data as ErrorResponse);
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(response.errorMessage ?? response.statusCode.toString())
            ],
          ),
        );
      }
    } else if (snapshot.hasError) {
      return ErrorView();
    } else {
      return Loader();
    }
    throw Exception('${snapshot.error.runtimeType} is not supported');
  }
}
