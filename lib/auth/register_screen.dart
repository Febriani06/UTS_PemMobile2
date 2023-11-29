// register_page.dart
import 'package:febrianiuts/model/account.dart';
import 'package:flutter/material.dart';
import '../service/auth_service.dart'; // Sesuaikan dengan struktur proyek Anda

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _register(BuildContext context) {
    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Semua field harus diisi!'),
        ),
      );
      return;
    }

    final newAccount = Account(
      id: DateTime.now().toString(),
      name: name,
      email: email,
      password: password,
    );

    List<Account> accounts = [];
    AuthService.getAccount().then((existingProducts) {
      accounts = existingProducts;
      accounts.add(newAccount);

      AuthService.register(accounts, context);

      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _register(context);
              },
              child: Text('Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}
