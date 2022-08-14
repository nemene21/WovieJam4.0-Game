
-- External Modules
json = require "frameworkScripts.json"

-- Framework Modules
require "frameworkScripts.misc"
require "frameworkScripts.loading"
require "frameworkScripts.shaders"
require "frameworkScripts.mathPlus"
require "frameworkScripts.input"
require "frameworkScripts.sprites"
require "frameworkScripts.particles"
require "frameworkScripts.tiles"
require "frameworkScripts.timer"
require "frameworkScripts.camera"
require "frameworkScripts.text"
require "frameworkScripts.audio"
require "frameworkScripts.buttons"

-- Project Specific Modules
require "data.scripts.robots"
require "data.scripts.parts"

-- Scenes
require "data.scripts.scenes.blank"; require "data.scripts.scenes.game"; require "data.scripts.scenes.build"; require "data.scripts.scenes.menu"

scenes = {

blank  = {blank, blankReload, blankDie},

game   = {game, gameReload, gameDie},

build  = {build, buildReload, buildDie},

menu = {menu, menuReload, menuDie}

}