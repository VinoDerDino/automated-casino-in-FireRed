local START_KEY = C.GBA_KEY.B
local BTN_DOWN = C.GBA_KEY.DOWN
local BTN_A = C.GBA_KEY.A
local BTN_B = C.GBA_KEY.B
local BTN_NONE = -1

local ENTER_PATTERN = {
    BTN_A, BTN_NONE, BTN_NONE, BTN_NONE, BTN_NONE, BTN_NONE, BTN_NONE,
    BTN_A, BTN_NONE, BTN_NONE
}
local BUTTON_PATTERN = {
    BTN_DOWN, BTN_DOWN, BTN_DOWN, BTN_A, BTN_NONE, BTN_A, BTN_A
}
local EXIT_PATTERN = {
    BTN_NONE, BTN_NONE, BTN_NONE, BTN_NONE, BTN_NONE, BTN_NONE, BTN_NONE,
    BTN_NONE, BTN_NONE, BTN_NONE, BTN_NONE, BTN_NONE, BTN_NONE, BTN_NONE,
    BTN_NONE, BTN_NONE, BTN_NONE, BTN_NONE, BTN_NONE, BTN_NONE, BTN_NONE,
    BTN_NONE, BTN_NONE, BTN_NONE, BTN_NONE, BTN_NONE, BTN_B, BTN_A,
    BTN_NONE, BTN_NONE, BTN_NONE
}

local function mergeTables(...)
    local result = {}

    for _, tbl in ipairs({...}) do
        for i = 1, #tbl do
            result[#result + 1] = tbl[i]
        end
    end

    return result
end

local btns = mergeTables(ENTER_PATTERN, BUTTON_PATTERN, EXIT_PATTERN)
local btns_length = #btns

local BPM = 115
local FPS = 59.7275

local framesPerBeat = FPS * 60 / BPM

local frameCounter = 0
local totalFrames = 0
local beat = 1
local enabled = false

console:log("================================")
console:log("Automated casino")
console:log("Start: B")
console:log("================================")

callbacks:add("keysRead", function()
    if not enabled and emu:getKey(START_KEY) ~= 0 then
        console:log("Automated casino started!")

        enabled = true
        beat = 0
        frameCounter = 0
        totalFrames = 0
    end
end)

callbacks:add("frame", function()
    if not enabled then return end

    totalFrames = totalFrames + 1
    frameCounter = frameCounter + 1

    local keys = 0
    emu:setKeys(keys)

    if frameCounter >= framesPerBeat then
        frameCounter = frameCounter - framesPerBeat

        local index = beat + 1
        local key = btns[index]

        if key ~= BTN_NONE then
            keys = 1 << key
        end

        console:log("Key: " .. keys .. ", Beat: " .. index)

        beat = index

        if beat >= btns_length then
            beat = 0
        end
    end

    emu:setKeys(keys)
end)
