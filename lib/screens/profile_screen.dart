import 'package:febrianiuts/service/auth_service.dart';
import 'package:febrianiuts/model/account.dart';
import 'package:flutter/material.dart';

import '../auth/auth_state.dart';

class PageProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Account user;
    if (AuthState.loggedInAccount != null) {
      user = AuthState.loggedInAccount!;
    } else {
      user = Account(
          id: 'not login yet',
          name: 'not login yet',
          email: 'not login yet',
          password: 'not login yet');
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/profile_image.png'),
            ),
            SizedBox(height: 16),
            Text(
              '${user.name}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${user.email}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                AuthService.logout(context);
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
