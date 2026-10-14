//
//  SessionStorage.swift
//  MDI1-117-Ch-9-LoginKit
//
//  Created by Andres de la Cruz on 10/7/26.
//

import Foundation
 
nonisolated protocol SessionStoring {
    var rememberedEmail: String? { get set }
    func clear()
}
 
final class SessionStore: SessionStoring {
    private let defaults: UserDefaults
    private let key = "rememberedEmail"
 
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
 
    var rememberedEmail: String? {
        get { defaults.string(forKey: key) }
        set {
            defaults.set(newValue, forKey: key)
            defaults.synchronize()
        }
    }
 
    func clear() {
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
}
 
