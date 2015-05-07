k = {1, 5, 7, 3, 2, 4}


for i,v in ipairs(k) do
	
	min = i
	j = i + 1
	for j, v2 in ipairs(k) do 
		
		if ( k[j] < k[min]) then 
			
			min = j
			
		end
		
		tmp = k[i]
		k[i] =  k[min]
		k[min] = tmp
	
	end
	
end

for i,v in ipairs(k) do 
	print (v)
end


