import 'package:flutter/material.dart';
import 'package:smart_engineering_lab/model/lab_module_model.dart';

class LabModuleViews extends StatefulWidget {
  const LabModuleViews({Key? key}) : super(key: key);

  @override
  _LabModuleViewsState createState() => _LabModuleViewsState();
}

class _LabModuleViewsState extends State<LabModuleViews> {
  List<LabModuleModel> labmodule = [];
  @override
  void initState() {
    super.initState();
    labmodule = List.generate(14, (index) {
      return LabModuleModel(
          nameModule: 'CS351 ASSIGNMENT/LAB $index',
          titleModule: 'Analog Input',
          sections: [
            Section(
              titleSection: 'Objective:',
              description:
                  'To demonstrate the reading analog input by using potentiometer and monitor the reading of analog value through serial monitor.',
            ),
            Section(
              titleSection: 'Modern tools/components:',
              description: 'TinkerCAD tools. / UNO microcontroller',
            ),
            Section(
              titleSection: 'Description:',
              description: '',
            ),
            Section(
              titleSection: 'Activities',
              description:
                  '1) Based on the flow chart above, please write the source code for the working process\n2) State the components used.\n3) Attached the design circuit.\n4) Referring to activity (1), using\na) Serial.print ( ) to print the characters without going into new line and then continue adding the next statement or value. Voltage: 3.6 result will show in the serial monitor, example:\n\nfloat volts = analogRead(A0); volts = (volts*0.00488); Serial.print(“voltage : “); Serial.println(volts);\nb) Use if statement to compare the voltage value to execute certain tasks. In this example, when the voltage value is below 2.5, it prints out a message “Low Voltage!!”\nif (volts < 2.5) { Serial.print(“Low Voltage!!”); }',
            ),
            Section(
              titleSection: 'Discussion',
              description:
                  'To demonstrate the reading analog input by using potentiometer and monitor the reading of analog value through serial monitor.',
            ),
            Section(
              titleSection: 'Conclusion',
              description:
                  'To demonstrate the reading analog input by using potentiometer and monitor the reading of analog value through serial monitor.',
            )
          ]);
    }, growable: true);

    print(labmodule);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UNIMY ENGINEERING LAB'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 8,
          ),
          // color: Colors.grey,
          child: Column(
            children: labmodule
                .map((e) => Container(
                      // decoration: const BoxDecoration(
                      //     borderRadius: BorderRadius.all(Radius.circular(8))),
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LabModuleScreen(labModuleModel: e))),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        tileColor: Colors.red[100],
                        title: Text(e.nameModule!),
                        subtitle: Text(e.titleModule!),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class LabModuleScreen extends StatefulWidget {
  final LabModuleModel labModuleModel;
  const LabModuleScreen({Key? key, required this.labModuleModel})
      : super(key: key);

  @override
  _LabModuleScreenState createState() => _LabModuleScreenState();
}

class _LabModuleScreenState extends State<LabModuleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.labModuleModel.nameModule!),
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          children: [
            Text(
              widget.labModuleModel.nameModule!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                widget.labModuleModel.titleModule!,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.labModuleModel.sections!
                  .map((e) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                e.titleSection!,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            e.titleSection == 'Discussion' ||
                                    e.titleSection == 'Conclusion'
                                ? Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    child: TextFormField(
                                        decoration: InputDecoration(
                                            border: const OutlineInputBorder(
                                                borderSide:
                                                    BorderSide(width: 1)),
                                            hintText: e.titleSection)))
                                : Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    child: Text(e.description!))
                          ],
                        ),
                      ))
                  .toList(),
            ),
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(onPressed: () {}, child: const Text('SUBMIT'))
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
