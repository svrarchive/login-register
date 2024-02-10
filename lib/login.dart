import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ignore: unused_import
import 'dart:convert';
import 'dashboard.dart';

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
      title: 'Login User',
      theme: ThemeData(),
      home: const MyLoginPage(title: 'Login User'),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override

  // ignore: library_private_types_in_public_api
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  String text = '';
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _warningMessage = '';

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
                  'Login User',
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

              if (_warningMessage.isNotEmpty)
                Text(
                  _warningMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Map<String, dynamic> userData = {
                      'nama': _nameController.text,
                      'password': _passwordController.text,
                    };

                    String jsonData = jsonEncode(userData);

                    var response = await http.post(
                      Uri.parse("http://localhost:8080/api/login"),
                      headers: {
                        "Content-Type": "application/json",
                      },
                      body: jsonData,
                    );

                    if (response.statusCode == 200) {
                       Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyDashboardPage(title: 'Dashboard'),
                        ),
                      );
                    } else {
                      setState(() {
                        _warningMessage = 'Login gagal. Periksa kembali nama dan password.';
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  minimumSize: const Size(50, 50),
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                ),
                child: const Text('Masuk',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
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
