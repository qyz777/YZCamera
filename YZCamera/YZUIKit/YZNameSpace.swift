//
//  YZNameSpace.swift
//  YZCamera
//
//  Created by Q YiZhong on 2019/7/26.
//  Copyright © 2019 Q YiZhong. All rights reserved.
//

import Foundation

class YZNamespace<Base> {
    public var base: Base
    init(_ base: Base) {
        self.base = base
    }
}

protocol YZNamespaceProtocol {}
extension NSObject: YZNamespaceProtocol {}
extension String: YZNamespaceProtocol {}
extension Array: YZNamespaceProtocol {}
extension YZNamespaceProtocol {
    var yz: YZNamespace<Self> {
        return YZNamespace<Self>(self)
    }
    static var yz: YZNamespace<Self>.Type {
        return YZNamespace<Self>.self
    }
}
