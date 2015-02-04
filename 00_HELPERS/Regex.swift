//
//  Regex.swift
//  M.A.C.
//
//  Created by Ivan Dikic on 04/02/15.
//  Copyright (c) 2015 Iki. All rights reserved.
//

import Foundation

let kValidMACAddressRegex = "^([[:xdigit:]]{2}(:|-|\\.)?){5}[[:xdigit:]]{2}$"

private class Regex {
    let pattern: String

    init (_ pattern: String) {
        self.pattern = pattern;
    }

    func test(input: String) -> Bool {
        let range = input.rangeOfString(pattern,
            options: .RegularExpressionSearch)
        return range != nil
    }
}

infix operator =~ {}
func =~(input: String, pattern: String) -> Bool {
    return Regex(pattern).test(input)
}
