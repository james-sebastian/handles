part of "../pages.dart";

class HandlesListPage extends StatefulWidget {
  const HandlesListPage({ Key? key }) : super(key: key);

  @override
  _HandlesListPageState createState() => _HandlesListPageState();
}

class _HandlesListPageState extends State<HandlesListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Logged in"),
      ),
    );
  }
}