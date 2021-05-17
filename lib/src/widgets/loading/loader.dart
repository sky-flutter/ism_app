import 'package:ism_app/imports.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 36,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
