// The donation addresses are the one thing in this app that cannot be wrong:
// a typo sends a user's money somewhere unrecoverable. These tests pin the
// exact strings, and check that every target carries its own distinct QR.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:interval_timer/features/info/donation.dart';

void main() {
  group('donation targets', () {
    test('addresses are exactly as published', () {
      expect(donationTargetFor(DonationNetwork.bitcoin).address,
          'bc1q8svagqq04223y5emu2n250qkgzqu6vm806lhh3');
      expect(donationTargetFor(DonationNetwork.ethereum).address,
          '0x2Fc833C2166E8951534f6FEf2ea1A89790e16517');
      expect(donationTargetFor(DonationNetwork.bnb).address,
          '0x2Fc833C2166E8951534f6FEf2ea1A89790e16517');
    });

    test('every network has a target, listed in picker order', () {
      expect(kDonationTargets.map((t) => t.network).toList(),
          DonationNetwork.values);
    });

    test('the two EVM chains deliberately share one address', () {
      // Same key, two chains -- so this is correct, not a copy/paste slip.
      // It is also why the screen warns about picking the right network.
      expect(donationTargetFor(DonationNetwork.ethereum).address,
          donationTargetFor(DonationNetwork.bnb).address);
      expect(donationTargetFor(DonationNetwork.bitcoin).address,
          isNot(donationTargetFor(DonationNetwork.ethereum).address));
    });

    test('each target points at its own QR file, and the file exists', () {
      final assets = kDonationTargets.map((t) => t.qrAsset).toList();
      expect(assets.toSet(), hasLength(assets.length));
      for (final target in kDonationTargets) {
        expect(File(target.qrAsset).existsSync(), isTrue,
            reason: 'missing ${target.qrAsset}');
      }
    });

    test('addresses carry no stray whitespace', () {
      // A trailing space would survive a copy and break a paste into a wallet.
      for (final target in kDonationTargets) {
        expect(target.address, target.address.trim(), reason: target.name);
        expect(target.address.contains(' '), isFalse, reason: target.name);
      }
    });

    test('an EVM address is 0x plus 40 hex digits', () {
      for (final network in [DonationNetwork.ethereum, DonationNetwork.bnb]) {
        expect(donationTargetFor(network).address,
            matches(RegExp(r'^0x[0-9a-fA-F]{40}$')));
      }
    });

    test('tab captions stay short enough for three buttons', () {
      for (final target in kDonationTargets) {
        expect(target.tab.length, lessThanOrEqualTo(5), reason: target.name);
      }
    });
  });
}
