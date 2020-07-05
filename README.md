# SwiftFMIRPCore
This project defines the main building blocks for a RolePlayingGame. It conatians a stub implementation to show that a game can be build. The project is separaetd into several modules and each module can be re-defined.

# Requirements

### Ubuntu
In order for the project to run you need to install libgd-dev:
```bash
sudo apt-get install libgd-dev
```
### Windows 

In order for the project to run you need to install libgd-dev:
```bash
sudo apt-get install libgd-dev
```

For Windows see [here](https://www.howtogeek.com/261575/how-to-run-graphical-linux-desktop-applications-from-windows-10s-bash-shell/).

**Important:**
You’ll have to run this command each time you reopen Bash and want to run a graphical application.
```bash
export DISPLAY=:0
```

**Note:** You should close the app showing the map and legend before you can make a move again.

## Промени

* **enum MapTileType**
    * добавяне на **player1**, **player2**, **player3**, **player4**, за да може да се визуализира къде се намират играчите на самата карта

* **protocol Player**
    * добавяне на **positionRowCol**, за да можем да пазим и достъпваме позицията на играча
    
    * промяна на **player** параметър в move на **inout**, за да може да бъде неконстантен, тъй като искаме да сменим позицията му

* **protocol Map**
    * промяна на променлива **maze** от {get} на **{get set}**, за да можем да извършим изтриването на икона на играч, избрал seppuku

* **Game.swift**
    * добавяне на команда **exit** за излизане от играта
    * промяна на **map** от let на **var**, за да можем да извършим изтриването на икона на играч, избрал seppuku

* **protocol Weapon**
    * промяна на променливата **attack** от {get} на **{get set}**, за да можем да извършим добавяне на бонус атака, идващ от rock
    
## TODO
 
* do the fight module

## Final Project (Draft)
Всеки стдудент, работещ над този финален проект, трябва да реализира поне два от модулите, описани по-долу, в собствено репозитори, изпозлвайки Swift и знанията от курса.

Трябва да спазите протоколите от основното репо, предоставено от нас, за да е възможно "сглобяването" на различни модули в една работеща версия на игра.

## Да се напише модул за ролева игра:


1. Модул за генериране на карта
2. Модул за герои
3. Модул за битки
4. Модул за въоражаване 
5. Модул за движение по картата и визуализация

## Идеята на играта.
Играта може да се играе от максимум 4 играча на карта. Картата може да съдържа различни видове полета. 
Тя е 2D, но е възможно да има телепорти, което я прави непланарна. Т.е. един играч може да се премества 
до всички граничещи полета на дадено. Ако то е специално, тогава може да го ползва/активира, което го премества
до "съседното" съответно поле на картата.
Всеки играч се движи по картата и целта му е да отстрани останалите играчи, т.е. да ги пребори в битка и да оцелее, ако се изправи в битка с герои от картата. 
Всеки играч може да прави един ход, в който той има определен брои точки енергия, която да изразходва за движение по картата или влизане в битка. Всяка битка отнема точно една точка енергия. Енергията на всеки ход се генерира от модула за движение по картата. 
Всеки герой започва със стандартно въоражение, т.е. едно оръжие характерно за него. В процеса на движение по картата може да събира нови оръжия или броня (armor). Оръжията и бронята трябва да допринасят за всяка битка.
Всяка битка се провежда по ролеви модел, чрез редуване на противниците. Първи е атакуващият герой, който е заплатил една точка енергия. Нападнатият герой не е нужно да заплаща енергия.
Картата има възможност да се визуализира като 2D матрица с легенда (обяснение кое поле какво прави)
Преди всеки ход, потребителят получава възможност за движение във всички възможни посоки 
* на горе
* на долу
* на ляво
* на дясно
* (влизане в битка, ако има друг герой на съответното поле)
Героят не може да напуска пределите на картата. При невъзможен ход не се намалява енергията.

## Основна програма (псевдо код)

1. Избор на брой играчи. Минимум 2 броя. Максимум 4 броя.
1. Генериране на карта с определени брой размери на базата на броя играчи.
1. Докато има повече от един оцелял играч, изпълнявай ходове.
    * определи енергията за текущия играч
    * текущият играч се мести по картата докато има енергия
    * потребителят контролира това като му се предоставя възможност за действие
    * ако се въведе системна команда като `map`, се визуализра картата
1. Следващият играч става текущ.

## Имплементация 

Повече информация може да намерите [тук] (https://github.com/SwiftFMI/rpgcore).
