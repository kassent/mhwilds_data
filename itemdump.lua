
---@enum via.Language System.Int32
local Language = {
	Japanese = 0, -- 0x0
	English = 1, -- 0x1
	French = 2, -- 0x2
	Italian = 3, -- 0x3
	German = 4, -- 0x4
	Spanish = 5, -- 0x5
	Russian = 6, -- 0x6
	Polish = 7, -- 0x7
	Dutch = 8, -- 0x8
	Portuguese = 9, -- 0x9
	PortugueseBr = 10, -- 0xA
	Korean = 11, -- 0xB
	TransitionalChinese = 12, -- 0xC
	SimplelifiedChinese = 13, -- 0xD
	Finnish = 14, -- 0xE
	Swedish = 15, -- 0xF
	Danish = 16, -- 0x10
	Norwegian = 17, -- 0x11
	Czech = 18, -- 0x12
	Hungarian = 19, -- 0x13
	Slovak = 20, -- 0x14
	Arabic = 21, -- 0x15
	Turkish = 22, -- 0x16
	Bulgarian = 23, -- 0x17
	Greek = 24, -- 0x18
	Romanian = 25, -- 0x19
	Thai = 26, -- 0x1A
	Ukrainian = 27, -- 0x1B
	Vietnamese = 28, -- 0x1C
	Indonesian = 29, -- 0x1D
	Fiction = 30, -- 0x1E
	Hindi = 31, -- 0x1F
	LatinAmericanSpanish = 32, -- 0x20
	Max = 33, -- 0x21
	Unknown = 33, -- 0x21
}
local getItemNameMethod = sdk.find_type_definition("via.gui.message"):get_method("get(System.Guid)")

---@field get fun(arg0: System.Guid, arg1: via.Language): System.String|string public static 0x14c355950 / id: 973192

local getItemNameMethodEx = sdk.find_type_definition("via.gui.message"):get_method("get(System.Guid, via.Language)")
local function get_TextFromGuid(guid)
	return getItemNameMethod:call(nil, guid)
end


item_definitions = {}

function init_item_definitions()
    --- @type app.VariousDataManager
    local variousDataManager = sdk.get_managed_singleton("app.VariousDataManager")
    local itemSetting = variousDataManager:get_Setting():get_Item()
    local itemDataList = itemSetting:get_ItemData()

    local itemNum = itemDataList:getDataNum()


    for i = 0, itemNum - 1 do
        local itemData = itemDataList:getDataByIndex(i)
        local rawNameGuid = itemData:get_RawName()

        local englishName = getItemNameMethodEx:call(nil, rawNameGuid, Language.English)
        local frenchName = getItemNameMethodEx:call(nil, rawNameGuid, Language.French)
        local italianName = getItemNameMethodEx:call(nil, rawNameGuid, Language.Italian)
        local germanName = getItemNameMethodEx:call(nil, rawNameGuid, Language.German)
        local spanishName = getItemNameMethodEx:call(nil, rawNameGuid, Language.Spanish)
        local arabicName = getItemNameMethodEx:call(nil, rawNameGuid, Language.Arabic)
        local latinAmericanSpanishName = getItemNameMethodEx:call(nil, rawNameGuid, Language.LatinAmericanSpanish)
        local portugueseBrName = getItemNameMethodEx:call(nil, rawNameGuid, Language.PortugueseBr)
        local polishName = getItemNameMethodEx:call(nil, rawNameGuid, Language.Polish)
        local russianName = getItemNameMethodEx:call(nil, rawNameGuid, Language.Russian)
        local traditionalChineseName = getItemNameMethodEx:call(nil, rawNameGuid, Language.TransitionalChinese)
        local japaneseName = getItemNameMethodEx:call(nil, rawNameGuid, Language.Japanese)
        local koreanName = getItemNameMethodEx:call(nil, rawNameGuid, Language.Korean)
        local chineseName = getItemNameMethodEx:call(nil, rawNameGuid, Language.SimplelifiedChinese)
        local itemFixedId = itemData:get_ItemId()

        log.info("[MHWSBeta] itemFixedId: " .. itemFixedId .. " name: " .. chineseName)
        -- local itemIdValue = event_quest_loader.get_item_id_from_fixed_id(itemFixedId)


        --- @type System.Int32
        local itemIdWrapper = ValueType.new(sdk.find_type_definition("System.Int32"))

        local getIDFromFixedMethod = sdk.find_type_definition("app.ItemDef"):get_method("getIDFromFixed")
        getIDFromFixedMethod:call(nil, itemFixedId, itemIdWrapper)

        -- local getIDFromFixedMethod = sdk.find_type_definition("app.MissionIDList"):get_method("getIDFromFixed")
        -- getIDFromFixedMethod:call(nil, itemFixedId, missionIdWrapper)

        local itemIdValue = itemIdWrapper.m_value

        log.info("[MHWSBeta] itemIdValue: " .. itemIdValue)

        -- app.MissionIDList.getIDFromFixed(itemFixedId, missionIdWrapper)

        --- @type app.ItemDef.ID
        local instance = sdk.create_instance("app.ItemDef.ID")
        instance.value__ = itemIdValue
        local itemId = instance:ToString()


        item_definitions[itemIdValue] = {
            id = itemIdValue,
            fixedId = itemFixedId,
            name =  {
                ["zh-cn"] = chineseName,
                ["en-us"] = englishName,
                ["ja-jp"] = japaneseName,
                ["fr-fr"] = frenchName,
                ["it-it"] = italianName,
                ["de-de"] = germanName,
                ["es-es"] = spanishName,
                ["ar-sa"] = arabicName,
                ["es-la"]  = latinAmericanSpanishName,
                ["pt-br"] = portugueseBrName,
                ["pl-pl"] = polishName,
                ["ru-ru"] = russianName,
                ["zh-tw"] = traditionalChineseName,
                ["ko-kr"] = koreanName
            },
            label = itemId
        }
    end
