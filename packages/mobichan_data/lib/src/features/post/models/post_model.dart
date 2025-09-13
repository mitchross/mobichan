import 'package:mobichan_data/mobichan_data.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

// ignore: must_be_immutable
class PostModel extends Post {
  PostModel({
    super.no,
    super.now,
    super.name,
    super.time,
    super.resto,
    super.sticky,
    super.closed,
    super.sub,
    super.com,
    super.filename,
    super.ext,
    super.w,
    super.h,
    super.tnW,
    super.tnH,
    super.tim,
    super.md5,
    super.fsize,
    super.capcode,
    super.semanticUrl,
    super.replies,
    super.images,
    super.uniqueIps,
    super.trip,
    super.lastModified,
    super.country,
    super.boardId,
    super.boardTitle,
    super.boardWs,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      no: (json['no'] as num?)?.toInt() ?? 0,
      sticky: (json['sticky'] as num?)?.toInt(),
      closed: (json['closed'] as num?)?.toInt(),
      now: json['now'] ?? '',
      name: json['name'],
      sub: json['sub'],
      com: json['com'],
      filename: json['filename'],
      ext: json['ext'],
      w: (json['w'] as num?)?.toInt(),
      h: (json['h'] as num?)?.toInt(),
      tnW: (json['tn_w'] as num?)?.toInt(),
      tnH: (json['tn_h'] as num?)?.toInt(),
      tim: (json['tim'] as num?)?.toInt(),
      time: (json['time'] as num?)?.toInt() ?? 0,
      md5: json['md5'],
      fsize: (json['fsize'] as num?)?.toInt(),
      resto: (json['resto'] as num?)?.toInt() ?? 0,
      capcode: json['capcode'],
      semanticUrl: json['semantic_url'],
      replies: (json['replies'] as num?)?.toInt(),
      images: (json['images'] as num?)?.toInt(),
      uniqueIps: (json['unique_ips'] as num?)?.toInt(),
      trip: json['trip'],
      lastModified: (json['last_modified'] as num?)?.toInt(),
      country: json['country'],
      boardId: json['board_id'],
      boardTitle: json['board_title'],
      boardWs: (json['board_ws'] as num?)?.toInt(),
    );
  }

  factory PostModel.fromEntity(Post post) {
    return PostModel(
      no: post.no,
      now: post.now,
      name: post.name,
      time: post.time,
      resto: post.resto,
      sticky: post.sticky,
      closed: post.closed,
      sub: post.sub,
      com: post.com,
      filename: post.filename,
      ext: post.ext,
      w: post.w,
      h: post.h,
      tnW: post.tnW,
      tnH: post.tnH,
      tim: post.tim,
      md5: post.md5,
      fsize: post.fsize,
      capcode: post.capcode,
      semanticUrl: post.semanticUrl,
      replies: post.replies,
      images: post.images,
      uniqueIps: post.uniqueIps,
      trip: post.trip,
      lastModified: post.lastModified,
      country: post.country,
      boardId: post.boardId,
      boardTitle: post.boardTitle,
      boardWs: post.boardWs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no': no,
      'now': now,
      'name': name,
      'time': time,
      'resto': resto,
      'sticky': sticky,
      'closed': closed,
      'sub': sub,
      'com': com,
      'filename': filename,
      'ext': ext,
      'w': w,
      'h': h,
      'tn_w': tnW,
      'tn_h': tnH,
      'tim': tim,
      'md5': md5,
      'fsize': fsize,
      'capcode': capcode,
      'semantic_url': semanticUrl,
      'replies': replies,
      'images': images,
      'unique_ips': uniqueIps,
      'trip': trip,
      'last_modified': lastModified,
      'country': country,
      'board_id': boardId,
      'board_title': boardTitle,
      'board_ws': boardWs,
    };
  }
}

extension PostModelListExtension on List<PostModel> {
  List<PostModel> sortedBySort(SortModel sort) {
    switch (sort.order) {
      case Order.byBump:
        return this
          ..sort((a, b) {
            return a.lastModified!.compareTo(b.lastModified!);
          });
      case Order.byReplies:
        return this
          ..sort((a, b) {
            return b.replies!.compareTo(a.replies!);
          });
      case Order.byImages:
        return this
          ..sort((a, b) {
            return b.images!.compareTo(a.images!);
          });
      case Order.byNew:
        return this
          ..sort((a, b) {
            return b.time.compareTo(a.time);
          });
      case Order.byOld:
        return this
          ..sort((a, b) {
            return a.time.compareTo(b.time);
          });
    }
  }
}
