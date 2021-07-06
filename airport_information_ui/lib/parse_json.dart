import 'dart:convert';

class AyxResponse {
  AyxResponse(this.errors, this.warnings, this.outputFiles);
  final List<String> errors;
  final List<String> warnings;
  final List<String> outputFiles;
}

AyxResponse parseJsonResponse(String body) {
  try {
    var jsonResponse = jsonDecode(body);
    List<String> errors = List.from(jsonResponse['Errors'] ?? <String>[]);
    List<String> warnings = List.from(jsonResponse['Warnings'] ?? <String>[]);
    List<String> outputFiles = List.from(jsonResponse['OutputFiles'] ?? <String>[]);
    return AyxResponse(errors, warnings, outputFiles);
  } catch (ex, trace) {
    print("error parsing json response:\n$trace");
    return AyxResponse(<String>['the response was not a valid JSON response in the expected format'],[],[]);
  }
}