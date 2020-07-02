import Foundation

var maxEnergy: Int = 5

func readLine<T: LosslessStringConvertible>(as type: T.Type) -> T? {
  return readLine().flatMap(type.init(_:))
}

class Game {
    var mapGenerator: MapGenerator
    var playerGenerator: PlayerGenerator
    var mapRenderer: MapRenderer

    init(mapGenerator: MapGenerator, playerGenerator: PlayerGenerator, mapRenderer: MapRenderer) {
        self.mapGenerator = mapGenerator
        self.playerGenerator = playerGenerator
        self.mapRenderer = mapRenderer
    }
    
    //implement main logic
    func run() {
        print("Starting the RPG game...")
        var players:[Player] = []
        var totalPlayers = 0
        repeat {
            print("Please choose the number of players (2 - 4): ")
            if let number = readLine(as: Int.self) {
                totalPlayers = number
                if totalPlayers < 2 || totalPlayers > 4 {
                    print("Invalid number of players! Please try again.")
                }
            } else {
              print("Invalid input! Please try again.")  
            }
        } while totalPlayers < 2 || totalPlayers > 4

        // 1. Избор на брой играчи. Минимум 2 броя.
        
        print("You chose \(totalPlayers) players. The system will select your heroes.")
        for i in 1...totalPlayers {
            print("Generating player...")
            players.append(playerGenerator.generatePlayer(name: "Player #\(i)")) 
            print("\(players[i-1].name) is \(players[i-1].hero.race) with \(players[i-1].hero.energy) energy, \(players[i-1].hero.lifePoitns) life points, \(players[i-1].hero.weapon!) and \(players[i-1].hero.armor!)\n")
        }
        
        var map = mapGenerator.generate(players: players)

        for row in 0..<map.maze.count {
            for col in 0..<map.maze[0].count {
                if map.maze[row][col].type == .player1 {
                    players[0].positionRowCol = CGPoint(x: row,y: col)
                } else if map.maze[row][col].type == .player2 {
                    players[1].positionRowCol = CGPoint(x: row, y: col)
                } else if map.maze[row][col].type == .player3 {
                    players[2].positionRowCol = CGPoint(x: row, y: col)
                } else if map.maze[row][col].type == .player4 {
                    players[3].positionRowCol = CGPoint(x: row, y: col)
                }
            }
        }

        // 1. Избор на брой играчи. Минимум 2 броя.
        // 1. Генериране на карта с определени брой размери на базата на броя играчи.
        // 1. Докато има повече от един оцелял играч, изпълнявай ходове.
        //     * определи енергията за текущия играч
        //     * Текущия играч се мести по картата докато има енергия. 
        //     * Потребителя контролира това като му се предоставя възможност за действие.
        //     * ако се въведе системна команда като `map` се визуализра картата
        // 1. Следващия играч става текущ.
        
        var currentPlayerIndex = 0
        
        while activePlayers(allPlayers: players).count > 1  {
            if var currentPlayer:Player = players[currentPlayerIndex] as? Player, currentPlayer.isAlive {
                let playerNumber = currentPlayerIndex + 1
                print("It is player №\(playerNumber) turn - \(currentPlayer.name)")
                
                ///команди от играча
                var playerMoveIsNotFinished = true
                currentPlayer.hero.energy = maxEnergy
                repeat {
                    print("Please choose one of the following commands: ")
                    let availableMoves = map.availableMoves(player: currentPlayer)
                    var allCommands = ["finish", "map", "exit"]
                    if currentPlayer.isAlive {
                        allCommands.append("seppuku")
                        availableMoves.forEach { (move) in
                            allCommands.append(move.friendlyCommandName)
                        }
                    }
                    print("\(allCommands)")
                    
                    if let command = readLine(as: String.self) {
                        //TODO: провери дали не е от някои от възможните други действия
                        //TODO: ако е от тях изпълни действието
                        if let move = availableMoves.first(where: { (move) -> Bool in
                            move.friendlyCommandName == command
                        }) {
                            //разпозната команда
                            // clear the current player icon from the map
                            if map.maze[Int(currentPlayer.positionRowCol.x)][Int(currentPlayer.positionRowCol.y)].type != .teleport {
                                var newTileValue: MapTileType = .empty
                                for i in 1...totalPlayers {
                                    if players[i-1].name != currentPlayer.name {
                                        if currentPlayer.positionRowCol.x == players[i-1].positionRowCol.x && 
                                        currentPlayer.positionRowCol.y == players[i-1].positionRowCol.y {        
                                            if players[i-1].name == "Player #1" {
                                                newTileValue = .player1
                                            } else if players[i-1].name == "Player #2" {
                                                newTileValue = .player2
                                            } else if players[i-1].name == "Player #3" {
                                                newTileValue = .player3
                                            } else if players[i-1].name == "Player #4" {
                                                newTileValue = .player4
                                            }
                                        }
                                    }
                                }
                                map.maze[Int(currentPlayer.positionRowCol.x)][Int(currentPlayer.positionRowCol.y)].type = newTileValue
                            } 

                            // do the move
                            map.move(player: &currentPlayer, move: move)

                            // if there is a bonus from a rock -> increase the attack of the current weapon
                            if map.maze[Int(currentPlayer.positionRowCol.x)][Int(currentPlayer.positionRowCol.y)].type == .rock{
                                currentPlayer.hero.weapon!.attack = currentPlayer.hero.weapon!.attack + 1 
                                print("Now \(currentPlayer.name) is \(currentPlayer.hero.race) with \(currentPlayer.hero.energy) energy, \(currentPlayer.hero.lifePoitns) life points, \(currentPlayer.hero.weapon!) and \(currentPlayer.hero.armor!)")
                            }

                            // if there is a teleport 
                            if map.maze[Int(currentPlayer.positionRowCol.x)][Int(currentPlayer.positionRowCol.y)].type == .teleport {
                                //TODO: teleport coordinates
                                var teleportIndex: Int = 0
                                var teleportCommands: [Int] = []
                                var teleportCoordinates: [(Int,Int)] = []
                                var theTeleportCommand: Int = 0

                                for row in 0..<map.maze.count {
                                    for col in 0..<map.maze[0].count {
                                        if map.maze[row][col].type == .teleport {
                                            teleportIndex += 1
                                            print("Teleport #\(teleportIndex) has coordinates (\(row),\(col)).")
                                            teleportCoordinates.append((row,col))
                                            teleportCommands.append(teleportIndex)
                                        }
                                    }
                                }

                                repeat {
                                    print("Which number teleport do you choose to go to?")
                                    print("Please choose the number of the teleport you want to go to (1-\(teleportIndex))")
                                    print("\(teleportCommands)")
                                    if let playerCommand = readLine(as: Int.self) {
                                        theTeleportCommand = playerCommand
                                        if theTeleportCommand < 1 || theTeleportCommand > teleportIndex {
                                            print("Invalid number of a teleport! Please try again.")
                                        } else {
                                            for i in 1...teleportIndex {
                                                if theTeleportCommand == i {
                                                    currentPlayer.positionRowCol = CGPoint(x: teleportCoordinates[i-1].0, y: teleportCoordinates[i-1].1)
                                                    print("You chose Teleport #\(i) and now \(currentPlayer.name) is at (\(Int(currentPlayer.positionRowCol.x)),\(Int(currentPlayer.positionRowCol.y)))!")
                                                }
                                            }
                                        }
                                    } else {
                                        print("Invalid input! Please try again.") 
                                    }
                                } while theTeleportCommand < 1 || theTeleportCommand > teleportIndex
                            }

                            // if there is chest 
                            if map.maze[Int(currentPlayer.positionRowCol.x)][Int(currentPlayer.positionRowCol.y)].type == .chest {
                                let allArmors: [Armor] = [NoArmor(), LightArmor(), MediumArmor(), HeavyArmor()]
                                let allWeapons: [Weapon] = [WoodenStick(), Axe(), Bow(), Sword()]

                                let armorOrWeapon: [String] = ["armor", "weapon"]
                                let randomChoice: String = armorOrWeapon.randomElement()!

                                var theCommand: String = ""
                                let allCommands: [String] = ["yes", "no"]

                                if randomChoice == "armor" {
                                    let randomArmor: Armor = allArmors.randomElement()!
                                    if currentPlayer.hero.armor! == randomArmor {
                                        print("The chest conatins the armor you already have: \(randomArmor)")
                                    } else {
                                        print("The chest conatins an armor: \(randomArmor). Do you want to replace ypur \(currentPlayer.hero.armor!)?")
                                        repeat {
                                            print("Please choose one of the following commands:")
                                            print("\(allCommands)")
                                            if let playerCommand = readLine(as: String.self) {
                                                theCommand = playerCommand
                                                switch theCommand {
                                                case "yes":
                                                    print("You changed your armor to \(randomArmor)!")
                                                    currentPlayer.hero.armor! = randomArmor
                                                case "no":
                                                    print("No change!")
                                                default: 
                                                    print("Unknown command!")
                                                }
                                            } else {
                                                print("Invalid input! Please try again.") 
                                            }
                                        } while theCommand != "yes" && theCommand != "no"
                                    }
                                }

                                if randomChoice == "weapon" {
                                    let randomWeapon: Weapon = allWeapons.randomElement()!
                                    if currentPlayer.hero.weapon! == randomWeapon {
                                        print("The chest conatins the armor you already have: \(randomWeapon)")
                                    } else {
                                        print("The chest contains a weapon: \(randomWeapon). Do you want to replace your \(currentPlayer.hero.weapon!)?")
                                        repeat {
                                            print("Please choose one of the following commands:")
                                            print("\(allCommands)")
                                            if let playerCommand = readLine(as: String.self) {
                                                theCommand = playerCommand
                                                switch theCommand {
                                                case "yes":
                                                    print("You chnaged your wepaon to \(randomWeapon)!")
                                                    currentPlayer.hero.weapon! = randomWeapon
                                                case "no":
                                                    print("No change!")
                                                default: 
                                                    print("Unknown command!")
                                                }
                                            } else {
                                                print("Invalid input! Please try again.") 
                                            }
                                        } while theCommand != "yes" && theCommand != "no"
                                    }
                                }
                                print("Now \(currentPlayer.name) is \(currentPlayer.hero.race) with \(currentPlayer.hero.energy) energy, \(currentPlayer.hero.lifePoitns) life points, \(currentPlayer.hero.weapon!) and \(currentPlayer.hero.armor!)")
                            }
                            
                            // if there is another player on the tile
                            var playersIndex: [Int] = []
                            var thePlayersCommand: Int = 0
                            var isAmongIndices: Bool = false
                            var playerYesNo: String = ""
                            let allCommands: [String] = ["yes", "no"]
                                
                            print("On this tile there are already other players!")
                            for i in 1...totalPlayers {
                                if players[i-1].name != currentPlayer.name {
                                    if currentPlayer.positionRowCol.x == players[i-1].positionRowCol.x && 
                                    currentPlayer.positionRowCol.y == players[i-1].positionRowCol.y {
                                        playersIndex.append(i)
                                        print("\(players[i-1].name) is on the tile!")
                                    }
                                }
                            }       

                            if playersIndex.isEmpty == false {
                                print("Do you want to attack someone?")
                                repeat {
                                    print("Please choose one of the following commands:")
                                    print("\(allCommands)")
                                    if let playerCommand = readLine(as: String.self) {
                                        playerYesNo = playerCommand
                                        switch playerYesNo {
                                        case "yes":
                                            // first decrease energy or move it to the fight module!
                                            currentPlayer.hero.energy -= 1

                                            print("Which player do you want to attack?")
                                            repeat {
                                                print("Please choose the player you want to attack:")
                                                print("\(playersIndex)")
                                                if let playerNewCommand = readLine(as: Int.self) {
                                                    thePlayersCommand = playerNewCommand
                                                    if playersIndex.contains(thePlayersCommand) {
                                                        isAmongIndices = true
                                                        for i in 1...totalPlayers {
                                                            if thePlayersCommand == i {
                                                                if String(players[i-1].name.last!) == "\(i)" {
                                                                    print("You chose to attack \(players[i-1].name)!")
                                                                }
                                                            }
                                                        }
                                                    } else {
                                                        isAmongIndices = false
                                                        print("Invalid choice of player! Please try again.")
                                                    }
                                                } else {
                                                    print("Invalid input! Please try again.") 
                                                }
                                            } while isAmongIndices != true
                                            //////////////////////////////////
                                            // insert the fight module here //
                                            //////////////////////////////////
                                        case "no":
                                            print("You chose not to attack!")
                                            // do nothing
                                        default: 
                                            print("Unknown command!")
                                        }
                                    } else {
                                        print("Invalid input! Please try again.") 
                                    }
                                } while playerYesNo != "yes" && playerYesNo != "no"
                            }
                            ///////////////////////////////////////////////////////////////////////////////////////////////////////
                            // what happens if the player hasn't already made a move but is on a tile with other players already //
                            ///////////////////////////////////////////////////////////////////////////////////////////////////////

                            // change the position of the player icon
                            if map.maze[Int(currentPlayer.positionRowCol.x)][Int(currentPlayer.positionRowCol.y)].type != .teleport {
                                if currentPlayer.name == "Player #1" {
                                    map.maze[Int(currentPlayer.positionRowCol.x)][Int(currentPlayer.positionRowCol.y)].type = .player1
                                } else if currentPlayer.name == "Player #2" {
                                    map.maze[Int(currentPlayer.positionRowCol.x)][Int(currentPlayer.positionRowCol.y)].type = .player2
                                } else if currentPlayer.name == "Player #3" {
                                    map.maze[Int(currentPlayer.positionRowCol.x)][Int(currentPlayer.positionRowCol.y)].type = .player3
                                } else if currentPlayer.name == "Player #4" {
                                    map.maze[Int(currentPlayer.positionRowCol.x)][Int(currentPlayer.positionRowCol.y)].type = .player4
                                }
                            }
                            
                            if currentPlayer.hero.energy == 0 {
                                print("\(currentPlayer.name) ran out of energy! The turn has finished!")
                                playerMoveIsNotFinished = false
                            }

                        } else {
                            //иначе, провери за
                            //специални команди
                            switch command {
                            case "finish":
                                playerMoveIsNotFinished = false
                                print("Your turn ended.")
                            case "map":
                                print("Printing map:")
                                mapRenderer.render(map: map)
                            case "seppuku":
                                print("Ritual suicide...")
                                map.maze[Int(currentPlayer.positionRowCol.x)][Int(currentPlayer.positionRowCol.y)].type = .empty
                                currentPlayer.isAlive = false
                                playerMoveIsNotFinished = false
                                print("Your turn ended.")
                            case "exit":
                                for i in 1...players.count {
                                    players[i-1].isAlive = false
                                }
                                playerMoveIsNotFinished = false
                            default:
                                print("Unknown command!")
                            }
                        }
                    } else {
                      print("Invalid input! Please try again.")
                    }
                } while playerMoveIsNotFinished
            }
            
            //минаваме на следващия играч
            currentPlayerIndex += 1
            currentPlayerIndex %= players.count
        }
        let winners = activePlayers(allPlayers: players)
        if winners.count > 0 {
            print("The winner is: \(winners[0].name)")
        } else {
            print("There is no winner :/. Try to play a new game.")
        }

        print("RPG game has finished.")
        
    }
    
    private func activePlayers(allPlayers: [Player]) -> [Player] {
        return allPlayers.filter { (p) -> Bool in
            p.isAlive
        }
    }
}
