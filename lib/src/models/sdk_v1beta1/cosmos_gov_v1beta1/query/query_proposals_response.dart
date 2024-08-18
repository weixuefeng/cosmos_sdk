import 'package:cosmos_sdk/src/models/sdk_v1beta1/cosmos_base_query_v1beta1/messages/page_response.dart';
import 'package:cosmos_sdk/src/models/sdk_v1beta1/cosmos_gov_v1beta1/messages/proposal.dart';
import 'package:cosmos_sdk/src/models/sdk_v1beta1/cosmos_gov_v1beta1/types/types.dart';

import 'package:cosmos_sdk/src/protobuf/protobuf.dart';
import 'package:cosmos_sdk/src/utils/quick_extensions.dart';

/// QueryProposalsResponse is the response type for the Query/Proposals RPC method.
class GovQueryProposalsResponse extends CosmosMessage {
  /// proposals defines all the requested governance proposals.
  final List<GovProposal> proposals;

  /// pagination defines the pagination in the response.
  final PageResponse? pagination;
  GovQueryProposalsResponse(
      {required List<GovProposal> proposals, this.pagination})
      : proposals = proposals.immutable;
  factory GovQueryProposalsResponse.deserialize(List<int> bytes) {
    final decode = CosmosProtocolBuffer.decode(bytes);
    return GovQueryProposalsResponse(
        proposals:
            decode.getFields(1).map((e) => GovProposal.deserialize(e)).toList(),
        pagination: decode
            .getResult(2)
            ?.to<PageResponse, List<int>>((e) => PageResponse.deserialize(e)));
  }

  @override
  List<int> get fieldIds => [1, 2];

  @override
  Map<String, dynamic> toJson() {
    return {
      "proposals": proposals.map((e) => e.toJson()).toList(),
      "pagination": pagination?.toJson()
    };
  }

  @override
  String get typeUrl => GovV1beta1types.govQueryProposalsResponse.typeUrl;

  @override
  List get values => [proposals, pagination];
}
