--[[ Copyright (c) 2017 Optera
 * Part of Loader Redux
 *
 * See LICENSE.md in the project directory for license information.
--]]

-- require("prototypes.make_loader")
local lr = require("__LoaderRedux_UltimateBelts__.make_loader")
require("prototypes.recipe")

local tints = {
  ["loader"] = util.color("ffc340d9"),
  ["fast-loader"] = util.color("e31717d9"),
  ["express-loader"] = util.color("43c0fad9"),
  ["ultra-fast-loader"] = util.color("00d325"),
  ["extreme-fast-loader"] = util.color("f51119"),
  ["ultra-express-loader"] = util.color("5500cc"),
  ["extreme-express-loader"] = util.color("0000cc"),
  ["ultimate-loader"] = util.color("00e6cb"),
}

-- Create loaders
local belt_prototypes = data.raw["transport-belt"]

data:extend({
  lr.make_loader_item("loader", "belt", "d-a", tints["loader"]),
  lr.make_loader_item("fast-loader", "belt", "d-b", tints["fast-loader"]),
  lr.make_loader_item("express-loader", "belt", "d-c", tints["express-loader"]),
  lr.make_loader_item("ultra-fast-loader", "belt", "d-d", tints["ultra-fast-loader"]),
  lr.make_loader_item("extreme-fast-loader", "belt", "d-e", tints["extreme-fast-loader"]),
  lr.make_loader_item("ultra-express-loader", "belt", "d-f", tints["ultra-express-loader"]),
  lr.make_loader_item("extreme-express-loader", "belt", "d-g", tints["extreme-express-loader"]),
  lr.make_loader_item("ultimate-loader", "belt", "d-h", tints["ultimate-loader"]),

  lr.make_loader_entity("loader", belt_prototypes["transport-belt"], tints["loader"], "fast-loader"),
  lr.make_loader_entity("fast-loader", belt_prototypes["fast-transport-belt"], tints["fast-loader"], "express-loader"),
  lr.make_loader_entity("express-loader", belt_prototypes["express-transport-belt"], tints["express-loader"], "ultra-fast-loader"),
  lr.make_loader_entity("ultra-fast-loader", belt_prototypes["ultra-fast-belt"], tints["ultra-fast-loader"], "extreme-fast-loader"),
  lr.make_loader_entity("extreme-fast-loader", belt_prototypes["extreme-fast-belt"], tints["extreme-fast-loader"], "ultra-express-loader"),
  lr.make_loader_entity("ultra-express-loader", belt_prototypes["ultra-express-belt"], tints["ultra-express-loader"], "extreme-express-loader"),
  lr.make_loader_entity("extreme-express-loader", belt_prototypes["extreme-express-belt"], tints["extreme-express-loader"], "ultimate-loader"),
  lr.make_loader_entity("ultimate-loader", belt_prototypes["ultimate-belt"], tints["ultimate-loader"], nil),
})

-- Add loader to existing techs
local loader_techs = {
  ["logistics"] = "loader",
  ["logistics-2"] = "fast-loader",
  ["logistics-3"] = "express-loader",
  ["ultra-fast-logistics"] = "ultra-fast-loader",
  ["extreme-fast-logistics"] = "extreme-fast-loader",
  ["ultra-express-logistics"] = "ultra-express-loader",
  ["extreme-express-logistics"] = "extreme-express-loader",
  ["ultimate-logistics"] = "ultimate-loader",
}

for tech, recipe in pairs(loader_techs) do
  if data.raw.technology[tech] then
    table.insert(data.raw.technology[tech].effects, {type = "unlock-recipe", recipe = recipe} )
  end
end