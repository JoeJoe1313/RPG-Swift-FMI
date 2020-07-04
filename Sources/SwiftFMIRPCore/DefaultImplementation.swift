import Foundation
import SwiftGD

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
    struct Coordinates: Equatable {
        let x: Int
        let y: Int
    }

    func isValidPosition(map: Map, position: Coordinates) -> Bool {
        if (position.x < 0 || position.y < 0) {
            return false
        }
        if (position.x >= map.maze.count || position.y >= map.maze[position.x].count) {
            return false
        }
        if map.maze[position.x][position.y].type == .wall {
            return false
        }
        return true
    }

    func generatePossibleMoves(position: Coordinates) -> [Coordinates] {
        let moves = [(-1, 0), (1, 0), (0, 1), (0, -1)]
        var result: [Coordinates] = []
        for move in moves {
            result.append(Coordinates(x: position.x + move.0, y: position.y + move.1))
        }
        return result
    }

    func validateMap(map: Map) -> Bool {
        if map.maze.count == 0 {
            return false
        }
        var q: [Coordinates] = []
        var count = 0
        for i in 0..<map.maze.count {
            for j in 0..<map.maze[i].count {
                let t = map.maze[i][j].type
                if (t == .player1 || t == .player2 || t == .player3 || t == .player4) {
                    count += 1
                    if q.count == 0 {
                        q.append(Coordinates(x: i, y: j))
                    }
                }
            }
        }
        if q.isEmpty {
            return false
        }
        var found = q.count
        var visited = Array(repeating: Array(repeating: false, count: map.maze.count), count: map.maze[0].count)
        for position in q {
            visited[position.x][position.y] = true
        }
        while !q.isEmpty {
            let current = q.removeFirst()
            for new_position in self.generatePossibleMoves(position: current) {
                if (self.isValidPosition(map: map, position: new_position) && !visited[new_position.x][new_position.y]) {
                    q.append(new_position)
                    visited[new_position.x][new_position.y] = true
                    let t = map.maze[new_position.x][new_position.y].type
                    if (t == .player1 || t == .player2 || t == .player3 || t == .player4) {
                        found += 1
                    }
                }
            }
        }

        return found == count
    }

    func generateTiles(map: inout Map, positions: inout [Coordinates], count: Int, type: MapTileType) {
        let chosenPositions = positions.choose(count)
        for position in chosenPositions {
            map.maze[position.x][position.y] = DefaultMapTile(type: type)
            if let index = positions.firstIndex(of: position) {
                positions.remove(at: index)
            }
        }
    }

    func generateHelper(players: [Player]) -> Map {
        var map: Map = DefaultMap(players: players) 

        var positions: [Coordinates] = []
        for i in 0..<map.maze.count {
            for j in 0..<map.maze[i].count {
                positions.append(Coordinates(x: i, y: j))
            }
        }
        if players.count == 2 {
            generateTiles(map: &map, positions: &positions, count: 3, type: .teleport)
            generateTiles(map: &map, positions: &positions, count: 3, type: .rock)
            generateTiles(map: &map, positions: &positions, count: 5, type: .chest)
            generateTiles(map: &map, positions: &positions, count: 30, type: .wall)
            generateTiles(map: &map, positions: &positions, count: 1, type: .player1)
            generateTiles(map: &map, positions: &positions, count: 1, type: .player2)
        } else if players.count == 3 {
            generateTiles(map: &map, positions: &positions, count: 5, type: .teleport)
            generateTiles(map: &map, positions: &positions, count: 5, type: .rock)
            generateTiles(map: &map, positions: &positions, count: 10, type: .chest)
            generateTiles(map: &map, positions: &positions, count: 40, type: .wall)
            generateTiles(map: &map, positions: &positions, count: 1, type: .player1)
            generateTiles(map: &map, positions: &positions, count: 1, type: .player2)
            generateTiles(map: &map, positions: &positions, count: 1, type: .player3)
        } else if players.count == 4 {
            generateTiles(map: &map, positions: &positions, count: 8, type: .teleport)
            generateTiles(map: &map, positions: &positions, count: 8, type: .rock)
            generateTiles(map: &map, positions: &positions, count: 15, type: .chest)
            generateTiles(map: &map, positions: &positions, count: 50, type: .wall)
            generateTiles(map: &map, positions: &positions, count: 1, type: .player1)
            generateTiles(map: &map, positions: &positions, count: 1, type: .player2)
            generateTiles(map: &map, positions: &positions, count: 1, type: .player3)
            generateTiles(map: &map, positions: &positions, count: 1, type: .player4)
        }
        return map
    }

    func generate(players: [Player]) -> Map {
        var map: Map = self.generateHelper(players: players)
        while !self.validateMap(map: map) {
            print("Bad map. Trying again...")
            map = self.generateHelper(players: players)
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
    func pasteImageOver(baseImage: Image, image: Image, start: Point) {
        let width = image.size.width - 1, height = image.size.width - 1
        for x in 0 ... height {
            for y in 0 ... width {
                baseImage.set(pixel: Point(x: start.x + x, y: start.y + y), to: image.get(pixel: Point(x: x, y: y)))
            }
        }
    }

    func drawImageFromLocation(baseImage: Image, location: String, position: Point) {
        let tileImage = Image(url: URL(fileURLWithPath: location))!
        let tileImageResized = tileImage.resizedTo(width: 49, height: 49, applySmoothing: true)!
        self.pasteImageOver(baseImage: baseImage, image: tileImageResized, start: Point(x: position.x, y: position.y))
    }

    func render(map: Map) {
        renderMapLegend()
        let bash: CommandExecuting = Bash()
        var dirList = #file.components(separatedBy: "/")
        dirList.removeLast(3)
        let baseDir = dirList.joined(separator: "/") + "/Images"
        let _ = bash.run(commandName: "rm", arguments: ["-f", "\(baseDir)/map.png"])
        let currentDirectory = URL(fileURLWithPath: baseDir)
        let destination = currentDirectory.appendingPathComponent("/map.png")
        let sizeX = map.maze[0].count, sizeY = map.maze.count
        if let image = Image(width: sizeX * 50 + 1, height: sizeY * 50 + 1) {
            image.fillRectangle(
                topLeft: Point(x: 0, y: 0),
                bottomRight: Point(x: sizeX * 50 + 1, y: sizeY * 50 + 1),
                color: Color(red: 0.73, green: 0.72, blue: 0.42, alpha: 1)
            )
            for i in stride(from: 0, to: sizeX * 50 + 1, by: 50) {
                image.drawLine(from: Point(x: i, y: 0), to: Point(x: i, y: sizeY * 50), color: Color.white)
            }

            for i in stride(from: 0, to: sizeY * 50 + 1, by: 50) {
                image.drawLine(from: Point(x: 0, y: i), to: Point(x: sizeX * 50, y: i), color: Color.white)
            }

            for i in 0..<map.maze.count {
                for j in 0..<map.maze[i].count {
                    let position = Point(x: j * 50 + 1, y: i * 50 + 1)
                    if map.maze[i][j].type == .player1 {
                        drawImageFromLocation(baseImage: image, location: "\(baseDir)/1.png", position: position)
                    }
                    if map.maze[i][j].type == .player2 {
                        drawImageFromLocation(baseImage: image, location: "\(baseDir)/2.png", position: position)
                    }
                    if map.maze[i][j].type == .player3 {
                        drawImageFromLocation(baseImage: image, location: "\(baseDir)/3.png", position: position)
                    }
                    if map.maze[i][j].type == .player4 {
                        drawImageFromLocation(baseImage: image, location: "\(baseDir)/4.png", position: position)
                    }
                    if map.maze[i][j].type == .rock {
                        drawImageFromLocation(baseImage: image, location: "\(baseDir)/rock.png", position: position)
                    }
                    if map.maze[i][j].type == .wall {
                        drawImageFromLocation(baseImage: image, location: "\(baseDir)/wall.png", position: position)
                    }
                    if map.maze[i][j].type == .chest {
                        drawImageFromLocation(baseImage: image, location: "\(baseDir)/chest.png", position: position)
                    }
                    if map.maze[i][j].type == .teleport {
                        drawImageFromLocation(baseImage: image, location: "\(baseDir)/teleport.png", position: position)
                    }
                }
            } 
            
            var created = image.write(to: destination)
            while !created {
                created = image.write(to: destination)
            }
            let _ = bash.run(commandName: "xdg-open", arguments: ["\(baseDir)/map.png"])
        }
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
