protocol Hero {
    var race: String {get}

    var energy: Int {get set}
    var lifePoitns: Int {get set}

    var weapon: Weapon? {get set}
    var armor: Armor? {get set}
}

protocol HeroGenerator {
    func getRandom() -> Hero
}

protocol Fight {
    var attacker: Hero {get set}
    var host: Hero {get set}
    
    func start(finish:(Fight) -> ())
    var winner: Hero {get set}
}

protocol FightGenerator {
    
}

protocol EquipmentGenerator {
    var allArmors: [Armor] {get}
    var allWeapons: [Weapon] {get}
}

struct DefaultHero: Hero {
   var race: String  = "Random Race"

    var energy: Int = 5
    var lifePoitns: Int = 7

    var weapon: Weapon?  = nil
    var armor: Armor? = nil

}

struct Elf: Hero {
    var race: String  = "Elf"

    var energy: Int = 8
    var lifePoitns: Int = 10

    var weapon: Weapon?  = Bow()
    var armor: Armor? = LightArmor()
}

struct Orc: Hero {
    var race: String = "Orc"

    var energy: Int = 8
    var lifePoitns: Int = 10

    var weapon: Weapon? = Axe()
    var armor: Armor? = HeavyArmor()
}

struct Human: Hero {
    var race: String = "Human"

    var energy: Int = 8
    var lifePoitns: Int = 10

    var weapon: Weapon? = Sword()
    var armor: Armor? = MediumArmor()
}

struct Goblin: Hero {
    var race: String = "Goblin"

    var energy: Int = 8
    var lifePoitns: Int = 10

    var weapon: Weapon? = WoodenStick()
    var armor: Armor? = NoArmor()
}
