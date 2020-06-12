# Final Project (Draft)
Всеки стдудент работещ над този финален проект трябва да реализира поне два от модулите описани по-долу в собствено репозитори изпозлвайки Swift и знанията от курса. 

Трябва да спазите протоколите от основното репо предоставено от нас, за да е възможно "сглобяването" на различни модули в една работеща версия на игра.

## Да се напише модул за ролева игра:


1. Модул за генериране на карта
2. Модул за герои
3. Модул за битки
4. Модул за въоражаване 
5. Модул за движение по картата и визуализация

## Идеята на играта.
Играта може да се играе от максимум 4 играча на карта. Картата може да съдържа различни видове полета. 
Тя е 2д, но е възможно да има телепорти, което я прави непланарна. Т.е. един играч може да се премества 
до всички граничещи полета на дадено. Ако то е специално, тогава може да го ползва/активира, което го премества
до "съседното" съответно поле на картата.
Всеки играч се движи по картата и целта му е да отстрани останалите играчи. Т.е. да ги пребори в битка и да оцелее, ако се изправи в битка с герои от картата. 
Всеки играч може да прави един ход, в който той има определен брои точки енергия, която да изразходва за движение по картата или влизане в битка. Всяка битка отнема точно една точка енергия. Енергията на всеки ход се генерира от модула за движение по картата. 
Всеки герой започва със стандартно въоражение - т.е. едно оръжие характерно за него. В процесът на движение по картата може да събира нови оръжия или броня (armor). Оръжията и бронята трябва да допринасят за всяка битка.
Всяка битка се провежда по ролеви модел, чрез редуване на протиниците. Първи е атакуващия герой, който е заплатил една точка енергия. Нападнатия герой не е нужно да заплаща енергия.
Картата има възможност да се визуализира като 2д матрица с легенда (обяснение кое поле какво прави)
Преди всеки ход, потребителя получава възможност за движение във всички възможни посоки 
* на горе
* на дясно
* на долу
* на ляво
* (влизане в битка, ако има друг герой на съответното поле)
Героя не може да напуска пределите на картата. При невъзможен ход не се намалява енергията.

## Основна програма (псевдо код)

1. Избор на брой играчи. Минимум 2 броя.
1. Генериране на карта с определени брой размери на базата на броя играчи.
1. Докато има повече от един оцелял играч, изпълнявай ходове.
    * определи енергията за текущия играч
    * Текущия играч се мести по картата докато има енергия. 
    * Потребителя контролира това като му се предоставя възможност за действие.
    * ако се въведе системна команда като `map` се визуализра картата
1. Следващия играч става текущ.

## Имплементация 

Повече информация може да намерите [тук] (https://github.com/SwiftFMI/rpgcore).
