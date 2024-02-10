import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:http/http.dart' as http;
import 'login.dart';
// ignore: unused_import
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: unused_field
  final GlobalKey<FormState> _formKey = GlobalKey();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registrasi User',
      theme: ThemeData(),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String text = '';
  // ignore: unused_field
  String _selectedCountryCode = '';
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Future addData() async {
    var url = Uri.parse("http://localhost:8080/api/user");

    Map mapeddate = {
      'nama': _nameController.text,
      'password': _passwordController.text,
      'no_wa': _phoneController.text,
    };

    var headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    var requestBody = jsonEncode(mapeddate);

    print("JSON DATA: ${mapeddate}");

    http.Response response = await http.post(
      url,
      headers: headers,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("DATA: $data");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyLoginPage(title: 'Login User'),
        ),
      );
    } else {
      print("HTTP Request Error: ${response.statusCode}");
    }

    var data = jsonDecode(response.body);

    print("DATA: ${data}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Registrasi User',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              IntlPhoneField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Nomor Handphone",
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Nomor harus diisi';
                  }
                  return null;
                },
                onCountryChanged: (phone) {
                  setState(() {
                    _selectedCountryCode = phone.fullCountryCode;
                  });
                },
              ),
              const Text(
                'Kami akan kirim ',
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
              RichText(
                text: const TextSpan(
                  text: 'Kode Verifikasi',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                  children: [
                    TextSpan(
                      text: ' ke nomor handphone anda',
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addData();
                    print("Succesfull");
                  } else {
                    print("Unsuccesfull");
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  minimumSize: const Size(50, 50),
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                ),
                child: const Text('Daftar',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              const SizedBox(height: 21),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const MyLoginPage(title: 'Login User'),
                    ),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    text: 'Sudah mempunyai akun? ',
                    style: TextStyle(
                      color: Colors.blueGrey, // Warna hitam
                      fontSize: 14,
                      fontWeight: FontWeight.bold, // Teks biasa
                    ),
                    children: [
                      TextSpan(
                        text: 'Masuk',
                        style: TextStyle(
                          color: Colors.blue, // Warna biru
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 21),
              const Text(
                'Dengan melanjutkan saya menerima ',
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              RichText(
                text: const TextSpan(
                  text: 'Ketentuan Layanan',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                        text: ' dan telah membaca',
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: ' Kebijakan Privasi',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: ' dari Dreamwash',
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
