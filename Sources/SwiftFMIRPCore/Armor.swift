protocol Armor {
    var attack: Int {get}
    var defence: Int {get}
}

struct NoArmor: Armor {
    var attack: Int = 0
    var defence: Int = 0
}

struct HeavyArmour: Armor {
    var attack: Int = 1
    var defence: Int = 4
}