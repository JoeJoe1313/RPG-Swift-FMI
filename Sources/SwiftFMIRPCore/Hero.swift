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
    var armor: Armor? = HeavyArmor()
}
