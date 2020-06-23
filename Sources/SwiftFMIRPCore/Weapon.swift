protocol Weapon {
    var attack: Int {get}
    var defence: Int {get}
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
