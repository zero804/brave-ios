// Copyright 2020 The Brave Authors. All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import WebKit

extension WKUserContentController {
    public func addInDefaultContentWorld(scriptMessageHandler: WKScriptMessageHandler, name: String) {
        if #available(iOS 14.0, *) {
            add(scriptMessageHandler, contentWorld: .defaultClient, name: name)
        } else {
            add(scriptMessageHandler, name: name)
        }
    }
}

extension WKUserScript {
    public class func createInDefaultContentWorld(source: String, injectionTime: WKUserScriptInjectionTime, forMainFrameOnly: Bool) -> WKUserScript {
        if #available(iOS 14.0, *) {
            return WKUserScript(source: source, injectionTime: injectionTime, forMainFrameOnly: forMainFrameOnly, in: .defaultClient)
        } else {
            return WKUserScript(source: source, injectionTime: injectionTime, forMainFrameOnly: forMainFrameOnly)
        }
    }
}

public extension WKWebView {
    private func generateJavascriptFunctionString(functionName: String, args: [Any], escapeArgs: Bool = true) -> String {
        let argsJS = args
          .map { escapeArgs ? "'\(String(describing: $0).escapeHTML())'" : "\($0)"}
          .joined(separator: ", ")
        return "\(functionName)(\(argsJS))"
    }

    func evaluateSafeJavascript(functionName: String, args: [Any], sandboxed: Bool = true, escapeArgs: Bool = true, completion: @escaping ((Any?, Error?) -> Void)) {
        let javascript = generateJavascriptFunctionString(functionName: functionName, args: args, escapeArgs: escapeArgs)
        if #available(iOS 14.0, *), sandboxed {
            evaluateJavaScript(javascript, in: nil, in: .defaultClient) { result  in
                switch result {
                    case .success(let value):
                        completion(value, nil)
                    case .failure(let error):
                        completion(nil, error)
                }
            }
        } else {
            evaluateJavaScript(javascript) { data, error  in
                completion(data, error)
            }
        }
    }
}

extension String {
    /// Encode HTMLStrings
    func escapeHTML() -> String {
       return self
        .replacingOccurrences(of: "&", with: "&amp;", options: .literal)
        .replacingOccurrences(of: "\"", with: "&quot;", options: .literal)
        .replacingOccurrences(of: "'", with: "&#39;", options: .literal)
        .replacingOccurrences(of: "<", with: "&lt;", options: .literal)
        .replacingOccurrences(of: ">", with: "&gt;", options: .literal)
        .replacingOccurrences(of: "`", with: "&lsquo;", options: .literal)
    }
}

