--[[ Copyright (c) 2017 Optera
 * Part of Loader Redux
 *
 * See LICENSE.md in the project directory for license information.
--]]

-- match loader speed to their respective belts
data.raw["loader"]["loader"].speed = data.raw["transport-belt"]["transport-belt"].speed
data.raw["loader"]["fast-loader"].speed = data.raw["transport-belt"]["fast-transport-belt"].speed
data.raw["loader"]["express-loader"].speed = data.raw["transport-belt"]["express-transport-belt"].speed
data.raw["loader"]["ultra-fast-loader"].speed = data.raw["transport-belt"]["ultra-fast-belt"].speed
data.raw["loader"]["extreme-fast-loader"].speed = data.raw["transport-belt"]["extreme-fast-belt"].speed
data.raw["loader"]["ultra-express-loader"].speed = data.raw["transport-belt"]["ultra-express-belt"].speed
data.raw["loader"]["extreme-express-loader"].speed = data.raw["transport-belt"]["extreme-express-belt"].speed
data.raw["loader"]["ultimate-loader"].speed = data.raw["transport-belt"]["ultimate-belt"].speed
