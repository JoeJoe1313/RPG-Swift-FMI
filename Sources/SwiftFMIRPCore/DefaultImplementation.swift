class DefaultPlayer: Player {
    var name: String = "Default Player"
    var hero: Hero = DefaultHero()
    var isAlive: Bool  = true
}

struct DefaultPlayerGenerator: PlayerGenerator {
    var heroGenerator: HeroGenerator
    init(heroGenerator: HeroGenerator) {
        self.heroGenerator = heroGenerator
    }
    
    func generatePlayer(name: String) -> Player {
        var player = DefaultPlayer()
        player.name = name
        player.hero = heroGenerator.getRandom()
        return player
    }
}

struct DefaultHeroGenerator: HeroGenerator {
    let heroes: [Hero] = [Elf(), Orc(), Human(), Goblin()]

    func getRandom() -> Hero {
        return heroes.randomElement()!
    }
}

struct DefaultMapGenerator : MapGenerator {
    func generate(players: [Player]) -> Map {
        return DefaultMap(players: players)
    }
}

class DefaultMapTile: MapTile {
    var type: MapTileType
    var state: String
    
    init(type: MapTileType) {
        self.type = type
        state = ""
    }
}

class DefaultMap : Map {
    required init(players: [Player]) {
        if players.count == 2 {
            self.maze = [
                [DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .player2)],
        
                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty),DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty)],
        
                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty),DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],
        
                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty),DefaultMapTile(type: .rock), DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],
        
                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .teleport),DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .chest), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],
        
                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .chest), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .teleport), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],

                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall), DefaultMapTile(type: .rock), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],

                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],

                [DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],

                [DefaultMapTile(type: .player1), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall)]
            ]
        } else if players.count == 3 {
            self.maze = [
                [DefaultMapTile(type: .player3), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .player2)],
        
                [DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty),DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty)],
        
                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty),DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],
        
                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty),DefaultMapTile(type: .rock), DefaultMapTile(type: .wall), DefaultMapTile(type: .teleport), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .teleport), DefaultMapTile(type: .wall), DefaultMapTile(type: .rock), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],
        
                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty),DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],
        
                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .chest), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .chest), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],

                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],

                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .chest), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],

                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],

                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .rock), DefaultMapTile(type: .wall), DefaultMapTile(type: .teleport), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],

                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],

                [DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],

                [DefaultMapTile(type: .player1), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall)]
            ]
        } else if players.count == 4 {
            self.maze = [
                [DefaultMapTile(type: .player3), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .player2)],

                [DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty)],

                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],

                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],

                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .rock), DefaultMapTile(type: .wall), DefaultMapTile(type: .teleport), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .teleport), DefaultMapTile(type: .wall), DefaultMapTile(type: .rock), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],

                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],

                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .chest), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .chest), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],

                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],

                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],

                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .chest), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .chest), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],

                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],

                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .rock), DefaultMapTile(type: .wall), DefaultMapTile(type: .teleport), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .teleport), DefaultMapTile(type: .wall), DefaultMapTile(type: .rock), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],

                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],

                [DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall)],

                [DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty), DefaultMapTile(type: .empty)],

                [DefaultMapTile(type: .player1), DefaultMapTile(type: .empty), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .wall), DefaultMapTile(type: .empty), DefaultMapTile(type: .player4)]
            ]
        } else {
            self.maze = []
            print("Wrong number of players!")
        }
        self.players = players
    }

    var players: [Player]
    var maze: [[MapTile]]

    func availableMoves(player: Player) -> [PlayerMove] {
        return []
    }

    func move(player: Player, move: PlayerMove) {
       //ТОДО: редуцирай енергията на героя на играча с 1
    }
    
}

class DefaultFightGenerator : FightGenerator {
    //TBD
}

class DefaultEquipmentGenerator : EquipmentGenerator {
    var allArmors: [Armor]
    
    var allWeapons: [Weapon]
    
    init() {
        allArmors = [NoArmor()]
        allWeapons = [WoodenStick()]
    }
}

class DefaultMapRenderer: MapRenderer {
    func render(map: Map) {
        for row in map.maze {
            self.renderMapRow(row: row)
        }
        
        renderMapLegend()
    }
    
    private func renderMapRow(row: [MapTile]) {
        var r = ""
        for tile in row {
            switch tile.type {
            case .chest:
                r += "📦"
            case .rock:
                r += "🗿"
            case .teleport:
                r += "💿"
            case .empty:
                r += "  "
            case .wall:
                r += "🧱"
            case .clash:
                r += "💥"
            case .player1:
                r += "1️⃣ "
            case .player2:
                r += "2️⃣ "
            case .player3:
                r += "3️⃣ "
            case .player4:
                r += "4️⃣ "
            default:
                //empty
                r += " "
            }
        }
        
        print("\(r)")
    }
    
    private func renderMapLegend() {
        print("📦 - Treasure Chest: contains weapon or armor")
        print("🗿 - Rock: opens the chest")
        print("💿 - Teleport: teleports you from one teleport to another")
        print("🧱 - Wall: players cannot move to a wall tile")
        print("💥 - Clash: shows when two players are on the same tile")
        print("1️⃣ - Player 1")
        print("2️⃣ - Player 2")
        print("3️⃣ - Player 3")
        print("4️⃣ - Player 4")
    }
}
