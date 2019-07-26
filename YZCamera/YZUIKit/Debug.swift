//
//  Debug.swift
//  YZCamera
//
//  Created by Q YiZhong on 2019/7/26.
//  Copyright © 2019 Q YiZhong. All rights reserved.
//

import Foundation

public func YZLog<T>(_ message: T) {
    #if DEBUG
    print("\(message)")
    #endif
}
