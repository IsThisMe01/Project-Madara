local games = {
    { name = "Steal An Egg", ids = { 10563114921 }, link = "https://raw.githubusercontent.com/IsThisMe01/Project-Madara/refs/heads/main/stealanegg" },
    { name = "Idle Mafia Game", ids = { 10643795368 }, link = "https://raw.githubusercontent.com/IsThisMe01/Project-Madara/refs/heads/main/idleMafia.lua" },
    { name = "Anime Dice", ids = { 10708913337 }, link = "https://raw.githubusercontent.com/IsThisMe01/Project-Madara/refs/heads/main/animedice.lua"},
    { name = "Jump For Animal", ids = { 10690360998 }, link = "https://raw.githubusercontent.com/IsThisMe01/Project-Madara/refs/heads/main/jumpforanimal.lua"},
    { name = "Driving Empire", ids = { 1202096104 }, link = "https://raw.githubusercontent.com/IsThisMe01/Project-Madara/refs/heads/main/drivingempire.lua"},
    { name = "MM2", ids = { 66654135 }, link = "https://raw.githubusercontent.com/IsThisMe01/Project-Madara/refs/heads/main/mm22.lua"},
    { name = "Search for a Needle", ids = { 10756011174 }, link = "https://raw.githubusercontent.com/IsThisMe01/Project-Madara/refs/heads/main/searchfortheneedle.lua"},
}

local LocalPlayer = game:GetService("Players").LocalPlayer
local placeId = game.PlaceId
local gameId = game.GameId

local function kick(msg)
    pcall(function()
        LocalPlayer:Kick(msg)
    end)
end

local function match_game(g, placeId, gameId)
    for _, e in ipairs(g.ids) do
        local id = e
        if type(e) == "table" then
            id = e.id or e[1]
        end
        if id == placeId or id == gameId then
            local link = g.link
            if type(e) == "table" then
                link = e.link or (type(e[3]) == "string" and e[3] or nil) or link
            end
            return link
        end
    end
    return nil
end

local function getscript(url)
    local a, b = pcall(function() return game:HttpGet(url) end)
    if a and b and #b > 0 then return b end

    local req = getgenv().request or getgenv().http_request or request or http_request
    if req then
        local c, d = pcall(req, { Url = url, Method = "GET" })
        if c and d then
            local body = type(d) == "table" and (d.Body or d.body) or d
            if type(body) == "string" and #body > 0 then return body end
        end
    end
    return nil
end

local function execute(link)
    local src = nil
    for _ = 1, 3 do
        src = getscript(link)
        if src then break end
        task.wait(1)
    end
    if not src or type(loadstring) ~= "function" then return false end
    local compiled, f = pcall(loadstring, src)
    if not compiled or type(f) ~= "function" then return false end
    pcall(f)
    return true
end

for _, g in ipairs(games) do
    local link = match_game(g, placeId, gameId)
    if link then
        if not execute(link) then
            kick("Madara: couldn't fetch " .. g.name)
        end
        return
    end
end

kick("Madara: this game isn't supported (" .. tostring(placeId) .. ")")
