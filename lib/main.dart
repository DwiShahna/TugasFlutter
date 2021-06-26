import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sekolah/guruModel.dart';
import 'package:provider/provider.dart';
import 'package:sekolah/provider.dart';

void main() {
  runApp(MaterialApp(
    home: Login(),
  ));
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String username, password;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    final response = await http.post("http://127.0.0.1/sekolah/api/login.php",
        body: {"username": username, "password": password});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value);
      });
      print(pesan);
    } else {
      print(pesan);
    }
  }

  savePref(int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.commit();
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");

      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          appBar: AppBar(),
          body: Form(
            key: _key,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                TextFormField(
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Please Insert Username";
                    }
                  },
                  onSaved: (e) => username = e,
                  decoration: InputDecoration(labelText: "Username"),
                ),
                TextFormField(
                  obscureText: _secureText,
                  onSaved: (e) => password = e,
                  decoration: InputDecoration(
                      labelText: "Password",
                      suffixIcon: IconButton(
                        onPressed: showHide,
                        icon: Icon(_secureText
                            ? Icons.visibility_off
                            : Icons.visibility),
                      )),
                ),
                MaterialButton(
                  onPressed: () {
                    check();
                  },
                  child: Text("Login"),
                )
              ],
            ),
          ),
        );
        break;
      case LoginStatus.signIn:
        return MainMenu();
        break;
    }
  }
}

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final data = [
    DataGuru(
        id: "1", nip: "123123", nama: "Andi", pelajaran: "mtk", nohp: "123123"),
    DataGuru(
        id: "2", nip: "123124", nama: "Ami", pelajaran: "mtk", nohp: "123123"),
    DataGuru(
        id: "3",
        nip: "123125",
        nama: "Surya",
        pelajaran: "mtk",
        nohp: "123123"),
    DataGuru(
        id: "4",
        nip: "123121",
        nama: "Dendi",
        pelajaran: "ips",
        nohp: "123111"),
    DataGuru(
        id: "5",
        nip: "123111",
        nama: "Fandi",
        pelajaran: "ipa",
        nohp: "123111"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: ListView.builder(
        itemCount: data.length, //MENGHITUNG JUMLAH DATA YANG AKAN DITAMPILKAN
        //LOOPING DATA
        itemBuilder: (context, i) {
          //KEMUDIAN TAMPILKAN DATA PEGAWAI BERDASARKAN INDEX YANG DISIMPAN DI DALAM VARIABLE I
          return Card(
            elevation: 8,
            child: ListTile(
              title: Text(
                data[i].nama,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Nip: ${data[i].nip}'),
              trailing: Text("\Mata Pelajaran :${data[i].pelajaran}"),
            ),
          );
        },
      ),

      // body: RefreshIndicator(
      //   onRefresh: () =>
      //       Provider.of<GuruProvider>(context, listen: false).getGuru(),
      //   color: Colors.red,
      //   child: Container(
      //     margin: EdgeInsets.all(10),
      //     child: FutureBuilder(
      //       future: Provider.of<GuruProvider>(context, listen: false).getGuru(),
      //       builder: (context, snapshot) {
      //         if (snapshot.connectionState == ConnectionState.waiting) {
      //           return Center(
      //             child: CircularProgressIndicator(),
      //           );
      //         }

      //         return Consumer<GuruProvider>(
      //           builder: (context, data, _) {
      //             return ListView.builder(
      //               itemCount: data.length,
      //               itemBuilder: (context, i) {
      //                 return Card(
      //                   elevation: 8,
      //                   child: ListTile(
      //                     title: Text(
      //                       data[i].nama,
      //                       style: TextStyle(
      //                           fontSize: 18, fontWeight: FontWeight.bold),
      //                     ),
      //                     subtitle: Text('Nip: ${data[i].nip}'),
      //                   ),
      //                 );
      //               },
      //             );
      //           },
      //         );
      //       },
      //     ),
      //   ),
      // ),
    );
  }
}
