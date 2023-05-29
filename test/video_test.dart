import 'package:test/test.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'data.dart';

void main() {
  YoutubeExplode? yt;
  setUpAll(() {
    yt = YoutubeExplode();
  });

  tearDownAll(() {
    yt?.close();
  });

  test('Get metadata of a video', () async {
    var videoUrl = 'https://www.youtube.com/watch?v=TW_yxPcodhk';
    var video = await yt!.videos.get(VideoId(videoUrl));
    expect(video.id.value, 'TW_yxPcodhk');
    expect(video.url, videoUrl);
    expect(video.title, 'HexRedirect');
    expect(video.channelId.value, 'UCqKbtOLx4NCBh5KKMSmbX0g');
    expect(video.author, 'Hexah');
    var rangeMs = DateTime(2018, 12, 09).millisecondsSinceEpoch;
    // 1day margin since the uploadDate could differ from timezones
    expect(video.uploadDate!.millisecondsSinceEpoch,
        inInclusiveRange(rangeMs - 86400000, rangeMs + 86400000));
    expect(video.publishDate!.millisecondsSinceEpoch,
        inInclusiveRange(rangeMs - 86400000, rangeMs + 86400000));
    expect(video.description,
        contains('Get it here: https://github.com/Hexer10/HexRedirect'));
    expect(video.duration!.inSeconds, 33);
    expect(video.thumbnails.lowResUrl, isNotEmpty);
    expect(video.thumbnails.mediumResUrl, isNotEmpty);
    expect(video.thumbnails.highResUrl, isNotEmpty);
    expect(video.thumbnails.standardResUrl, isNotEmpty);
    expect(video.thumbnails.maxResUrl, isNotEmpty);
    expect(
        video.keywords,
        containsAll([
          'sourcemod',
          'plugin',
          'csgo',
          'redirect',
        ]));
    expect(video.engagement.viewCount, greaterThanOrEqualTo(3000));
    expect(video.engagement.likeCount, greaterThanOrEqualTo(5));
    expect(video.engagement.dislikeCount, greaterThanOrEqualTo(0));
  });

  group('Get metadata of any video', () {
    for (final videoId in VideoIdData.valid) {
      test('VideoId - ${videoId.id}', () async {
        var video = await yt!.videos.get(videoId.id);
        expect(video.id.value, videoId.id);

        expect(video.uploadDate, isNotNull);
        expect(video.publishDate, isNotNull);
      });
    }
  });

  group('Get metadata of invalid videos throws VideoUnplayableException', () {
    for (final val in VideoIdData.invalid) {
      test('VideoId - $val', () {
        expect(() async => yt!.videos.get(val),
            throwsA(const TypeMatcher<VideoUnplayableException>()));
      });
    }
  });
}
