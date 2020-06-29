protocol Armor: Equatable {
    func isEqualTo(_ other: Armor) -> Bool
    var attack: Int {get}
    var defence: Int {get}
}

extension Armor where Self: Equatable {
    func isEqualTo(_ other: Armor) -> Bool {
        guard let otherArmor = other as? Self else { return false }
        return self == otherArmor
    }
}

struct AnyEquatableArmor: Armor {
    init(_ armor: Armor) {
        self.armor = armor
    }
    
    var attack: Int {
        return armor.attack
    }
    
    var defence: Int {
        return armor.defence
    }
    
    private let armor: Armor
}

extension AnyEquatableArmor: Equatable {
    static func ==(lhs: AnyEquatableArmor, rhs: AnyEquatableArmor) -> Bool {
        return lhs.armor.isEqualTo(rhs.armor)
    }
}

struct NoArmor: Armor {
    var attack: Int = 0
    var defence: Int = 0
}

struct LightArmor: Armor {
    var attack: Int = 0
    var defence: Int = 2
}

struct MediumArmor: Armor {
    var attack: Int = 1
    var defence: Int = 3
}

struct HeavyArmor: Armor {
    var attack: Int = 2
    var defence: Int = 4
}
