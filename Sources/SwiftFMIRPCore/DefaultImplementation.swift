import Foundation

extension Collection {
    func choose(_ n: Int) -> ArraySlice<Element> { shuffled().prefix(n) }
}

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
    struct Corrdinates: Equatable{
        let x: Int
        let y: Int
    }

    func generateTiles(map: inout Map, positions: inout [Corrdinates], count: Int, type: MapTileType) {
        let chosenPositions = positions.choose(count)
        for position in chosenPositions {
            map.maze[position.x][position.y] = DefaultMapTile(type: type)
            if let index = positions.firstIndex(of: position) {
                positions.remove(at: index)
            }
        }
    }

    func generate(players: [Player]) -> Map {
        var map: Map = DefaultMap(players: players) 

        var positions: [Corrdinates] = []
        for i in 0...map.maze.count - 1{
            for j in 0...map.maze[i].count - 1{
                positions.append(Corrdinates(x: i, y: j))
            }
        }
        generateTiles(map: &map, positions: &positions, count: 5, type: .teleport)
        generateTiles(map: &map, positions: &positions, count: 3, type: .rock)
        generateTiles(map: &map, positions: &positions, count: 2, type: .chest)
        generateTiles(map: &map, positions: &positions, count: 20, type: .wall)
        generateTiles(map: &map, positions: &positions, count: 1, type: .player1)
        generateTiles(map: &map, positions: &positions, count: 1, type: .player2)

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
        var sizeX: Int, sizeY: Int
        if players.count == 2 {
            sizeX = 10
            sizeY = 10
        } else if players.count == 3 {
            sizeX = 13
            sizeY = 13
        } else if players.count == 4 {
            sizeX = 15
            sizeY = 15
        } else {
            sizeX = 0
            sizeY = 0
            print("Wrong number of players!")
        }
        self.maze = []
        for i in 0...sizeX - 1 {
            self.maze.append([])
            for _ in 0...sizeY - 1 {
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
