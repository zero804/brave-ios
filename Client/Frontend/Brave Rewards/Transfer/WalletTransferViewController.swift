// Copyright 2020 The Brave Authors. All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import BraveRewards

class WalletTransferViewController: UIViewController, Themeable {
    
    let legacyWallet: BraveLedger
    var learnMoreHandler: (() -> Void)?
    
    init(legacyWallet: BraveLedger) {
        self.legacyWallet = legacyWallet
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError()
    }
    
    private var transferView: WalletTransferView {
        view as! WalletTransferView // swiftlint:disable:this force_cast
    }
    
    override func loadView() {
        view = WalletTransferView()
        applyTheme(Theme.of(nil))
    }
    
    private var isTransferring: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Wallet Transfer"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDone))
        
        transferView.cameraView.scanCallback = { [weak self] paymentId in
            guard let self = self, !paymentId.isEmpty, !self.isTransferring else { return }
            self.isTransferring = true
            self.legacyWallet.linkBraveWallet(paymentId: paymentId) { [weak self] result in
                guard let self = self else { return }
                if result != .ledgerOk {
                    let alert = UIAlertController(title: "Error", message: "Failed (\(result.rawValue) - \(String(describing: result))", preferredStyle: .alert)
                    alert.addAction(.init(title: "OK", style: .default, handler: { _ in
                        self.isTransferring = false
                    }))
                    self.present(alert, animated: true)
                    return
                }
                self.dismiss(animated: true)
            }
        }
        transferView.learnMoreButton.addTarget(self, action: #selector(tappedLearnMoreButton), for: .touchUpInside)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
                applyTheme(Theme.of(nil))
            }
        }
    }
    
    func applyTheme(_ theme: Theme) {
        transferView.applyTheme(theme)
    }
    
    // MARK: - Actions
    
    @objc private func tappedDone() {
        dismiss(animated: true)
    }
    
    @objc private func tappedLearnMoreButton() {
        learnMoreHandler?()
    }
}
