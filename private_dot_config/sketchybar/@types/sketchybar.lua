---@meta sketchybar

---@alias SketchybarItemType "item"|"space"|"alias"

--- Common events: routine, forced, system_woke, power_source_change,
--- volume_change, front_app_switched, mouse.clicked, mouse.scrolled,
--- mouse.entered, mouse.exited, mouse.exited.global, and custom events.
---@alias SketchybarEvent string

---@alias SketchybarEnv table<string, any>

---@class SketchybarFont
---@field family? string
---@field style? string
---@field size? number
---@field [string] any

---@class SketchybarSection
---@field string? string
---@field drawing? boolean|string
---@field color? string|number
---@field width? number
---@field height? number
---@field align? "left"|"right"|"center"
---@field padding_left? number
---@field padding_right? number
---@field font? SketchybarFont
---@field [string] any

---@class SketchybarPropertyTable
---@field position? string
---@field width? number
---@field height? number
---@field icon? SketchybarSection|string|table
---@field label? SketchybarSection|string|table
---@field background? SketchybarSection
---@field popup? SketchybarSection|SketchybarPropertyTable
---@field slider? SketchybarSection|SketchybarPropertyTable
---@field click_script? string
---@field update_freq? number
---@field [string] any

---@class SketchybarQueryResult
---@field name? string
---@field icon? SketchybarSection
---@field label? SketchybarSection
---@field background? SketchybarSection
---@field popup? SketchybarSection
---@field [string] any

---@class SketchybarItem
---@field name string
local SketchybarItem = {}

---@param props SketchybarPropertyTable
function SketchybarItem:set(props) end

---@param events SketchybarEvent|SketchybarEvent[]
---@param callback fun(env: SketchybarEnv)
function SketchybarItem:subscribe(events, callback) end

---@return SketchybarQueryResult
function SketchybarItem:query() end

---@param values number[]
function SketchybarItem:push(values) end

---@class Sketchybar
local Sketchybar = {}

---@param type SketchybarItemType
---@param props SketchybarPropertyTable
---@return SketchybarItem
function Sketchybar.add(type, props) end

---@param type SketchybarItemType
---@param name string
---@param props? SketchybarPropertyTable
---@return SketchybarItem
function Sketchybar.add(type, name, props) end

---@param type "bracket"
---@param members string[]
---@param props? SketchybarPropertyTable
---@return SketchybarItem
function Sketchybar.add(type, members, props) end

---@param type "bracket"
---@param name string
---@param members string[]
---@param props? SketchybarPropertyTable
---@return SketchybarItem
function Sketchybar.add(type, name, members, props) end

---@param type "slider"|"graph"
---@param width number
---@param props? SketchybarPropertyTable
---@return SketchybarItem
function Sketchybar.add(type, width, props) end

---@param type "slider"|"graph"
---@param name string
---@param width number
---@param props? SketchybarPropertyTable
---@return SketchybarItem
function Sketchybar.add(type, name, width, props) end

---@param type "event"
---@param name string
---@param notification? string
---@return SketchybarItem
function Sketchybar.add(type, name, notification) end

---@param props SketchybarPropertyTable
function Sketchybar.bar(props) end

---@param props SketchybarPropertyTable
function Sketchybar.default(props) end

---@param item string|SketchybarItem
---@param props SketchybarPropertyTable
function Sketchybar.set(item, props) end

---@param item string|SketchybarItem
function Sketchybar.remove(item) end

---@param curve string
---@param duration integer
---@param callback fun()
function Sketchybar.animate(curve, duration, callback) end

---@param event string
---@param env? SketchybarEnv
function Sketchybar.trigger(event, env) end

---@param command string
---@param callback? fun(result: any, exit_code: integer)
function Sketchybar.exec(command, callback) end

---@param seconds number
---@param callback fun()
function Sketchybar.delay(seconds, callback) end

---@param enabled boolean
function Sketchybar.hotload(enabled) end

---@param name string
function Sketchybar.set_bar_name(name) end

---@param item string|SketchybarItem
---@param events SketchybarEvent|SketchybarEvent[]
---@param callback fun(env: SketchybarEnv)
function Sketchybar.subscribe(item, events, callback) end

---@param item string|SketchybarItem
---@return SketchybarQueryResult
function Sketchybar.query(item) end

---@param item string|SketchybarItem
---@param values number[]
function Sketchybar.push(item, values) end

function Sketchybar.begin_config() end

function Sketchybar.end_config() end

function Sketchybar.event_loop() end

function Sketchybar.update() end

return Sketchybar
