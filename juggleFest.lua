local x = os.clock()
-- Juggler's class
local Juggler = {}
Juggler.__index = Juggler
function Juggler:new(name, circuit_score, circuit_pref, circuit_score_all)
    return setmetatable({name = name, circuit_score = circuit_score, circuit_pref = circuit_pref, circuit_score_all = circuit_score_all}, self)
end

-- Circuit's Class
local Circuit = {}
Circuit.__index = Circuit
function Circuit:new(name, circuit_score, lf_jugglers)
    return setmetatable({name = name, circuit_score = circuit_score, lf_jugglers = lf_jugglers}, self)
end

-- Explode from php
local function stringTrim(str)
    return (string.gsub(str, "^%s*(.-)%s*$", "%1"))
end 
local function stringExplode(str, sep) 
    local pos, t = 1, {}
    if #sep == 0 or #str == 0 then return end
    for s, e in function() return string.find(str, sep, pos) end do
        table.insert(t, stringTrim(string.sub(str, pos, s-1)))
        pos = e+1
    end
    table.insert(t, stringTrim(string.sub(str, pos)))
    return t
end

local function find_circuit(circuit_name, circuit_list)
    
    if (circuit_name == nil or circuit_list == nil) then print("Cirxuit name is nil") return end
    
    for i,v in ipairs(circuit_list) do 
        
        if (v.name == circuit_name) then
            return v
      
        end   
    end
    
    print ("Circuit" .. circuit_name .. " not found")
    return false
    
end

local function find_circuit_score(juggler, circuit_name)
	

	for i,v in ipairs(juggler.circuit_score_all) do 
	
		exploded_string = stringExplode(v, ":")
		if (exploded_string[1] == circuit_name) then 
			
			
			return exploded_string[2]
		else
			--print (circuit_name .. juggler.name)
			
			return 0
		
		end
	end
	


end

--Function to calculate dot product
local function dot_product(a, b)
    
    local ret = 0
    for i = 1, #a, 1 do 
        ret = ret + a[i] * b[i]
    end
    return ret 
end
local function remove_juggler(j_name, circuit)
    
    for i,v in ipairs(circuit.lf_jugglers) do
        
        if (v.name == j_name) then
            
            table.remove(circuit.lf_jugglers, i)
      
            return true
        end
        
    end
    
    print ("Juggler has not been found")
    return false
  
    
end
local function remove_weakest_juggler(circuit)
  
  	local min_score = 1000000
   	local weakest_juggler = nil
   
   for i,v in ipairs(circuit.lf_jugglers) do 
   
        local dot_prod = tonumber(find_circuit_score(v, circuit.name))
        --dot_product(circuit.circuit_score, v.circuit_score) 
		
		if (dot_prod < min_score) then
            
    		min_score = dot_prod
        	weakest_juggler = v
        
    	end    
	end
	
	remove_juggler(weakest_juggler.name, circuit)
	
	find_circuit_score(weakest_juggler, circuit.name)
	return weakest_juggler

end

