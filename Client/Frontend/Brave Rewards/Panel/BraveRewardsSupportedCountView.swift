// Copyright 2020 The Brave Authors. All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

class BraveRewardsSupportedCountView: UIStackView, Themeable {
    
    let countLabel = UILabel().then {
        $0.text = "0"
        $0.font = .systemFont(ofSize: 36)
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    private let bodyLabel = UILabel().then {
        $0.text = "Supported publishers and creators this month."
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 13)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        spacing = 16
        alignment = .center
        layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 64)
        isLayoutMarginsRelativeArrangement = true
        
        addStackViewItems(
            .view(countLabel),
            .view(bodyLabel)
        )
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func applyTheme(_ theme: Theme) {
        let isDark = theme.isDark
        countLabel.textColor = isDark ? UIColor.white : UIColor.black
        bodyLabel.textColor = isDark ? UIColor.white : UIColor.black
    }
}