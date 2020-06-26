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
           print("\(players[i-1].name) is \(players[i-1].hero.race) with \(players[i-1].hero.energy) energy, \(players[i-1].hero.lifePoitns) life points, \(players[i-1].hero.weapon!) and \(players[i-1].hero.armor!)")
       }
       
       
       

        let map = mapGenerator.generate(players: players)
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
                    let availableMoves = map.availableMoves(player: currentPlayer) //here
                    var allCommands = ["move","finish", "map", "nuke"]
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
                            map.move(player: currentPlayer, move: move)
                            
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
                                currentPlayer.isAlive = false
                                playerMoveIsNotFinished = false
                                print("Your turn ended.")
                            case "nuke":
                                for i in 1...players.count {
                                    players[i-1].isAlive = false
                                }
                                playerMoveIsNotFinished = false
                            case "move":
                                var playerMoveIsNotCorrect = true
                                repeat {
                                    print("Please choose one of the following commands: ")
                                    let availableMoveMoves = map.availableMoves(player: currentPlayer) //here
                                    var allMoveCommands = ["up","down", "left", "right"]
                                    availableMoveMoves.forEach { (move) in
                                        allMoveCommands.append(move.friendlyCommandName)
                                    }
                                    print("\(allMoveCommands)")
                                    if let moveCommand = readLine(as: String.self) {
                                        //TODO: провери дали не е от някои от възможните други действия
                                        //TODO: ако е от тях изпълни действието
                                        if let moveMove = availableMoveMoves.first(where: { (moveMove) -> Bool in
                                            moveMove.friendlyCommandName == command
                                        }) {
                                        //разпозната команда
                                        map.move(player: currentPlayer, move: moveMove)
                            
                                        } else {
                                            //иначе, провери за
                                            //специални команди
                                            switch moveCommand {
                                            case "up":
                                                print("UP")
                                                playerMoveIsNotCorrect = false
                                            case "down":
                                                print("DOWN")
                                                playerMoveIsNotCorrect = false
                                            case "left":
                                                print("LEFT")
                                                playerMoveIsNotCorrect = false
                                            case "right":
                                                print("RIGHT")
                                                playerMoveIsNotCorrect = false
                                            default:
                                                print("Unknown command!")
                                                playerMoveIsNotCorrect = true
                                            }
                                        }
                                    }
                                    else {
                                        print("Invalid input! Please try again.")
                                    }
                                } while playerMoveIsNotCorrect
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
