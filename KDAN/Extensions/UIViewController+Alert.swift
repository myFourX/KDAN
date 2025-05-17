//
//  UIViewController+Alert.swift
//  KDAN
//
//  Created by our F on 2025/5/15.
//

import UIKit

extension UIViewController {
    func showRetryAlert(message: String,
                        title: String = "錯誤",
                        retryHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

            if let retry = retryHandler {
                alert.addAction(UIAlertAction(title: "再試一次", style: .default) { _ in
                    retry()
                })
            }

            self.present(alert, animated: true)
        }
    }
    
    func showRetryOrBackAlert(message: String,
                              title: String = "錯誤",
                              backHandler: (() -> Void)? = nil,
                              retryHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

            if let back = backHandler {
                alert.addAction(UIAlertAction(title: "返回", style: .default) { _ in
                    back()
                })
            }

            if let retry = retryHandler {
                alert.addAction(UIAlertAction(title: "再試一次", style: .default) { _ in
                    retry()
                })
            }

            self.present(alert, animated: true)
        }
    }
}
