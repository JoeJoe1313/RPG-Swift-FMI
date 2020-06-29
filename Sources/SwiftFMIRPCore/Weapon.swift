protocol Weapon: Equatable {
    func isEqualTo(_ other: Weapon) -> Bool
    var attack: Int {get set}
    var defence: Int {get}
}

extension Weapon where Self: Equatable {
    func isEqualTo(_ other: Weapon) -> Bool {
        guard let otherWeapon = other as? Self else { return false }
        return self == otherWeapon
    }
}

struct AnyEquatableWeapon: Weapon {
    init(_ weapon: Weapon) {
        self.weapon = weapon
    }
    
    var attack: Int {
        return weapon.attack
    }
    
    var defence: Int {
        return weapon.defence
    }
    
    private let weapon: Weapon
}

extension AnyEquatableWeapon: Equatable {
    static func ==(lhs: AnyEquatableWeapon, rhs: AnyEquatableWeapon) -> Bool {
        return lhs.weapon.isEqualTo(rhs.weapon)
    }
}

struct WoodenStick: Weapon {
    var attack: Int = 2
    var defence: Int = 1
}

struct Axe: Weapon {
    var attack: Int = 3
    var defence: Int = 2
}

struct Bow: Weapon {
    var attack: Int = 4
    var defence: Int = 2
}

struct Sword: Weapon {
    var attack: Int = 3
    var defence: Int = 3
}