end
init_item_definitions()
-- 将item_definitions 保存到文件
-- json.dump_file("item_definitions_full.json", item_definitions, 4)

-- 转为数组并根据id大小进行排序后保存
local items_list = {}
for _, item in pairs(item_definitions) do
    table.insert(items_list, {
        id = item.id,
        fixedId = item.fixedId,
        name = {
            ["zh-cn"] = item.name["zh-cn"],
            ["en-us"] = item.name["en-us"],
            ["ja-jp"] = item.name["ja-jp"],
            ["fr-fr"] = item.name["fr-fr"],
            ["it-it"] = item.name["it-it"],
            ["de-de"] = item.name["de-de"],
            ["es-es"] = item.name["es-es"],
            ["ar-sa"] = item.name["ar-sa"],
            ["es-la"] = item.name["es-la"],
            ["pt-br"] = item.name["pt-br"],
            ["pl-pl"] = item.name["pl-pl"],
            ["ru-ru"] = item.name["ru-ru"],
            ["zh-tw"] = item.name["zh-tw"],
            ["ko-kr"] = item.name["ko-kr"],
        },
        label = item.label,
    })
end
table.sort(items_list, function(a, b)
    return a.id < b.id
end)
json.dump_file("items_list.json", items_list, 4)




local function DumpMonsterInfo()
    local enemy_definitions = {}
    -- get_EnemyIDFromFixedID
    -- get_EnemyIDFromFixedID
    local getNameStringMethod = sdk.find_type_definition("app.EnemyDef"):get_method("EnemyName(app.EnemyDef.ID)")
    -- enemyid从0到210
    for i = 0, 300 do
        local monsterId = i
        local getFixedFromIDMethod = sdk.find_type_definition("app.EnemyDef"):get_method("getFixedFromID")
        local monsterFixedIdWrapper = ValueType.new(sdk.find_type_definition("System.Int32"))
        local success = getFixedFromIDMethod:call(nil, monsterId, monsterFixedIdWrapper)
        local nameGuid = getNameStringMethod:call(nil, monsterId)
        local nameString = getItemNameMethod:call(nil, nameGuid)
        if success and nameString ~= nil and nameString ~= "" then
            local monsterFixedId = monsterFixedIdWrapper.m_value
            --- @type System.Guid
            local instance = sdk.create_instance("app.EnemyDef.ID")
            instance.value__ = monsterId
            local enemyIdStr = instance:ToString()
            log.info("monsterId: " .. monsterId .. " monsterFixedId: " .. monsterFixedId .. " monsterName: " .. nameString)
            -- enemy_definitions[monsterId] = {
            --     fixedId = monsterFixedId,
            --     id = monsterId,
            --     name = nameString,
            --     label = enemyIdStr
            -- }
            table.insert(enemy_definitions, {
                fixedId = monsterFixedId,
                id = monsterId,
                name = {
                    ["zh-cn"] = getItemNameMethodEx:call(nil, nameGuid, Language.SimplelifiedChinese),
                    ["en-us"] = getItemNameMethodEx:call(nil, nameGuid, Language.English),
                    ["ja-jp"] = getItemNameMethodEx:call(nil, nameGuid, Language.Japanese),
                    ["fr-fr"] = getItemNameMethodEx:call(nil, nameGuid, Language.French),
                    ["it-it"] = getItemNameMethodEx:call(nil, nameGuid, Language.Italian),
                    ["de-de"] = getItemNameMethodEx:call(nil, nameGuid, Language.German),
                    ["es-es"] = getItemNameMethodEx:call(nil, nameGuid, Language.Spanish),
                    ["ar-sa"] = getItemNameMethodEx:call(nil, nameGuid, Language.Arabic),
                    ["es-la"] = getItemNameMethodEx:call(nil, nameGuid, Language.LatinAmericanSpanish),
                    ["pt-br"] = getItemNameMethodEx:call(nil, nameGuid, Language.PortugueseBr),
                    ["pl-pl"] = getItemNameMethodEx:call(nil, nameGuid, Language.Polish),
                    ["ru-ru"] = getItemNameMethodEx:call(nil, nameGuid, Language.Russian),
                    ["zh-tw"] = getItemNameMethodEx:call(nil, nameGuid, Language.TransitionalChinese),
                    ["ko-kr"] = getItemNameMethodEx:call(nil, nameGuid, Language.Korean),
                },
                label = enemyIdStr
            })
        end
    end

    -- sort
    table.sort(enemy_definitions, function(a, b)
        return a.id < b.id
    end)
    json.dump_file("enemy_definitions.json", enemy_definitions, 4)
