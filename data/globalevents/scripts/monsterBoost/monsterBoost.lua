local monsterPosition = {x=90, y=128, z=7} -- posição do "monstro", na sala do monstruario
local lootBoostPosition = {x=89, y=128, z=7} -- posição da frase "boost", na salado monstruario
local expBoostPosition = {x=91, y=128, z=7} -- posição da frase "Exp", na sala do mosntruario

local BOOST_SYSTEM_MONSTER_NAME_STORAGE = 12380
local BOOST_SYSTEM_LOOT_BONUS_STORAGE = 12381
local BOOST_SYSTEM_EXP_BONUS_STORAGE = 12382

string.upperAllFirst = string.upperAllFirst or function (str)
  return string.gsub(' ' .. str, '%W%l', string.upper):sub(2)
end

local days = { -- lista dos monstros que vão ser boostados e dias  
	["Sunday"]    = {"rat", "rotworm", "demon"}, -- domingo
	["Monday"]    = {"rat", "rotworm", "demon"}, -- Segunda-feira
	["Tuesday"]   = {"rat", "rotworm", "demon"}, -- Terça-feira
	["Wednesday"] = {"rat", "rotworm", "demon"}, -- Quarta-feira
	["Thursday"]  = {"rat", "rotworm", "demon"}, -- Quinta-feira
	["Friday"]    = {"rat", "rotworm", "demon"}, -- Sexta-feira
	["Saturday"]  = {"rat", "rotworm", "demon"}, -- sabado
}

function onStartup()
	local monster = days[os.date("%A")]
	if not monster then
		return true 
	end
	monster = monster[math.random(1, #monster)]
	local func = db.query or db.executeQuery
	doSetStorage(BOOST_SYSTEM_MONSTER_NAME_STORAGE, monster:lower())
	doSetStorage(BOOST_SYSTEM_LOOT_BONUS_STORAGE, math.random(10, 50))
	doSetStorage(BOOST_SYSTEM_EXP_BONUS_STORAGE, math.random(20, 48))
	doCreateMonster(monster, monsterPosition, false, true)
	func("INSERT INTO monster_boost (monster, loot, exp) VALUES ('"..monster.."', '"..getStorage(BOOST_SYSTEM_LOOT_BONUS_STORAGE).."', '"..getStorage(BOOST_SYSTEM_EXP_BONUS_STORAGE).."')")
	return true
end

function onThink()
	local monsterName = getStorage(BOOST_SYSTEM_MONSTER_NAME_STORAGE)
	if monsterName == EMPTY_STORAGE then 
		return true
	end

	local creature = getTopCreature(monsterPosition)
	if not creature or creature.uid == 0 then 
		doCreateMonster(monsterName, monsterPosition, false, true)
	elseif getCreatureName(creature.uid):lower() ~= monsterName then
		doRemoveCreature(creature.uid)
		doCreateMonster(monsterName, monsterPosition, false, true)
	end

	--doSendAnimatedText(monsterPosition, string.upperAllFirst(monsterName), COLOR_LIGHTBLUE)
	doSendAnimatedText(lootBoostPosition, "Loot +" .. getStorage(BOOST_SYSTEM_LOOT_BONUS_STORAGE) .. "%", 194)
	doSendAnimatedText(expBoostPosition, "Exp +" .. getStorage(BOOST_SYSTEM_EXP_BONUS_STORAGE) .. "%", 194)

  return true
end