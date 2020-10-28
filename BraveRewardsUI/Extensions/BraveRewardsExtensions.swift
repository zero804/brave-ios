// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import BraveRewards
import DeviceCheck

extension BraveRewards {
  /// Whether or not Brave Rewards is available/can be enabled
  public static var isAvailable: Bool {
    #if DEBUG
    return true
    #else
    return DCDevice.current.isSupported
    #endif
  }
  
  /// Whether or not rewards is enabled
  public var isEnabled: Bool {
    get {
      ledger.isWalletCreated && ledger.isEnabled && ads.isEnabled
    }
    set {
      ledger.isEnabled = newValue
      ledger.isAutoContributeEnabled = newValue
      ads.isEnabled = newValue
    }
  }
}
