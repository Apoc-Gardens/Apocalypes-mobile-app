import 'package:flutter/material.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text(
              'APOC GARDENS',
              style: TextStyle(
                color: Color(0xFF0AA061),
                fontSize: 20,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Scan Devices'),
            onTap: () => Navigator.pushNamed(context, '/scan'),
          ),
          ListTile(
              leading: const Icon(Icons.perm_device_info),
              title: const Text('Devices'),
              onTap: () => Navigator.pushNamed(context, '/receivers')),
          ListTile(
              leading: const Icon(Icons.device_thermostat),
              title: const Text('Sensors'),
              onTap: () => Navigator.pushNamed(context, '/sensors')),
          ListTile(
              leading: const Icon(Icons.data_object),
              title: const Text('Test Page'),
              onTap: () => Navigator.pushNamed(context, '/test')),
        ],
      ),
    );
  }
}
