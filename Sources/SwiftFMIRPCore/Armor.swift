protocol Armor {
    var attack: Int {get}
    var defence: Int {get}
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
