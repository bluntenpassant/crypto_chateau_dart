import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:crypto_chateau_dart/client/response.dart';

abstract class Message {
  Uint8List Marshal();
  Unmarshal(Map<String, Uint8List> params);
}

class Error extends Message {
  final String handlerName;
  final String msg;

  Error({required this.handlerName, required this.msg});

  @override
  Unmarshal(Map<String, Uint8List> params) {
    // TODO: implement Unmarshal
    throw UnimplementedError();
  }

  @override
  Uint8List Marshal() {
    // TODO: implement Marshal
    throw UnimplementedError();
  }
}

class User extends Message {
  int? id;
  String? nickname;
  int? age;
  bool? gender;
  String? status;

  User({this.id, this.nickname, this.age, this.gender, this.status});

  Uint8List Marshal() {
    var idConvertedBytes = ByteData.view(Uint8List(8).buffer);
    idConvertedBytes.setUint64(0, id!);

    var ageConvertedBytes = ByteData.view(Uint8List(8).buffer);
    ageConvertedBytes.setUint64(0, id!);

    int convertedGender = 0;

    if (gender == true) {
      convertedGender = 1;
    }

    List<int> data = List.from("(Id:".codeUnits)
      ..addAll(idConvertedBytes.buffer.asUint8List(
          idConvertedBytes.offsetInBytes, idConvertedBytes.lengthInBytes))
      ..addAll(",nickname:\"$nickname\",age:".codeUnits)
      ..addAll(ageConvertedBytes.buffer.asUint8List(
          ageConvertedBytes.offsetInBytes, ageConvertedBytes.lengthInBytes))
      ..addAll(",gender:".codeUnits)
      ..add(convertedGender)
      ..addAll(",status:\"$status\"".codeUnits);

    return Uint8List.fromList(data);
  }

  Unmarshal(Map<String, Uint8List> params) {
    var idBytes = ByteData.view(params["Id"]!.buffer);
    id = idBytes.getUint64(0);

    var ageBytes = ByteData.view(params["Age"]!.buffer);
    age = ageBytes.getUint64(0);

    if (params["Gender"]![0] == 1) {
      gender = true;
    } else {
      gender = false;
    }

    nickname = utf8.decode(params["Nickname"]!);
    status = utf8.decode(params["Status"]!);
  }
}

class FindUsersByPartNicknameRequest extends Message {
  String? partNickname;

  FindUsersByPartNicknameRequest({this.partNickname});

  Uint8List Marshal() {
    List<int> data = List.from(
        "FindUsersByPartNickname# PartNickname:$partNickname".codeUnits);

    return Uint8List.fromList(data);
  }

  @override
  Unmarshal(Map<String, Uint8List> params) {
    // TODO: implement Unmarshal
    throw UnimplementedError();
  }
}

// class UserPresent extends Message {
  
// }

// class FindUsersByPartNicknameResponse extends Message {

// }

class AuthTokenRequest extends Message {
  Uint8List? sessionToken;

  AuthTokenRequest({this.sessionToken});

  Uint8List Marshal() {
    List<int> data = List.from("AuthToken# SessionToken:".codeUnits)
      ..addAll(sessionToken!);

    return Uint8List.fromList(data);
  }

  @override
  Unmarshal(Map<String, Uint8List> params) {
    // TODO: implement Unmarshal
    throw UnimplementedError();
  }
}

class AuthTokenResponse extends Message {
  @override
  Uint8List Marshal() {
    // TODO: implement Marshal
    throw UnimplementedError();
  }

  @override
  Unmarshal(Map<String, Uint8List> params) {}
}

class AuthCredentialsRequest extends Message {
  String? number;
  String? passHash;

  AuthCredentialsRequest({this.number, this.passHash});

  @override
  Uint8List Marshal() {
    List<int> data =
        List.from("AuthCreds# Number:$number,PassHash:$passHash".codeUnits);

    return Uint8List.fromList(data);
  }

  @override
  Unmarshal(Map<String, Uint8List> params) {
    // TODO: implement Unmarshal
    throw UnimplementedError();
  }
}

class AuthCredentialsResponse extends Message {
  Uint8List? sessionToken;

  AuthCredentialsResponse({this.sessionToken});

  @override
  Uint8List Marshal() {
    // TODO: implement Marshal
    throw UnimplementedError();
  }

  @override
  Unmarshal(Map<String, Uint8List> params) {
    sessionToken = params["SessionToken"]!;
  }
}

class RegisterRequest extends Message {
  String? number;
  String? passHash;
  String? bio;
  int? code;
  String? nickname;

  RegisterRequest(
      {this.number, this.passHash, this.bio, this.code, this.nickname});

  @override
  Uint8List Marshal() {
    var codeConvertedBytes = ByteData.view(Uint8List(8).buffer);
    codeConvertedBytes.setUint8(0, code!);

    List<int> data = List.from(
        "Register# Number:$number,PassHash:$passHash,Bio:$bio,Code:".codeUnits)
      ..addAll(codeConvertedBytes.buffer.asUint8List(
          codeConvertedBytes.offsetInBytes, codeConvertedBytes.lengthInBytes));

    return Uint8List.fromList(data);
  }

  @override
  Unmarshal(Map<String, Uint8List> params) {
    // TODO: implement Unmarshal
    throw UnimplementedError();
  }
}

class RegisterResponse extends Message {
  Uint8List? sessionToken;

  RegisterResponse({this.sessionToken});

  @override
  Uint8List Marshal() {
    // TODO: implement Marshal
    throw UnimplementedError();
  }

  @override
  Unmarshal(Map<String, Uint8List> params) {
    sessionToken = params["SessionToken"]!;
  }
}

class SendCodeRequest extends Message {
  String? number;

  SendCodeRequest({this.number});

  Unmarshal(Map<String, Uint8List> params) {
    number = utf8.decode(params["Number"]!);
  }

  Uint8List Marshal() {
    List<int> data = "SendCode# Number:$number".codeUnits;
    return Uint8List.fromList(data);
  }
}

class SendCodeResponse extends Message {
  Uint8List Marshal() {
    return Uint8List(0);
  }

  Unmarshal(Map<String, Uint8List> params) {
    return;
  }
}

class HandleCodeRequest extends Message {
  String? number;
  int? code;

  HandleCodeRequest({this.number, this.code});

  @override
  Uint8List Marshal() {
    var codeConvertedBytes = ByteData.view(Uint8List(8).buffer);
    codeConvertedBytes.setUint8(0, code!);

    List<int> data = List.from("HandleCode# Number:$number, Code:".codeUnits)
      ..addAll(codeConvertedBytes.buffer.asUint8List(
          codeConvertedBytes.offsetInBytes, codeConvertedBytes.lengthInBytes));

    return Uint8List.fromList(data);
  }

  @override
  Unmarshal(Map<String, Uint8List> params) {
    // TODO: implement Unmarshal
    throw UnimplementedError();
  }
}

class HandleCodeResponse extends Message {
  @override
  Uint8List Marshal() {
    // TODO: implement Marshal
    throw UnimplementedError();
  }

  @override
  Unmarshal(Map<String, Uint8List> params) {}
}

// streams
class ListenUpdatesSend {}

class ListenUpdatesGet {
  String eventType;
  String eventBody;

  ListenUpdatesGet({required this.eventBody, required this.eventType});
}