end
DumpMonsterInfo()



local function processQuestReward()
    local getRewardAllItemDataMethod = sdk.find_type_definition('app.QuestGeneralRewardUtil'):get_method('getRewardAllItemData(System.UInt32, app.QuestGeneralRewardUtil.GeneralRewardType)')
    local reward_list = {}
    for rewardId = 0, 10000 do
        --- @type System.Collections.Generic.List<app.savedata.cItemWork>
        local rewardList = getRewardAllItemDataMethod:call(nil, rewardId, 0)
        -- reward数组
        local rewards = {}
        if rewardList ~= nil then
            local rewardListNum = rewardList:get_Count()
            for i = 0, rewardListNum - 1 do
                --- @type app.savedata.cItemWork
                local rewardItem = rewardList:get_Item(i)
                if rewardItem ~= nil then
                    local itemId = rewardItem:get_ItemId()
                    local itemNum = rewardItem.Num
                    local itemName = nil
                    -- 判断是否存在再获取名称
                    if item_definitions[itemId] ~= nil then
                        itemName = item_definitions[itemId].name
                    end
                    rewards[i] = {
                        itemId = itemId,
                        itemNum = itemNum,
                        itemName = itemName
                    }
                    -- log.info("[MHWSBeta] rewardId: " .. rewardId .. " itemId: " .. itemId .. " itemNum: " .. itemNum .. " itemName: " .. itemName)
                end
            end
        end

        if #rewards > 0 then
            reward_list[rewardId] = rewards
        end
    end
    json.dump_file("reward_list.json", reward_list, 4)
end

processQuestReward()

