// Donation targets shown on the Info screen.
//
// Deliberately free of Flutter imports so the part that must never be wrong --
// which address belongs to which network, and which QR image goes with it --
// is unit tested on its own.
//
// The QR assets in assets/donate/ were decoded and checked against these
// strings before being committed; `donation_test.dart` keeps the pairing
// honest from here on.

enum DonationNetwork { bitcoin, ethereum, bnb }

class DonationTarget {
  const DonationTarget({
    required this.network,
    required this.name,
    required this.tab,
    required this.chain,
    required this.address,
    required this.qrAsset,
  });

  final DonationNetwork network;

  /// Full name, e.g. "Ethereum".
  final String name;

  /// Caption on the network switch -- must stay short enough for three
  /// side-by-side buttons on a 320 dp screen.
  final String tab;

  /// Network/standard line under the name, e.g. "ERC20".
  final String chain;

  final String address;
  final String qrAsset;
}

const List<DonationTarget> kDonationTargets = <DonationTarget>[
  DonationTarget(
    network: DonationNetwork.bitcoin,
    name: 'Bitcoin',
    tab: 'BTC',
    chain: 'Bitcoin network',
    address: 'bc1q8svagqq04223y5emu2n250qkgzqu6vm806lhh3',
    qrAsset: 'assets/donate/btc.png',
  ),
  DonationTarget(
    network: DonationNetwork.ethereum,
    name: 'Ethereum',
    tab: 'ETH',
    chain: 'ERC20',
    address: '0x2Fc833C2166E8951534f6FEf2ea1A89790e16517',
    qrAsset: 'assets/donate/eth.png',
  ),
  DonationTarget(
    network: DonationNetwork.bnb,
    name: 'BNB Chain',
    tab: 'BNB',
    chain: 'BEP20',
    address: '0x2Fc833C2166E8951534f6FEf2ea1A89790e16517',
    qrAsset: 'assets/donate/bnb.png',
  ),
];

DonationTarget donationTargetFor(DonationNetwork network) =>
    kDonationTargets.firstWhere((t) => t.network == network);
