import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _bluetooth = FlutterBluetoothSerial.instance;
  bool BTstate = false;
  bool BTconnected = false;
  BluetoothConnection? connection;
  List<BluetoothDevice> devices = [];
  BluetoothDevice? device;

  @override
  void initState() {
    super.initState();
    permisos();
    estado();
  }

  void permisos() async {
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetooth.request();
    await Permission.location.request();
  }

  void estado() async {
    _bluetooth.state.then((BluetoothState value) {
      setState(() {
        BTstate = value.isEnabled;
      });
    });

    _bluetooth.onStateChanged().listen((BluetoothState event) {
      setState(() {
        switch (event) {
          case BluetoothState.STATE_ON:
            BTstate = true;
            break;
          case BluetoothState.STATE_OFF:
            BTstate = false;
            break;
          case BluetoothState.STATE_TURNING_ON:
            break;
          case BluetoothState.STATE_TURNING_OFF:
            break;
          default:
            break;
        }
        setState(() {});
      });
    });
  }

  void encenderBT() {
    _bluetooth.requestEnable();
  }

  void apagarBt() {
    _bluetooth.requestDisable();
  }

  Widget switchBT() {
    return SwitchListTile(
      title: BTstate
          ? const Text('Bluetooth encendido')
          : const Text("Bluetooth apagado"),
      activeColor: BTstate ? Colors.green : Colors.grey,
      tileColor: BTstate ? Colors.green : Colors.grey,
      value: BTstate,
      onChanged: (bool value) {
        if (value) {
          encenderBT();
        } else {
          apagarBt();
        }
      },
      secondary: BTstate
          ? const Icon(Icons.bluetooth)
          : const Icon(Icons.bluetooth_disabled),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("flutter bluetooth <3"),
      ),
      body: Column(children: <Widget>[switchBT()],),
    );
  }
}
