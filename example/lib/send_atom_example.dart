import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:cosmos_sdk/cosmos_sdk.dart';
import 'provider.dart';

void main() async {
  /// Generating BIP39 seed from mnemonic phrase
  final seedBytes = Bip39SeedGenerator(Mnemonic.fromString(
          "mirror fiber cover curve media identify version balance panther world brother milk"))
      .generate();

  /// Deriving hierarchical deterministic (HD) wallet using BIP44
  final bip44 = Bip44.fromSeed(seedBytes, Bip44Coins.cosmos).deriveDefaultPath;
  final pubkey = CosmosSecp256K1PublicKey.fromBytes(bip44.publicKey.compressed);
  final privateKey = CosmosSecp256K1PrivateKey.fromBytes(bip44.privateKey.raw);

// Initializing provider to interact with Tendermint node of Theta testnet
  final provider = TendermintProvider(TendermintHTTPProvider(
      url: "https://rpc.testnet-1.nibiru.fi/"));
  print("address:${pubkey.toAddresss(hrp: 'nibi')}");
  /// Querying account info from the blockchain
  final accountInfo = await provider.request(TendermintRequestAbciQuery(
      request: QueryAccountInfoRequest(pubkey.toAddresss(hrp: 'nibi'))));

  /// Querying the latest block information
  final latestBlock = await provider.request(
      TendermintRequestAbciQuery(request: const GetLatestBlockRequest()));

  /// Creating authentication info for transaction
  final authInfo = AuthInfo(
      signerInfos: [
        SignerInfo(
            publicKey: pubkey,
            modeInfo: const ModeInfo(ModeInfoSignle(SignMode.signModeDirect)),
            sequence: accountInfo.info.sequence)
      ],
      fee: Fee(amount: [
        Coin(
          denom: "unibi",
          amount: BigInt.from(10000),
        )
      ], gasLimit: BigInt.from(200000)));

  /// Creating a transaction message to send tokens
  final message = MsgSend(
      fromAddress: pubkey.toAddresss(hrp: 'nibi'),
      toAddress:
          CosmosBaseAddress("nibi1ewscm78h7dxvurxsfns6ccpp6qazsdv5s6720c"),
      amount: [Coin(denom: "unibi", amount: BigInt.from(1000000))]);

  /// Creating transaction body with the message
  final txbody = TXBody(messages: [message]);

  /// Creating a signable document for the transaction
  final SignDoc signDoc = SignDoc(
      bodyBytes: txbody.toBuffer(),
      authInfoBytes: authInfo.toBuffer(),
      chainId: latestBlock.block!.header.chainId,
      accountNumber: accountInfo.info.accountNumber);
  print("json ${signDoc.toJson()}");
  print("signDoc: ${signDoc.toBuffer()}");
  /// Signing the document with the private key
  final sign = privateKey.sign(signDoc.toBuffer());

  /// Creating a raw transaction with body, authentication info, and signature
  final txRaw = TxRaw(
      bodyBytes: txbody.toBuffer(),
      authInfoBytes: authInfo.toBuffer(),
      signatures: [sign]);

  /// Broadcasting the raw transaction to the networ
  /// k
  var tx = "0x0a8f010a8c010a1c2f636f736d6f732e62616e6b2e763162657461312e4d736753656e64126c0a2b6e696269316d6679396a706134343933343279747a616c3774633077757a33616739336a70617a65726e73122b6e696269316d6679396a706134343933343279747a616c3774633077757a33616739336a70617a65726e731a100a05756e696269120731303030303030126a0a500a460a1f2f636f736d6f732e63727970746f2e736563703235366b312e5075624b657912230a2102e944566eb95a328e39408ef293ae0e0b25dfa09979f1b1d009e212fdb8f7eb3a12040a020801180212160a100a05756e69626912073130303030303010c09a0c1a408ac16a18f85fac1dd99e0cde31ca1b7685d82d799c89c9ab8062697b550f0c762f000c4e7e0a63f81ba3f87985a730148835a28c62bd0ae7e29ba7427bcf65f5";
  var r= await provider.request(TendermintRequestBroadcastTxCommit(tx));
  print("r is:$r");
  /// https://explorer.polypore.xyz/theta-testnet-001/tx/C4F8651D893131E490A4EB76A06D75BC50964FDAAE9030235517571F6104FB62
}
