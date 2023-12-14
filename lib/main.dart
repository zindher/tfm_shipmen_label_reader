import 'package:flutter/material.dart';
import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:flutter/services.dart';
import 'Helpers/ProgressBar.dart';
import 'Helpers/alert.dart';
import 'Helpers/currentUser.dart';
import 'Pages/master.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData(brightness: Brightness.light, fontFamily: 'Montserrat'), home: const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isPasswordChanger = false;
  final _bottomBarController = BottomBarWithSheetController(initialIndex: 0);
  final userTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final securityCodeTextController = TextEditingController();

  Future<void> _changePage() async {
    setState(() {});
  }

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return Scaffold(
      appBar: null,
      backgroundColor: Color(0xff052289),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text('SHIPMENT', textAlign: TextAlign.center, style: TextStyle(fontSize: 35, color: Colors.white)),
                const Text('CONTROL SYSTEM', textAlign: TextAlign.center, style: TextStyle(fontSize: 35, color: Colors.white)),
                const Text('V1.0.0', style: TextStyle(fontSize: 12, color: Colors.white)),
                const Text(''),
                const Text(''),
                Image.asset('assets/images/438524.png', width: 160),
                const Text(''),
                const Text(''),
                ElevatedButton(
                  onPressed: () async => {
                    _isPasswordChanger = false,
                    _bottomBarController.toggleSheet(),
                    await _changePage(),
                  },
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                  child: const Text('          Iniciar Sesión          ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xff052289))),
                ),
                const Text(''),
                TextButton(
                  onPressed: () async => {
                    _isPasswordChanger = true,
                    _bottomBarController.toggleSheet(),
                  },
                  child: const Text('¿Cambiar Contraseña?', style: TextStyle(fontSize: 15, color: Colors.white)),
                ),
                const Text(''),
                Image.asset(
                  'assets/images/ogp.png',
                  width: 200,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBarWithSheet(
        autoClose: true,
        controller: _bottomBarController,
        disableMainActionButton: true,
        bottomBarTheme: const BottomBarTheme(
          decoration: BoxDecoration(color: Colors.white),
          contentPadding: EdgeInsets.all(0),
          isVerticalItemLabel: true,
          heightClosed: 0,
        ),
        sheetChild: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
              child: SingleChildScrollView(
            child: Column(children: <Widget>[
              Visibility(
                  visible: !_isPasswordChanger,
                  child: Column(children: <Widget>[
                    const Text('Iniciar Sesión', textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
                    const Text(''),
                    TextFormField(
                      controller: userTextController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Usuario',
                      ),
                    ),
                    const Text(''),
                    TextFormField(
                      controller: passwordTextController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Contraseña',
                      ),
                    ),
                    const Text(''),
                    const Text(''),
                    ElevatedButton(
                      onPressed: () async => {
                        ProgressBar.instance.show(context),
                        await CurrentUser.instance.userLogin(userTextController.text, passwordTextController.text),
                        if (CurrentUser.instance.user.idUser! > 0)
                          {
                            AlertHelper.showSuccessToast("Bienvenido ${CurrentUser.instance.user.name} ${CurrentUser.instance.user.lastName}"),
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
                              return const MasterPage(SelectedIndex: 2, Obj: '');
                            }))
                          }
                        else
                          {AlertHelper.showErrorToast("Usuario y/o contraseña incorrectos")},
                        ProgressBar.instance.hide()
                      },
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff3880FF))),
                      child: const Text('                                        Continuar                                       ',
                          style: TextStyle(fontSize: 12, color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: () => {
                        _bottomBarController.toggleSheet(),
                      },
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xffB40000))),
                      child: const Text('                                       Cancelar                                         ',
                          style: TextStyle(fontSize: 12, color: Colors.white)),
                    ),
                  ])),
              Visibility(
                  visible: _isPasswordChanger,
                  child: Column(children: <Widget>[
                    const Text('Cambiar Contraseña', textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
                    const Text(''),
                    TextFormField(
                      controller: userTextController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Usuario',
                      ),
                    ),
                    const Text(''),
                    TextFormField(
                      controller: securityCodeTextController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Clave de seguridad',
                      ),
                    ),
                    const Text(''),
                    const Text(''),
                    ElevatedButton(
                      onPressed: () => {},
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff3880FF))),
                      child: const Text('                                        Solicitar                                       ',
                          style: TextStyle(fontSize: 12, color: Colors.white)),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xffB40000))),
                      onPressed: () => {
                        _bottomBarController.toggleSheet(),
                      },
                      child: const Text('                                       Cancelar                                         ',
                          style: TextStyle(fontSize: 12, color: Colors.white)),
                    ),
                  ]))
            ]),
          )),
        ),
        items: const [],
      ),
    );
  }
}
