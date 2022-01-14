import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_engineering_lab/constant/color_constant.dart';
import 'package:smart_engineering_lab/model/lab_module_model.dart';

class LabModuleScreenNew extends StatefulWidget {
  final LabModuleViewModel labModuleModel;
  const LabModuleScreenNew({Key? key, required this.labModuleModel})
      : super(key: key);

  @override
  _LabModuleScreenNewState createState() => _LabModuleScreenNewState();
}

class _LabModuleScreenNewState extends State<LabModuleScreenNew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const FaIcon(
              FontAwesomeIcons.chevronLeft,
              color: Colors.white,
            )),
        title: Text(
          widget.labModuleModel.nameModule!.text,
          style: subtitleStyle,
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Image.asset('assets/unimyLogo.png'),
            ),
            Text(
              widget.labModuleModel.nameModule!.text,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                widget.labModuleModel.titleModule!.text,
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
                                e.titleSection!.text,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            e.titleSection!.text.contains('Discussion') ||
                                    e.titleSection!.text.contains('Conclusion')
                                ? Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    child: TextFormField(
                                        decoration: InputDecoration(
                                            border: const OutlineInputBorder(
                                                borderSide:
                                                    BorderSide(width: 1)),
                                            hintText: e.titleSection!.text)))
                                : Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    child: Column(
                                      children: e.description!.map((e1) {
                                        if (e1.type == 'PICTURE') {
                                          return Image.network(e1.path!);
                                        } else {
                                          return Text(e1.description!.text);
                                        }
                                      }).toList(),
                                    ))
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
