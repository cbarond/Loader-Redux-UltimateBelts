local loader_techs = {
  ["logistics"] = "loader",
  ["logistics-2"] = "fast-loader",
  ["logistics-3"] = "express-loader",
  ["bob-logistics-4"] = "purple-loader",
  ["bob-logistics-5"] = "green-loader",
  ["ultra-fast-logistics"] = "ultra-fast-loader",
  ["extreme-fast-logistics"] = "extreme-fast-loader",
  ["ultra-express-logistics"] = "ultra-express-loader",
  ["extreme-express-logistics"] = "extreme-express-loader",
  ["ultimate-logistics"] = "ultimate-loader",
}


for i, force in pairs(game.forces) do 
  force.reset_recipes()
  force.reset_technologies()
  
  for tech, recipe in pairs(loader_techs) do
    if force.technologies[tech] then 
      if force.technologies[tech].researched then 
        force.recipes[recipe].enabled = true
      else
        force.recipes[recipe].enabled = false
      end
    end
  end  
end
