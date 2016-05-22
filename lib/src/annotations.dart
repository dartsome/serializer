/**
 * Created by lejard_h on 22/05/16.
 */

import 'package:reflectable/reflectable.dart';

class Serializable extends Reflectable {
    const Serializable()
        : super.fromList(const [
        invokingCapability,
        typeRelationsCapability,
        metadataCapability,
        superclassQuantifyCapability,
        reflectedTypeCapability
    ]);
}

const serializable = const Serializable();

class Ignore {
    const Ignore();
}

const ignore = const Ignore();

class SerializedName {
    final String name;
    const SerializedName(this.name);
}