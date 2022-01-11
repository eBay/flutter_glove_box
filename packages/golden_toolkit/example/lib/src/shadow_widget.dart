/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

/// Don't look at this code as an example of good Flutter code. This code is a mess.
/// Thankfully, we have pixel perfect golden tests to protect us if we ever
/// refactor and clean it up!

class ShadowWidget extends StatelessWidget {
  const ShadowWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -4),
                  blurRadius: 16,
                  color: Colors.black.withOpacity(0.1),
                )
              ],
              color: Colors.lightBlue.shade50,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 16,
                  color: Colors.black.withOpacity(0.1),
                )
              ],
              color: Colors.lightBlue.shade50,
            ),
          ),
        ],
      ),
    );
  }
}
