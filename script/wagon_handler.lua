--[[ Copyright (c) 2017 Optera
 * Part of Loader Redux
 *
 * See LICENSE.md in the project directory for license information.
--]]

local wagon_handler = {}

local wagon_valid
local wagon_validators = {
  ["disabled"] = function (wagon)
    return false
  end,
  ["auto-only"] = function (wagon)
    local train = wagon and wagon.valid and wagon.train
    return train and train.state == defines.train_state.wait_station
  end,
  ["all trains"] = function (wagon)
    local train = wagon and wagon.valid and wagon.train
    local train_state = train and train.state
    return train_state == defines.train_state.wait_station or train_state == defines.train_state.manual_control and train.speed == 0
  end
}

function wagon_handler.create_wagon_validators(use_train)
  wagon_valid = wagon_validators[use_train]
end

local function get_filters(entity)
  local filters = {}
  local filtered = false
  for n = 1, entity.filter_slot_count do
    local filter = entity.get_filter(n)
    if filter then
      filters[filter] = true
      filtered = true
    end
  end
  return filtered and filters
end

function wagon_handler.transfer(wagon_data)
  local wagon = wagon_data.wagon_inv
  for _, loader_data in pairs(wagon_data.loaders) do
    local loader = loader_data.loader
    local line1, line2 = loader_data[1], loader_data[2]

    if loader.loader_type == "output" then
      local filters = get_filters(loader)
      if filters then
        if not wagon.is_empty() and line1.can_insert_at_back() then
          for name in pairs(filters) do
            if wagon.remove({ name = name }) == 1 then
              line1.insert_at_back({ name = name })
              break
            end
          end
        end
        if not wagon.is_empty() and line2.can_insert_at_back() then
          for name in pairs(filters) do
            if wagon.remove({ name = name }) == 1 then
              line2.insert_at_back({ name = name })
              break
            end
          end
        end
      else
        local name = next(wagon.get_contents())
        if name and line1.insert_at_back({ name = name }) then
          wagon.remove({ name = name })
        end
        name = next(wagon.get_contents())
        if name and line2.insert_at_back({ name = name }) then
          wagon.remove({ name = name })
        end
      end
    elseif loader.loader_type == "input" then
      for name in pairs(line1.get_contents()) do
        if wagon.insert({ name = name }) == 1 then
          line1.remove_item({ name = name })
          break
        end
      end
      for name in pairs(line2.get_contents()) do
        if wagon.insert({ name = name }) == 1 then
          line2.remove_item({ name = name })
          break
        end
      end
    end
  end
end

local function getLoaderSearchData(wagon, direction)
  local size = game.entity_prototypes[wagon.name].collision_box --vanilla is {{-0.6, -2.4}, {0.6, 2.4}}
  local min_x = size.left_top.x
  local min_y = size.left_top.y
  local max_x = size.right_bottom.x
  local max_y = size.right_bottom.y

  --game.print("Checking " .. direction .. " with wagon bounds of {{" .. min_x .. " , " .. min_y .. "}, {" .. max_x .. " , " .. max_y .. "}}")
  if direction == "west" then
    return {type = "loader", name = global.supported_loader_names, area = {{wagon.position.x+min_x-0.9, wagon.position.y+min_y+0.2}, {wagon.position.x+max_x-0.1, wagon.position.y+max_y-0.2}}} --was -1.5, -2.2, +0.5, +2.2
  elseif direction == "east" then
    return {type = "loader", name = global.supported_loader_names, area = {{wagon.position.x+min_x+1.1, wagon.position.y+min_y+0.2}, {wagon.position.x+max_x+0.9, wagon.position.y+max_y-0.2}}} --was +0.5, -2.2, +1.5, +2.2
  elseif direction == "north" then
    return {type = "loader", name = global.supported_loader_names, area = {{wagon.position.x+min_y+0.2, wagon.position.y+min_x-0.9}, {wagon.position.x+max_y-0.2, wagon.position.y+max_x-1.1}}} --was -2.2, -1.5, +2.2, -0.5
  elseif direction == "south" then
    return {type = "loader", name = global.supported_loader_names, area = {{wagon.position.x+min_y+0.2, wagon.position.y+min_x+1.1}, {wagon.position.x+max_y-0.2, wagon.position.y+max_x+0.9}}} --was -2.2, +0.5, +2.2, +1.5
  end
