import 'package:airport_information_ui/parse_json.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  test("decode normal response",(){
    var normalResponse = """{"Warnings":null,"Errors":null,"OutputFiles":["Some file"]}""";
    var response = parseJsonResponse(normalResponse);

    expect(response.errors, isNotNull);
    expect(response.errors.length, equals(0));
    expect(response.warnings, isNotNull);
    expect(response.warnings.length, equals(0));
    expect(response.outputFiles, isNotNull);
    expect(response.outputFiles.length, equals(1));
    expect(response.outputFiles[0], equals('Some file'));
  });

  test("decode all nulls",(){
    var webResponse = """{"Warnings":null,"Errors":null,"OutputFiles":null}""";
    var response = parseJsonResponse(webResponse);

    expect(response.errors, isNotNull);
    expect(response.errors.length, equals(0));
    expect(response.warnings, isNotNull);
    expect(response.warnings.length, equals(0));
    expect(response.outputFiles, isNotNull);
    expect(response.outputFiles.length, equals(0));
  });

  test("decode empty json object",(){
    var webResponse = """{}""";
    var response = parseJsonResponse(webResponse);

    expect(response.errors, isNotNull);
    expect(response.errors.length, equals(0));
    expect(response.warnings, isNotNull);
    expect(response.warnings.length, equals(0));
    expect(response.outputFiles, isNotNull);
    expect(response.outputFiles.length, equals(0));
  });

  test("decode invalid json",(){
    var webResponse = """error: not json""";
    var response = parseJsonResponse(webResponse);

    expect(response.errors, isNotNull);
    expect(response.errors.length, equals(1));
    expect(response.errors[0], equals("the response was not a valid JSON response in the expected format"));
    expect(response.warnings, isNotNull);
    expect(response.warnings.length, equals(0));
    expect(response.outputFiles, isNotNull);
    expect(response.outputFiles.length, equals(0));
  });

  test("decode invalid property type",(){
    var webResponse = """{"Warnings":"Hello world","Errors":null,"OutputFiles":["Some file"]}""";
    var response = parseJsonResponse(webResponse);

    expect(response.errors, isNotNull);
    expect(response.errors.length, equals(1));
    expect(response.errors[0], equals("the response was not a valid JSON response in the expected format"));
    expect(response.warnings, isNotNull);
    expect(response.warnings.length, equals(0));
    expect(response.outputFiles, isNotNull);
    expect(response.outputFiles.length, equals(0));
  });

  test("decode response that is failing to provide output files", (){
    var webResponse = """{"Errors":null,"Warnings":null,"OutputFiles":["/Data/1b603a0f-fe36-4732-9940-a613301cbba3/TTA RDU Airport Notes.html"]}""";
    var response = parseJsonResponse(webResponse);

    expect(response.errors, isNotNull);
    expect(response.errors.length, equals(0));
    expect(response.warnings, isNotNull);
    expect(response.warnings.length, equals(0));
    expect(response.outputFiles, isNotNull);
    expect(response.outputFiles.length, equals(1));
    expect(response.outputFiles[0], equals("/Data/1b603a0f-fe36-4732-9940-a613301cbba3/TTA RDU Airport Notes.html"));
  });
}