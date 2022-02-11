//
//  HelperFunctions.swift
//  Todo 2 SwiftUI
//
//  Created by Sebastian Morado on 2/11/22.
//

import Foundation
import SwiftUI

func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
