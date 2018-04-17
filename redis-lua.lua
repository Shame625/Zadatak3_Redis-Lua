local k = KEYS[1]

local spot_id = function(param)
  local plane_id = param
  local current_spot = redis.pcall('GET', plane_id)
  if(current_spot) then
    return redis.pcall('GET', plane_id)
    
  else
    local current_taken_spots = {}
    local available_spots = {}
    
    local GET_STRING_PLANES = ''
    
    redis.replicate_commands()
    for i = 1, 100 do
      current_taken_spots[i]= redis.pcall('MGET', i)
    end
    
    for i = 1, 100 do
      local contains = false
      
      for j = 1, 100 do
        if (tonumber(i) == tonumber(current_taken_spots[j][1])) then
          contains = true
          break
          end
      end
      if contains == false then
        table.insert(available_spots, i)
      end
    end
    
    local rnd = redis.pcall('TIME')
    local park_id = available_spots[rnd[1] % table.getn(available_spots)]
    
    redis.pcall('SET', plane_id, park_id)
    redis.pcall('SAVE')
    return park_id
  end
end

local spot = spot_id(ARGV[1])
print('-------------')
print('Plane Id:', ARGV[1])
print('Spot Id:', spot)
print('-------------')

