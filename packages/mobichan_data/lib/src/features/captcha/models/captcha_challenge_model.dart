import 'package:mobichan_domain/mobichan_domain.dart';

class CaptchaChallengeModel extends CaptchaChallenge {
  CaptchaChallengeModel({
    required super.challenge,
    required super.expireTime,
    required super.refreshTime,
    required super.foregroundImage,
    required super.foregroundImageWidth,
    required super.foregroundImageHeight,
    required super.backgroundImage,
    required super.backgroundImageWidth,
  });

  factory CaptchaChallengeModel.fromEntity(CaptchaChallenge captchaChallenge) {
    return CaptchaChallengeModel(
      challenge: captchaChallenge.challenge,
      expireTime: captchaChallenge.expireTime,
      refreshTime: captchaChallenge.refreshTime,
      foregroundImage: captchaChallenge.foregroundImage,
      foregroundImageWidth: captchaChallenge.foregroundImageWidth,
      foregroundImageHeight: captchaChallenge.foregroundImageHeight,
      backgroundImage: captchaChallenge.backgroundImage,
      backgroundImageWidth: captchaChallenge.backgroundImageWidth,
    );
  }

  factory CaptchaChallengeModel.fromJson(Map<String, dynamic> json) {
    return CaptchaChallengeModel(
      challenge: json['challenge'],
      expireTime: json['ttl'],
      refreshTime: json['cd'],
      foregroundImage: json['img'],
      foregroundImageWidth: json['img_width'],
      foregroundImageHeight: json['img_height'],
      backgroundImage: json['bg'],
      backgroundImageWidth: json['bg_width'],
    );
  }
}
