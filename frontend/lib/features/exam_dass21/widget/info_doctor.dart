import 'package:flutter/material.dart';

class InfoDoctor extends StatelessWidget {
  const InfoDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Thông tin liên lạc',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/doctor.jpg'),
          ),
          title: const Text(
            'Bác sĩ Kim',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          subtitle: const Text(
            '0988 776655',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.normal,
              fontSize: 20,
            ),
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.phone_android,
              color: Colors.black54,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }
}
