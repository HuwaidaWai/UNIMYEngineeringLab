import 'package:flutter/material.dart';
import 'package:smart_engineering_lab/model/user_model.dart';

class LabModuleModel {
  String? nameModule;
  String? titleModule;
  List<Section>? sections;

  LabModuleModel({this.nameModule, this.titleModule, this.sections});
  factory LabModuleModel.fromJson(Map data) {
    return LabModuleModel(
        nameModule: data['nameModule'],
        titleModule: data['titleModule'],
        sections: data['sections']);
  }
}

class LabModuleViewModel {
  TextEditingController? nameModule;
  TextEditingController? titleModule;
  List<SectionViewModel>? sections;
  String? beaconId;
  String? labModuleId;
  String? userPreparedFor;
  List<UserModel>? userPreparedBy;
  String? date;
  bool? submitted;
  LabModuleViewModel(
      {this.nameModule,
      this.titleModule,
      this.sections,
      this.beaconId,
      this.labModuleId,
      this.userPreparedFor,
      this.userPreparedBy,
      this.submitted,
      this.date});
  factory LabModuleViewModel.fromJson(Map data) {
    return LabModuleViewModel(
        nameModule: data['nameModule'],
        titleModule: data['titleModule'],
        sections: data['sections']);
  }

  Map<String, dynamic> toJson() {
    return {
      'nameModule': nameModule!.text,
      'titleModule': titleModule!.text,
      'sections': sections!.map((e) => e.toJson()).toList(),
      'beaconId': beaconId,
      'userPreparedFor': userPreparedFor,
      'userPreparedBy': userPreparedBy!.map((e) => e.toJson()).toList(),
      'submitted': submitted,
      'date': date
    };
  }
}

class Section {
  String? titleSection;
  String? description;

  Section({
    this.titleSection,
    this.description,
  });

  factory Section.fromJson(Map data) {
    return Section(
      titleSection: data['titleSection'],
      description: data['description'],
    );
  }
}

class SectionViewModel {
  TextEditingController? titleSection;
  List<Description>? description;
  // List<Diagram>? diagramPath;

  SectionViewModel({
    this.titleSection,
    this.description,
  });

  factory SectionViewModel.fromJson(Map data) {
    return SectionViewModel(
      titleSection: data['titleSection'],
      description: data['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titleSection': titleSection!.text,
      'description': description!.map((e) => e.toJson()).toList()
    };
  }
}

class Diagram {
  String? title;
  String? path;

  Diagram({this.title, this.path});
}

class Description {
  String? type;
  TextEditingController? description;
  String? path;
  String? pictureLink;

  Description({this.description, this.path, this.type, this.pictureLink});

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'description': description!.text,
      'path': path,
      'pictureLink': pictureLink
    };
  }
}