local function assign_jugglers(circuit, max_circuit_length, lf_circuits)
	
	if (#circuit.lf_jugglers <= max_circuit_length) then return true end
	
	weakest_juggler = remove_weakest_juggler(circuit)
	
	if (#weakest_juggler.circuit_pref > 0) then
		
		local jugglers_pref = weakest_juggler.circuit_pref[1]
		table.remove(weakest_juggler.circuit_pref, 1)
	
		local circuit = find_circuit(jugglers_pref, lf_circuits)
		table.insert(circuit.lf_jugglers, weakest_juggler)
	
		assign_jugglers(circuit,max_circuit_length, lf_circuits)
	
	elseif (#weakest_juggler.circuit_pref == 0) then 
		local random_circuit = "C" .. math.random(0, circuits_number - 1)
		
		local circuit = find_circuit(random_circuit, lf_circuits)
		table.insert(circuit.lf_jugglers, weakest_juggler)
		
		
		assign_jugglers(circuit,max_circuit_length, lf_circuits)
		
	else 
		table.insert(lf_not_assigned, weakest_juggler)
	end
	
	
	
	

end

-- Function to calculate juggler's scores for output
function calculate_juggler_scores(juggler_list, circuit_list)

for i,v in ipairs(juggler_list)  do 
	
	for j,v2 in ipairs(v.circuit_pref) do 
	
		local circuit = find_circuit(v2, circuit_list)
		
		table.insert(v.circuit_score_all, circuit.name .. " : " .. dot_product(v.circuit_score, circuit.circuit_score) )

			
	end
end

end



--Globals
circuits_number = 0
jugglers_number = 0

lf_circuits = {}
lf_jugglers = {}
lf_not_assigned = {}

--Read and prepare data
file = io.open("jugglefest.txt", "r")
io.input(file)

while true do

    line = io.read()
    if line == nil then break end
  
    temp_string = stringExplode(line, " ")
        
    if (temp_string[1] == "C") then
        circuit_name = temp_string[2] 
        h = stringExplode(temp_string[3], ":")
        e = stringExplode(temp_string[4], ":")
        p = stringExplode(temp_string[5], ":")
        circuits_number = circuits_number + 1
        local circuit = (Circuit:new(circuit_name, {h[2], e[2], p[2]}, {}))
        table.insert(lf_circuits, circuit)
    elseif (temp_string[1] == "J") then
        
        juggler_name = temp_string[2]
        h = stringExplode(temp_string[3], ":")
        e = stringExplode(temp_string[4], ":")
        p = stringExplode(temp_string[5], ":")
        
        list_of_preferences = stringExplode(temp_string[6],",")
        list_of_preferences_list = {}
        
        for i,v in ipairs(list_of_preferences) do
            
            table.insert(list_of_preferences_list, v)
            
        end
        
        jugglers_number = jugglers_number + 1
        
        local juggler = Juggler:new(juggler_name, {h[2], e[2], p[2]}, list_of_preferences_list, {})
        table.insert(lf_jugglers, juggler) 
    end

end

io.close(file)
max_circuit_length = jugglers_number/circuits_number
calculate_juggler_scores(lf_jugglers, lf_circuits)
for i,v in ipairs(lf_jugglers) do
	
	if (#v.circuit_pref > 0) then
		
		jugglers_pref = v.circuit_pref[1]
		table.remove(v.circuit_pref, 1)
	
		--find circuit, insert juggler and check if its ok
		local circuit = find_circuit(jugglers_pref, lf_circuits)
		table.insert(circuit.lf_jugglers, v)
		
		assign_jugglers(circuit,max_circuit_length,lf_circuits)
		
	end
end


--write to file
file_to_write = io.open("jugglers_groups_new.txt", "w")
io.output(file_to_write)


string = ""
string_2 = ""
for i,v in ipairs(lf_circuits) do 
   --print (v.name)
   io.write(" =========================================" .."\n")
   io.write(v.name .. "\n")
   io.write(" =========================================" .."\n")
   for j,v2 in ipairs(v.lf_jugglers) do
   		
   		string = string .. " " .. v2.name
   			
   		for k,v3 in ipairs(v2.circuit_score_all) do 
   			string_2 = " " .. string_2 .. v3 .. " "
   		
   		end
   		
   		
   		--print(string .. string_2)
        io.write(string .. string_2 .. "\n" .. "\n")
        string_2 = ""
        string = ""
       --string = string .. " " .. v2.name
       
       
       --write(v2.name)
     -- print (v2.name)
       
   end
   --print (string)
   string = ""
   string_2 = ""
end



io.close(file_to_write)

for i,v in ipairs(lf_not_assigned) do 
	
	--print (v)

end
print(#lf_not_assigned)
--for i,v in ipairs(lf_jugglers) do 
--	
--	print(v.name)
--	for j2, v2 in ipairs(v.circuit_score_all) do
--		
--		print (v2)
--	
--	end 
--	
--
--end

local s = 0
for i=1,100000 do s = s + i end
print(string.format("elapsed time: %.2f\n", os.clock() - x))
