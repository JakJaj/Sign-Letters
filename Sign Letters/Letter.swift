//
//  Letter.swift
//  Sign Letters
//
//  Created by Jakub Jajonek on 17/01/2024.
//

import Foundation
import SwiftUI

struct Letter: Identifiable {
    let id = UUID()
    let name: String
    let imageDarkMode: Image
    let imageLightMode: Image
}
