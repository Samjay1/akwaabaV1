import 'package:flutter/material.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({Key? key}) : super(key: key);

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alerts"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            alertItem(title: 'Title', description: 'Description'),
            alertItem(title: 'Title', description: 'Description')
          ],
        ),

      ),
    );
  }

  Widget alertItem({var title, var description}){
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(7),
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(
                color: Colors.black26,
                blurRadius: 8.0,
                offset: Offset(0,6)
            )]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$title'),
            Text('$description')
          ],
        )
    );
  }
}
