import 'package:flutter/cupertino.dart';
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
            DrawerHeader(
                child: Text('APOC GARDENS',
                  style: TextStyle(
                    color: Color(0xFF0AA061),
                    fontSize:20,
                  ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Scan Decvices'),
              onTap: () => Navigator.pushNamed(context, '/scan'),
            ),
            ListTile(
              leading: Icon(Icons.perm_device_info),
              title: Text('Devices'),
                onTap: () => Navigator.pushNamed(context, '/receivers')
            ),
            ListTile(
              leading: Icon(Icons.device_thermostat),
              title: Text('Sensors'),
                onTap: () => Navigator.pushNamed(context, '/sensors')
            ),
            ListTile(
                leading: Icon(Icons.data_object),
                title: Text('testpage'),
                onTap: () => Navigator.pushNamed(context, '/test')
            ),
          ],
        ),
    );
  }
}
