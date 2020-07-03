import Foundation

class DefaultPlayer: Player {
    var name: String = "Default Player"
    var hero: Hero = DefaultHero()
    var isAlive: Bool  = true
    var positionRowCol: CGPoint = CGPoint(x: 0, y: 0)
}

struct DefaultPlayerGenerator: PlayerGenerator {
    var heroGenerator: HeroGenerator
    init(heroGenerator: HeroGenerator) {
        self.heroGenerator = heroGenerator
    }
    
    func generatePlayer(name: String) -> Player {
        let player = DefaultPlayer()
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
    var tileTypes: [MapTile] = [DefaultMapTile(type: .empty), DefaultMapTile(type: .chest), DefaultMapTile(type: .rock),
                                DefaultMapTile(type: .wall), DefaultMapTile(type: .teleport)]

    func generate(players: [Player]) -> Map {
        var rowsCount: Int = 0
        var colsCount: Int = 0
        var map: Map = DefaultMap(players: players) 

        if players.count == 2 {
            rowsCount = 9 
            colsCount = 10
        } else if players.count == 3 {
            rowsCount = 9 // should be corrected
            colsCount = 10 // should be corrected
        } else if players.count == 4 {
            rowsCount = 9 // should be corrected
            colsCount = 10 // should be corrected
        }

        var player1IsSet: Bool = false
        var player2IsSet: Bool = false 
        var player3IsSet: Bool = false 
        var player4IsSet: Bool = false 
        for i in 1...players.count {
            if players[i-1].name == "Player #1" && player1IsSet == false{
                map.maze[Int.random(in: 0 ... rowsCount)][Int.random(in: 0 ... colsCount)].type = .player1
                player1IsSet = true
            } else if players[i-1].name == "Player #2" && player2IsSet == false {
                map.maze[Int.random(in: 0 ... rowsCount)][Int.random(in: 0 ... colsCount)].type = .player2
                player2IsSet = true
            } else if players[i-1].name == "Player #3" && player3IsSet == false {
                map.maze[Int.random(in: 0 ... rowsCount)][Int.random(in: 0 ... colsCount)].type = .player3
                player3IsSet = true
            } else if players[i-1].name == "Player #4" && player4IsSet == false {
                map.maze[Int.random(in: 0 ... rowsCount)][Int.random(in: 0 ... colsCount)].type = .player4
                player4IsSet = true
            }
        }

        for rows in 0...rowsCount {
            for cols in 0...colsCount {
                if map.maze[rows][cols].type != .player1 && map.maze[rows][cols].type != .player2 &&
                map.maze[rows][cols].type != .player3 && map.maze[rows][cols].type != .player4 {
                    map.maze[rows][cols] = tileTypes.randomElement()!
                }
            }  
        }

        return map
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
        var size_x: Int, size_y: Int
        if players.count == 2 {
            size_x = 10
            size_y = 10
        } else if players.count == 3 {
            size_x = 13
            size_y = 13
        } else if players.count == 4 {
            size_x = 15
            size_y = 15
        } else {
            size_x = 0
            size_y = 0
            print("Wrong number of players!")
        }
        self.maze = []
        for i in 0...size_x {
            self.maze.append([])
            for _ in 0...size_y {
                self.maze[i].append(DefaultMapTile(type: .empty))
            }
        }
        self.players = players
    }

    var players: [Player]
    var maze: [[MapTile]]

    func availableMoves(player: Player) -> [PlayerMove] {
        var availableMoves: [PlayerMove] = [PlayerMove]()
        // Can it go up?
        if Int(player.positionRowCol.x) - 1 >= 0 && maze[Int(player.positionRowCol.x) - 1][Int(player.positionRowCol.y)].type != .wall {
            availableMoves.append(StandartPlayerMove(direction: .up))
        } 
        // Can it go down?
        if Int(player.positionRowCol.x) + 1 < maze.count && maze[Int(player.positionRowCol.x) + 1][Int(player.positionRowCol.y)].type != .wall {
            availableMoves.append(StandartPlayerMove(direction: .down))
        }
        // Can it go left?
        if Int(player.positionRowCol.y) - 1 >= 0 && maze[Int(player.positionRowCol.x)][Int(player.positionRowCol.y) - 1].type != .wall {
            availableMoves.append(StandartPlayerMove(direction: .left))
        } 
        // Can it go right?
        if Int(player.positionRowCol.y) + 1 < maze[0].count && maze[Int(player.positionRowCol.x)][Int(player.positionRowCol.y) + 1].type != .wall {
            availableMoves.append(StandartPlayerMove(direction: .right))
        }

        return availableMoves
    }

    func move(player: inout Player, move: PlayerMove) {
        // ТОДО: редуцирай енергията на героя на играча с 1
        player.hero.energy = player.hero.energy - 1

        // move
        // go up
        if move.direction == .up {
            player.positionRowCol.x = player.positionRowCol.x - 1
        }
        // go down
        if move.direction == .down {
            player.positionRowCol.x = player.positionRowCol.x + 1
        }
        // go left
        if move.direction == .left {
            player.positionRowCol.y = player.positionRowCol.y - 1
        }
        // go right 
        if move.direction == .right {
            player.positionRowCol.y = player.positionRowCol.y + 1
        }
    }
    
}

class DefaultFightGenerator : FightGenerator {
    //TBD
}

class DefaultEquipmentGenerator : EquipmentGenerator {
    var allArmors: [Armor]

    var allWeapons: [Weapon]
    
    init() {
       allArmors = [NoArmor(), LightArmor(), MediumArmor(), HeavyArmor()]
       allWeapons = [WoodenStick(), Axe(), Bow(), Sword()]
    }

    func randomArmor() -> Armor {
        return self.allArmors.randomElement()!
    }

    func randomWeapon() -> Weapon {
        return self.allWeapons.randomElement()!
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
        print("\n")
        print("📦 - Treasure Chest: contains weapon or armor")
        print("🗿 - Rock: gives bonus attack 1")
        print("💿 - Teleport: teleports you from one teleport to another")
        print("🧱 - Wall: players cannot move to a wall tile")
        print("1️⃣  - Player 1")
        print("2️⃣  - Player 2")
        print("3️⃣  - Player 3")
        print("4️⃣  - Player 4")
    }
}
