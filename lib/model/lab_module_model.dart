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

class Section {
  String? titleSection;
  String? description;
  List<Diagram>? diagramPath;

  Section({this.titleSection, this.description, this.diagramPath});

  factory Section.fromJson(Map data) {
    return Section(
        titleSection: data['titleSection'],
        description: data['description'],
        diagramPath: data['diagramPath']);
  }
}

class Diagram {
  String? title;
  String? path;

  Diagram({this.title, this.path});
}
