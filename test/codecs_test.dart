// Copyright (c) 2016, the Serializer project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:bson/bson.dart';
import 'package:test/test.dart';

import 'package:serializer/codecs.dart';

main() {
  group("Codecs", ()
  {
    test("DateTime microseconds", () {
      var codec = new DateTimeCodec();
      var date = new DateTime(2015, 12, 24, 13, 37, 42, 789, 23);
      expect(codec.encode(date), "2015-12-24T13:37:42.789023");
      expect(codec.decode("2015-12-24T13:37:42.789023").isAtSameMomentAs(date), isTrue);
    }, onPlatform: {
      "browser": new Skip("microseconds not supported on browser"),
    });

    test("DateTime", () {
      var codec = new DateTimeCodec();
      var date = new DateTime(2015, 12, 24, 13, 37, 42, 789);
      expect(codec.encode(date), "2015-12-24T13:37:42.789");
      expect(codec.decode("2015-12-24T13:37:42.789").isAtSameMomentAs(date), isTrue);
    });

    test("DateTimeMilliseconds", () {
      var codec = new DateTimeMillisecondsSinceEpochCodec();
      var date = new DateTime.utc(2015, 12, 24, 13, 37, 42, 789);
      expect(codec.encode(date), 1450964262789);
      expect(codec.decode(1450964262789).isAtSameMomentAs(date), isTrue);
    });

    test("DateTimeSeconds", () {
      var codec = new DateTimeSecondsSinceEpochCodec();
      var date = new DateTime.utc(2015, 12, 24, 13, 37, 42);
      expect(codec.encode(date), 1450964262);
      expect(codec.decode(1450964262).isAtSameMomentAs(date), isTrue);
    });

    test("DateTimeUtc microsecond", () {
      var codec = new DateTimeUtcCodec();
      var date = new DateTime.utc(2015, 12, 24, 13, 37, 42, 789, 23);
      expect(codec.encode(date), "2015-12-24T13:37:42.789023Z");
      expect(codec.decode("2015-12-24T13:37:42.789023Z").isAtSameMomentAs(date), isTrue);
    }, onPlatform: {
      "browser": new Skip("microseconds not supported on browser"),
    });

    test("DateTimeUtc microsecond", () {
      var codec = new DateTimeUtcCodec();
      var date = new DateTime.utc(2015, 12, 24, 13, 37, 42, 789);
      expect(codec.encode(date), "2015-12-24T13:37:42.789Z");
      expect(codec.decode("2015-12-24T13:37:42.789Z").isAtSameMomentAs(date), isTrue);
    });

    test("ObjectId", () {
      var codec = new ObjectIdCodec();
      var id = new ObjectId.fromHexString("57b03416980aa02c8c0e772c");
      expect(codec.encode(id), id);
      expect(codec.encode(id).toJson(), "57b03416980aa02c8c0e772c");
      expect(codec.decode("57b03416980aa02c8c0e772c").toHexString(), "57b03416980aa02c8c0e772c");
    });
  });
}
