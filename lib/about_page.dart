import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});  // Use super parameter here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About the App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Our mobile application helps users manage their personal finances by tracking income and expenses. '
              'It provides insights into spending patterns and helps users budget more effectively.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Why this app is needed:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'With the rising importance of financial literacy and personal budgeting, this app serves to help individuals keep track of their finances efficiently.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Potential Users:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Our app targets young adults, professionals, and anyone who wants to take control of their finances, '
              'especially those new to budgeting or those looking for a simple and effective way to track spending.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Main Features of the App:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '- Add income and expenses\n'
              '- View transaction history\n'
              '- Display financial summaries (charts, graphs)\n'
              '- Set monthly budget limits\n'
              '- Push notifications for reminders to track expenses',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Credits:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Developed by: Serikbek Yerassyl, Rakhiya Kurbanaliyeva, Tamerlan Ussenov​​\n'
              'Instructor: Kyzyrkanov Abzal​',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
