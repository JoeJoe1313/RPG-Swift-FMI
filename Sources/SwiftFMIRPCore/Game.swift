import Foundation

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
           //this is just a try!!!
           //These are the fixed base points for the players ate the beginning of every game depending on the map
           if totalPlayers == 2 {
               if players[i-1].name == "Player #1" {
                   players[i-1].positionRowCol = CGPoint(x: 9, y: 0)
               } else if players[i-1].name == "Player #2" {
                   players[i-1].positionRowCol = CGPoint(x: 0, y: 10)
               }
            } else if totalPlayers == 3 {
               if players[i-1].name == "Player #1" {
                   players[i-1].positionRowCol = CGPoint(x: 12, y: 0)
               } else if players[i-1].name == "Player #2" {
                   players[i-1].positionRowCol = CGPoint(x: 0, y: 13)
               } else if players[i-1].name == "Player #3" {
                   players[i-1].positionRowCol = CGPoint(x: 0, y: 0)
               }
            } else if totalPlayers == 4 {
                if players[i-1].name == "Player #1" {
                   players[i-1].positionRowCol = CGPoint(x: 15, y: 0)
               } else if players[i-1].name == "Player #2" {
                   players[i-1].positionRowCol = CGPoint(x: 0, y: 16)
               } else if players[i-1].name == "Player #3" {
                   players[i-1].positionRowCol = CGPoint(x: 0, y: 0)
               } else if players[i-1].name == "Player #4" {
                   players[i-1].positionRowCol = CGPoint(x: 15, y: 16)
               }
            }
            print("\(players[i-1].name) is at start position (\(Int(players[i-1].positionRowCol.x)), \(Int(players[i-1].positionRowCol.y)))")
            print("\(players[i-1].name) is \(players[i-1].hero.race) with \(players[i-1].hero.energy) energy, \(players[i-1].hero.lifePoitns) life points, \(players[i-1].hero.weapon!) and \(players[i-1].hero.armor!)")
       }
       
       
       

        var map = mapGenerator.generate(players: players)
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
                            map.maze[Int(currentPlayer.positionRowCol.x)][Int(currentPlayer.positionRowCol.y)].type = .empty

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

                            // change the position of the player icon
                            if currentPlayer.name == "Player #1" {
                                map.maze[Int(currentPlayer.positionRowCol.x)][Int(currentPlayer.positionRowCol.y)].type = .player1
                            } else if currentPlayer.name == "Player #2" {
                                map.maze[Int(currentPlayer.positionRowCol.x)][Int(currentPlayer.positionRowCol.y)].type = .player2
                            } else if currentPlayer.name == "Player #3" {
                                map.maze[Int(currentPlayer.positionRowCol.x)][Int(currentPlayer.positionRowCol.y)].type = .player3
                            } else if currentPlayer.name == "Player #4" {
                                map.maze[Int(currentPlayer.positionRowCol.x)][Int(currentPlayer.positionRowCol.y)].type = .player4
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
