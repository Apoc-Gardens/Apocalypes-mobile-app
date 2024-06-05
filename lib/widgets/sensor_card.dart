import 'package:flutter/material.dart';
import 'package:mybluetoothapp/models/node.dart';
import 'package:mybluetoothapp/pages/view_sensor.dart';
import 'package:intl/intl.dart';
import '../dao/data_dao.dart';
import '../models/data.dart';

class SensorCard extends StatefulWidget {
  final Node node;
  const SensorCard({super.key, required this.node});

  @override
  State<SensorCard> createState() => _SensorCardState();
}

class _SensorCardState extends State<SensorCard> {
  final DataDao _dataDao = DataDao();
  int noOfData = 0;
  int latestTime = 0;
  late String temperature = '0';
  late String humidity = '0';
  late String lightIntensity = '0';
  late String soilMoisture = '0';

  @override
  initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    await dataCount();
    await getLatestTime();
    await getLatestReadings();
    setState(() {});
  }

  Future<void> dataCount() async {
    noOfData = await _dataDao.countData(widget.node.id.toString()) ?? 0;
  }

  Future<void> getLatestTime() async {
    latestTime =  await _dataDao.latestDataTimeStamp(widget.node.id.toString()) ?? 0;
  }

  Future<void> getLatestReadings() async{
    List<Data> latestReadings = await _dataDao.getLatestReadings(widget.node.id.toString());
    for (Data reading in latestReadings){
      switch(reading.dataTypeId) {
        case 1: {
          temperature = reading.value.toString();
        }
        break;

        case 2: {
          humidity = reading.value.toString();
        }
        break;

        case 3: {
          lightIntensity = reading.value.toString();
        }
        break;

        case 4: {
          soilMoisture = reading.value.toString();
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewSensor(node: widget.node),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Border radius
          side: const BorderSide(
            color: Color(0xFFE4E4E4), // Border color
            width: 1.0, // Border thickness
          ),
        ),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0), // Padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.node.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
              Text(widget.node.description ?? ' ',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                    color: Colors.black
                ),
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Last Update'),
                      Text(DateFormat('dd-mm-yyyy HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(latestTime)))
                    ],
                  ),
                  SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('No. Data'),
                      Text(noOfData.toString())
                    ],
                  )
                ],
              ),
              SizedBox(height: 10,),
              Divider(),
              Text('LATEST READINGS',
              style: TextStyle(
                color: Color(0xFF0AA061),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Temp'),
                      Text(temperature+'C')
                    ],
                  ),
                  SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Humid'),
                      Text(humidity+'%')
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('LUX'),
                      Text(lightIntensity+'lux')
                    ],
                  ),
                  SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Soil'),
                      Text(soilMoisture+'%')
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
