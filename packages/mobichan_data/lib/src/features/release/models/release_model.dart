import 'package:mobichan_domain/mobichan_domain.dart';

class ReleaseModel extends Release {
  ReleaseModel({
    required super.apkUrl,
    required super.ipaUrl,
    required super.tagName,
    required super.name,
    required super.body,
    required super.size,
  });

  factory ReleaseModel.fromJson(Map<String, dynamic> json) {
    return ReleaseModel(
      apkUrl: (json['assets'] as List)
          .firstWhere(
            (element) => element['name'].contains('.apk'),
            orElse: () => null,
          )
          ?.cast<String, dynamic>()['browser_download_url'],
      ipaUrl: (json['assets'] as List)
          .firstWhere(
            (element) => element['name'].contains('.ipa'),
            orElse: () => null,
          )
          ?.cast<String, dynamic>()['browser_download_url'],
      tagName: json['tag_name'],
      name: json['name'],
      body: json['body'],
      size: json['assets'][0]['size'],
    );
  }
}
