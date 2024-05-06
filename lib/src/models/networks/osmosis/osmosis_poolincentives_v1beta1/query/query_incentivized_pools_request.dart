import 'package:cosmos_sdk/src/models/networks/osmosis/osmosis_poolincentives_v1beta1/types/types.dart';
import 'package:cosmos_sdk/src/protobuf/protobuf.dart';
import 'query_incentivized_pools_response.dart';

class OsmosisPoolincentivesQueryIncentivizedPoolsRequest extends CosmosMessage
    with
        QueryMessage<OsmosisPoolincentivesQueryIncentivizedPoolsResponse>,
        RPCMessage<OsmosisPoolincentivesQueryIncentivizedPoolsResponse> {
  OsmosisPoolincentivesQueryIncentivizedPoolsRequest();
  factory OsmosisPoolincentivesQueryIncentivizedPoolsRequest.deserialize(
      List<int> bytes) {
    return OsmosisPoolincentivesQueryIncentivizedPoolsRequest();
  }

  @override
  List<int> get fieldIds => [];

  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  OsmosisPoolincentivesQueryIncentivizedPoolsResponse onJsonResponse(
      Map<String, dynamic> json) {
    return OsmosisPoolincentivesQueryIncentivizedPoolsResponse.fromRpc(json);
  }

  @override
  OsmosisPoolincentivesQueryIncentivizedPoolsResponse onResponse(
      List<int> bytes) {
    return OsmosisPoolincentivesQueryIncentivizedPoolsResponse.deserialize(
        bytes);
  }

  @override
  String get typeUrl =>
      OsmosisPoolincentivesV1beta1Types.queryIncentivizedPoolsRequest.typeUrl;
  @override
  List get values => [];

  @override
  Map<String, String?> get queryParameters => {};

  @override
  String get queryPath =>
      OsmosisPoolincentivesV1beta1Types.incentivizedPools.typeUrl;

  @override
  String get rpcPath => OsmosisPoolincentivesV1beta1Types.incentivizedPools
      .rpcUrl(pathParameters: []);
}
