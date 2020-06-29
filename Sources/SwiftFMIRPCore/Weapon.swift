protocol Weapon {
    var attack: Int {get set}
    var defence: Int {get}
}

func ==(lhs: Weapon, rhs: Weapon) -> Bool {
    guard type(of: lhs) == type(of: rhs) else { return false }
    return lhs.attack == rhs.attack && lhs.defence == rhs.defence
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
