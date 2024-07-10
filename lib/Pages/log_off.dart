import 'package:flutter/material.dart';
import '../Helpers/ProgressBar.dart';
import '../Helpers/currentUser.dart';
import '../main.dart';

class LogOffPage extends StatefulWidget {
  const LogOffPage({super.key});

  @override
  _LogOffPageState createState() => _LogOffPageState();
}

class _LogOffPageState extends State<LogOffPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xffB40000))),
                  onPressed: () async => {
                    ProgressBar.instance.show(context),
                    await CurrentUser.instance.userLogoff(),
                    ProgressBar.instance.hide(),
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
                      return const MyApp();
                    })),
                    //SVProgressHUD.dismiss(),
                  },
                  child:
                      const Text('                                        Salir                                       ', style: TextStyle(fontSize: 15, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
