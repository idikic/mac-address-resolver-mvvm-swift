//
//  Observable.swift
//  M.A.C.
//
//  Based on:
//  http://rasic.info/from-mvc-to-mvvm-in-swift/
//
//  Created by Ivan Dikic on 10/02/15.
//  Copyright (c) 2015 Iki. All rights reserved.
//

import Foundation

class Observable<T> {
  typealias Listener = T -> Void
  var listener: Listener?

  func bind(listener: Listener?) {
    self.listener = listener
  }

  func bindAndFire(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }

  var value: T {
    didSet {
      listener?(value)
    }
  }

  init(_ v: T) {
    self.value = v
  }
}