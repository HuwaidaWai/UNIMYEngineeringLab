import 'package:flutter/material.dart';

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
  String? nameModule;
  String? titleModule;
  List<SectionViewModel>? sections;
  String? beaconId;
  String? labModuleId;
  String? userPrepared;

  LabModuleViewModel(
      {this.nameModule,
      this.titleModule,
      this.sections,
      this.beaconId,
      this.labModuleId,
      this.userPrepared});
  factory LabModuleViewModel.fromJson(Map data) {
    return LabModuleViewModel(
        nameModule: data['nameModule'],
        titleModule: data['titleModule'],
        sections: data['sections']);
  }

  Map<String, dynamic> toJson() {
    return {
      'nameModule': nameModule!,
      'titleModule': titleModule!,
      'sections': sections!.map((e) => e.toJson()).toList(),
      'beaconId': beaconId,
      'userPrepared': userPrepared
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
  String? titleSection;
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
      'titleSection': titleSection!,
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
  String? description;
  String? path;

  Description({this.description, this.path, this.type});

  Map<String, dynamic> toJson() {
    return {'type': type, 'description': description!, 'path': path};
  }
}