end

--Find loaders based on train orientation and state
function wagon_handler.find_loader(wagon, ent)
  if wagon_valid(wagon) then
    w_num = wagon.unit_number
    if wagon.orientation == 0 or wagon.orientation == 0.5 then
      for _, loader in pairs(wagon.surface.find_entities_filtered(getLoaderSearchData(wagon, "west"))) do
        if (ent and loader == ent) or not ent then
        local l_num = loader.unit_number
        global.loader_wagon_map[l_num] = w_num
        global.wagons[w_num] = global.wagons[w_num] or {
          wagon = wagon,
          wagon_inv = wagon.get_inventory(defines.inventory.cargo_wagon),
          loaders = {}
        }
        global.wagons[w_num].loaders[l_num] = {
          loader = loader,
          direction = 6,
          [1] = loader.get_transport_line(1),
          [2] = loader.get_transport_line(2)
        }
        end
      end
      for _, loader in pairs(wagon.surface.find_entities_filtered(getLoaderSearchData(wagon, "east"))) do
        if (ent and loader == ent) or not ent then
        local l_num = loader.unit_number
        global.loader_wagon_map[l_num] = w_num
        global.wagons[w_num] = global.wagons[w_num] or {
          wagon = wagon,
          wagon_inv = wagon.get_inventory(defines.inventory.cargo_wagon),
          loaders = {}
        }
        global.wagons[w_num].loaders[l_num] = {
          loader = loader,
          direction = 2,
          [1] = loader.get_transport_line(1),
          [2] = loader.get_transport_line(2)
        }
        end
      end
    elseif wagon.orientation==0.25 or wagon.orientation==0.75 then
      for _, loader in pairs(wagon.surface.find_entities_filtered(getLoaderSearchData(wagon, "north"))) do
        if (ent and loader == ent) or not ent then
        local l_num = loader.unit_number
        global.loader_wagon_map[l_num] = w_num
        global.wagons[w_num] = global.wagons[w_num] or {
          wagon = wagon,
          wagon_inv = wagon.get_inventory(defines.inventory.cargo_wagon),
          loaders = {}
        }
        global.wagons[w_num].loaders[l_num] = {
          loader = loader,
          direction = 0,
          [1] = loader.get_transport_line(1),
          [2] = loader.get_transport_line(2)
        }
        end
      end
      for _, loader in pairs(wagon.surface.find_entities_filtered(getLoaderSearchData(wagon, "south"))) do
        if (ent and loader == ent) or not ent then
        local l_num = loader.unit_number
        global.loader_wagon_map[l_num] = w_num
        global.wagons[w_num] = global.wagons[w_num] or {
          wagon = wagon,
          wagon_inv = wagon.get_inventory(defines.inventory.cargo_wagon),
          loaders = {}
        }
        global.wagons[w_num].loaders[l_num] = {
          loader = loader,
          direction = 4,
          [1] = loader.get_transport_line(1),
          [2] = loader.get_transport_line(2)
        }
        end
      end
    end
  end
end

local active_directions = {
  output = {
    [0] = 0,
    [2] = 2,
    [4] = 4,
    [6] = 6
  },
  input = {
    [0] = 4,
    [2] = 6,
    [4] = 0,
    [6] = 2
  }
}
local function loader_active(loader_data)
  local loader = loader_data.loader
  return loader and loader.valid and active_directions[loader.loader_type][loader.direction] == loader_data.direction
end

function wagon_handler.loader_check(wagon_data)
  local active_loader = false
  if wagon_valid(wagon_data.wagon) then
    for num, loader_data in pairs(wagon_data.loaders) do
      if loader_active(loader_data) then
        active_loader = true
      else
        global.loader_wagon_map[num] = nil
        wagon_data.loaders[num] = nil
      end
    end
  else
    for num in pairs(wagon_data.loaders) do
      global.loader_wagon_map[num] = nil
    end
  end
  return active_loader
end

return wagon_handler