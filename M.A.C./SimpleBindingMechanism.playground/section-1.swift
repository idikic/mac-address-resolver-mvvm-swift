import UIKit
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



/*
 // 0.
class ObservableString {
    var value: String {
        didSet {
            println("did set value to \(value)")
        }
    }

    init(_ v: String) {
        value = v
    }
}

let name = ObservableString("Ivan") // Does not print anything
println(name.value)              // prints: Ivan
name.value = "Slavko"            // prints: did set value to Slavko
*/

/*
 // 1.
class ObservableString {
    typealias Listener = String -> Void
    var listener: Listener?

    func bind(listener: Listener?) {
        self.listener = listener
    }

    var value: String {
        didSet {
            listener?(value)
        }
    }

    init(_ v: String) {
        value = v
    }
}

let name = ObservableString("Ivan")
name.bind({ value in
    println(value)
})

name.value = "Salvko"
name.value = "Jan"
*/

/*
 // 2.
class ObservableString {
    typealias Listener = String -> Void
    var listener: Listener?

    func bind(listener: Listener?) {
        self.listener = listener
    }

    func bindAndFire(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }

    var value: String {
        didSet {
            listener?(value)
        }
    }

    init(_ v: String) {
        value = v
    }
}

let name = ObservableString("Ivan")
name.bindAndFire({ value in
    println(value)
})

name.value = "Salvko"
name.value = "Jan"
*/
