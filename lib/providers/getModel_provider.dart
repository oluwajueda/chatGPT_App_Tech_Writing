import 'package:chat_tutorial/models/openAI_Model.dart';
import 'package:flutter/material.dart';

import '../API_Services/api_services.dart';

class ModelsProvider with ChangeNotifier {
  List<OpenaiModel> modelsList = [];
  String currentModel = "text-davinci-003";

  List<OpenaiModel> get getModelsList {
    return modelsList;
  }

  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;

    notifyListeners();
  }

  Future<List<OpenaiModel>> getAllModels() async {
    modelsList = await ApiServices.getModels();
    return modelsList;
  }
}
