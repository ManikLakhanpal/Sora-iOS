//
//  Keyboard.swift
//  Sora
//
//  Created by Manik Lakhanpal on 17/03/25.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
