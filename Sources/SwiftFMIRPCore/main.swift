var mapGenerator = DefaultMapGenerator()
var playerGenerator = DefaultPlayerGenerator(heroGenerator: DefaultHeroGenerator())
var figthGenerator = DefaultFightGenerator()
var equipmentGenerator = DefaultEquipmentGenerator()
var mapRendered = DefaultMapRenderer()
var heroGenerator = DefaultHeroGenerator()
var game = Game(mapGenerator: mapGenerator, playerGenerator: playerGenerator, mapRenderer: mapRendered, heroGenerator: heroGenerator)

game.run()
