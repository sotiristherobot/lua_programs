local Man = {}
Man.__index = Man
function Man:new(name, free, list_of_preferences, proposed_to)
	return setmetatable({ name = name, free = free, list_of_preferences = list_of_preferences, list_proposed_to = proposed_to}, self)
end

local Woman = {}
Woman.__index = Woman
function Woman:new(name, free, list_of_preferences)
	return setmetatable({name = name, free = free, list_of_preferences = list_of_preferences}, self)
end

function free_men_exist(list_of_men)

	for i,v in ipairs(list_of_men) do
		
		if v.free == true then 
			--print(v.name)
			return v 
		end 
		
	end
	
	return false

end

function find_pair_by_name(woman_name, engaged_list)
	
	for i,v in ipairs(engaged) do
		
		if (v[2].name == woman_name) then
			
			return v	
		
		end
	
	end
	
	return false

end

function already_proposed_to(woman, list_proposed_to )
	
	for i, v in ipairs(list_proposed_to) do
     	if (woman == v) then
     		return true
     	
     	end
     end
     
	return false    

end

function highest_ranked_woman(man)
	
	for i, v in ipairs(man.list_of_preferences) do
		if (already_proposed_to(v, man.list_proposed_to) == false) then
			return v
		end
	end
			

end

function find_woman_by_name(name, woman_list)

	for i,v in ipairs(woman_list) do
		if v.name == name then
			return v
		
		end
	end
	
	return false
end	

function find_man_by_name(name, men_list)

	for i,v in ipairs(men_list) do
		if v.name == name then
			return v
		
		end
	end
	
	return false

end

function find_woman_preference(woman_name, man_candidate1, man_candidate2, woman_list)

	for i,v in ipairs(woman_list) do
		
		if (v.name == woman_name) then 
			
			for j, v2 in ipairs(v.list_of_preferences) do
			
				if (v2 == man_candidate1) then
					return man_candidate1
				
				elseif (v2 == man_candidate2) then
					return man_candidate2
				
				end
			end
			
			
		end
	
	end


end

function remove_entry(entry,engaged)
	
	
	for i,v in ipairs(engaged) do
	
		if v[1].name == entry[1].name and v[2].name == entry[2].name then 
			table.remove(engaged, i)
			--print(v[1].name .. v[2].name .. " removing" .. "\n")
			--v = nil		
			--print(engaged[i][0])
			--v = nil
		
		end
	
	end
	
	



end

function stable_matching(list_of_men, list_of_women, engaged, m)
	
	--local m = list_of_men[1]
	local w = find_woman_by_name(highest_ranked_woman(m), list_of_women)
	
	if (w.free) then
		--print (w.name)
		m.free = false
		w.free = false
		table.insert(engaged, {m,w})
		table.insert(m.list_proposed_to, w.name)
		
	else 
		pair = find_pair_by_name(w.name, engaged)
		woman_preference = find_woman_preference(w.name, m.name, pair[1].name, list_of_women)
		
		if (woman_preference == m.name) then
			
			old_man = find_man_by_name(pair[1].name, list_of_men)
			old_man.free = true
			m.free = false
			w.free = false
			
			remove_entry(pair, engaged)
			--table.remove(engaged, pair)
			table.insert(engaged, {m,w})
			table.insert(m.list_proposed_to, w.name)
					
		end
		
		
	end
	
	--pair = find_pair_by_name(m.name, w.name, engaged)
--	
--	k = find_woman_preference("Geeta", "David",  "Carl", list_of_women)
--	
--	print (k)
--	

end

engaged = {}
list_of_men = {
				Man:new("Adam", true,  {"Geeta", "Heiki", "Irina", "Fran"}, {}),
				Man:new("Bob", true,   {"Irina", "Fran", "Heiki", "Geeta"}, {}),
				Man:new("Carl", true,  {"Geeta", "Fran", "Heiki", "Irina"}, {}),
				Man:new("David", true, {"Irina", "Heiki", "Geeta", "Fran"}, {})
}
list_of_women = {
				 Woman:new("Fran", true, {"Adam", "Carl", "Bob", "David"}),
				 Woman:new("Geeta", true,{"Carl", "David", "Bob", "Adam"}),
				 Woman:new("Heiki", true,{"Carl", "Bob", "David", "Adam"}),
				 Woman:new("Irina", true,{"Adam", "Carl", "David", "Bob"})				
}


--free_men_exist(list_of_men)

while (free_men_exist(list_of_men)) do 

for i,v in ipairs(list_of_men) do 

	if v.free == true then 
		
		stable_matching(list_of_men,list_of_women,engaged, v)

	end
end

end


for i,v in ipairs(engaged) do 
	
	print (v[1].name .. " " .. v[2].name .. "\n")

end




io.close()


