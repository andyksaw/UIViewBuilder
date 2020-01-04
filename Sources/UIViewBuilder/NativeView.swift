//
//  NativeView.swift
//  
//
//  Created by tarunon on 2020/01/02.
//

import UIKit

protocol Mountable {
    func mount(viewController: UIViewController, at index: Int, parent: UIViewController)
    func mount(view: UIView, at index: Int)
    func unmount(viewController: UIViewController)
    func unmount(view: UIView)
}

extension Mountable {
    func update(differences: [Difference], natives: inout [NativeViewProtocol], parent: UIViewController) {
        differences.forEach { difference in
            switch difference.change {
            case .remove:
                natives[difference.index].unmount(from: self)
                natives.remove(at: difference.index)
            case .insert(let component):
                let native = component.create()[0]
                native.mount(to: self, at: difference.index, parent: parent)
                natives.insert(native, at: difference.index)
            case .update(let component):
                component.update(native: natives[difference.index])
            }
        }
    }
}

protocol NativeViewProtocol: class {
    func mount(to target: Mountable, at index: Int, parent: UIViewController)
    func unmount(from target: Mountable)
}

extension UIView: NativeViewProtocol {
    func mount(to target: Mountable, at index: Int, parent: UIViewController) {
        target.mount(view: self, at: index)
    }

    func unmount(from target: Mountable) {
        target.unmount(view: self)
    }
}

extension UIViewController: NativeViewProtocol {
    func mount(to target: Mountable, at index: Int, parent: UIViewController) {
        target.mount(viewController: self, at: index, parent: parent)
    }

    func unmount(from target: Mountable) {
        target.unmount(viewController: self)
    }
}
