import 'dart:convert';
import 'package:covid/Services/Utlilities/app_url.dart';
import 'package:covid/Model/WorldStatesModel.dart';
import 'package:http/http.dart'as http;

class StatesServices{

  Future <WorldStatesModel> fetchWorldStatesRecords () async{
    final response = await http.get(Uri.parse(AppUrl.worldStatesApi));
    if(response.statusCode==200){
      var data=jsonDecode(response.body.toString());
      return WorldStatesModel.fromJson(data);
    }
    else{
      throw Exception('Error');
    }
  }

  Future <List<dynamic>> countriesListApi () async{
    var data;
    final response = await http.get(Uri.parse(AppUrl.countriesList));
    if(response.statusCode==200){
       data=jsonDecode(response.body.toString());
      return data;
    }
    else{
      throw Exception('Error');
    }
  }
}