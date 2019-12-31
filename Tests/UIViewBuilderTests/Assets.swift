//
//  Assets.swift
//  
//
//  Created by tarunon on 2020/01/01.
//

import UIViewBuilder
import UIKit

struct Label: UIViewRepresentable {
    typealias View = UILabel
    var text: String

    func create() -> UILabel {
        let native = UILabel()
        native.translatesAutoresizingMaskIntoConstraints = false
        native.text = text
        return native
    }

    func update(native: UILabel) {
        native.text = text
    }
}

struct TextView: UIViewRepresentable {
    typealias View = UITextView
    var text: String

    func create() -> UITextView {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }

    func update(native: UITextView) {
        native.text = text
    }
}

struct Button: UIViewRepresentable {
    typealias View = UIButton
    var text: String

    func create() -> UIButton {
        let native = UIButton()
        native.translatesAutoresizingMaskIntoConstraints = false
        native.setTitle(text, for: .normal)
        return native
    }

    func update(native: UIButton) {
        native.setTitle(text, for: .normal)
    }
}
