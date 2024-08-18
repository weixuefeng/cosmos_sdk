import 'package:cosmos_sdk/src/models/networks/osmosis/osmosis_downtimedetector_v1beta1/types/types.dart';
import 'package:cosmos_sdk/src/protobuf/protobuf.dart';
import 'package:cosmos_sdk/src/utils/quick_extensions.dart';
import 'genesis_downtime_entry.dart';

/// GenesisState defines the twap module's genesis state.
class OsmosisDowntimeDetectorGenesisState extends CosmosMessage {
  final List<OsmosisDowntimeDetectorGenesisDowntimeEntry> downtimes;
  final ProtobufTimestamp lastBlockTime;
  OsmosisDowntimeDetectorGenesisState(
      {required List<OsmosisDowntimeDetectorGenesisDowntimeEntry> downtimes,
      required this.lastBlockTime})
      : downtimes = downtimes.immutable;
  factory OsmosisDowntimeDetectorGenesisState.deserialize(List<int> bytes) {
    final decode = CosmosProtocolBuffer.decode(bytes);
    return OsmosisDowntimeDetectorGenesisState(
        downtimes: decode
            .getFields(1)
            .map((e) =>
                OsmosisDowntimeDetectorGenesisDowntimeEntry.deserialize(e))
            .toList(),
        lastBlockTime: ProtobufTimestamp.deserialize(decode.getField(2)));
  }

  @override
  List<int> get fieldIds => [1, 2];

  @override
  Map<String, dynamic> toJson() {
    return {
      "downtimes": downtimes.map((e) => e.toJson()).toList(),
      "last_block_time": lastBlockTime.toJson()
    };
  }

  @override
  String get typeUrl =>
      OsmosisDowntimeDetectorV1beta1Types.genesisState.typeUrl;

  @override
  List get values => [downtimes, lastBlockTime];
}
