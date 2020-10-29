// Copyright 2020 The Brave Authors. All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import BraveShared
import BraveUI

extension BraveRewardsViewController {
    class BraveRewardsView: UIStackView, Themeable {
        
        let rewardsToggle = UISwitch().then {
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.appearanceOnTintColor = Colors.blurple400
        }
        private let titleLabel = UILabel().then {
            $0.text = "Brave Rewards"
            $0.font = .systemFont(ofSize: 20)
        }
        private let subtitleLabel = UILabel().then {
            $0.text = "You are supporting content creators"
            $0.font = .systemFont(ofSize: 12)
        }
        private let dividerView = UIView().then {
            $0.snp.makeConstraints {
                $0.height.equalTo(1.0 / UIScreen.main.scale)
            }
        }
        let publisherView = BraveRewardsPublisherView()
        let supportedCountView = BraveRewardsSupportedCountView()
        let legacyWalletTransferButton = LegacyWalletTransferButton()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            axis = .vertical
            spacing = 0
            
            addStackViewItems(
                .view(UIStackView().then {
                    $0.axis = .horizontal
                    $0.alignment = .center
                    $0.spacing = 12
                    $0.isLayoutMarginsRelativeArrangement = true
                    $0.layoutMargins = UIEdgeInsets(equalInset: 20)
                    $0.addStackViewItems(
                        .view(UIStackView().then {
                            $0.axis = .vertical
                            $0.spacing = 4
                            $0.addStackViewItems(
                                .view(titleLabel),
                                .view(subtitleLabel)
                            )
                            $0.setContentHuggingPriority(.required, for: .vertical)
                        }),
                        .view(rewardsToggle)
                    )
                }),
                .view(dividerView),
                .view(publisherView),
                .view(supportedCountView),
                .view(legacyWalletTransferButton)
            )
        }
        
        @available(*, unavailable)
        required init(coder: NSCoder) {
            fatalError()
        }
        
        func applyTheme(_ theme: Theme) {
            let isDark = theme.isDark
            titleLabel.textColor = isDark ? UIColor.white : UIColor.black
            subtitleLabel.textColor = isDark ? UIColor.lightGray : UIColor.gray
            dividerView.backgroundColor = UIColor(white: isDark ? 1.0 : 0.0, alpha: 0.2)
            publisherView.applyTheme(theme)
            supportedCountView.applyTheme(theme)
            legacyWalletTransferButton.applyTheme(theme)
            backgroundColor = theme.isDark ? UIColor(rgb: 0x17171f) : UIColor.white
        }
    }
}