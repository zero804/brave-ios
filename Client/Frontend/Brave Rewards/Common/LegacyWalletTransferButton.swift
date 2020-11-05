// Copyright 2020 The Brave Authors. All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import BraveUI
import Shared

class LegacyWalletTransferButton: UIControl, Themeable {
    
    private let topBorderView = UIView()
    
    private let imageView = UIImageView(image: UIImage(imageLiteralResourceName: "rewards-qr-code").template).then {
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    private let label = UILabel().then {
        $0.text = Strings.Rewards.legacyWalletTransfer
        $0.font = .systemFont(ofSize: 16)
        $0.numberOfLines = 0
    }
    
    private let learnMoreLabel = UILabel().then {
        $0.text = Strings.learnMore
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = UIStackView().then {
            $0.alignment = .center
            $0.spacing = 14
            $0.isUserInteractionEnabled = false
        }
        
        isAccessibilityElement = true
        accessibilityTraits.insert(.button)
        
        addSubview(topBorderView)
        addSubview(stackView)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(learnMoreLabel)
        
        accessibilityLabel = label.text
        
        topBorderView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self)
            $0.height.equalTo(1.0 / UIScreen.main.scale)
        }
        stackView.snp.makeConstraints {
            $0.leading.equalTo(self).inset(20)
            $0.top.bottom.equalTo(self).inset(14)
            $0.trailing.equalTo(self).inset(20)
        }
    }
    
    func applyTheme(_ theme: Theme) {
        let isDark = theme.isDark
        appearanceBackgroundColor = isDark ? Colors.grey900 : Colors.neutral000
        topBorderView.backgroundColor = UIColor(white: isDark ? 1.0 : 0.0, alpha: 0.2)
        imageView.tintColor = isDark ? Colors.grey300 : Colors.grey600
        label.textColor = theme.colors.tints.home
        learnMoreLabel.textColor = isDark ? Colors.blurple300 : Colors.blurple400
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError()
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.15) {
                self.label.alpha = self.isHighlighted ? 0.4 : 1.0
                self.learnMoreLabel.alpha = self.isHighlighted ? 0.4 : 1.0
                self.imageView.alpha = self.isHighlighted ? 0.4 : 1.0
            }
        }
    }
}
