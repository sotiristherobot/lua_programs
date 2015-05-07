
function partition(a, low, hi)
	
	i, j = low + 1, hi
	
	v = a[low]
	
	while (true) do 
		
		while( a[i] < v) do 
			i = i + 1
			if ( i == hi) then break end
		end 
		
		while ( v < a[j]) do 
			j = j - 1
			if (j == low) then break end
		end
		
		if (i >= j) then break end
		
		t = a[i]
		a[i] = a[j]
		a[j] = t
	end	
	
	t = a[low]
	a[low] = a[j]
	a[j] = t
	
	return j
	
end


function sort(a, low, hi) 

	if (hi <= low) then return end
	j = partition(a, low, hi)
	sort(a, low, j - 1)
	sort(a, j + 1, hi)
	

end

a = {10, 4, 2, 5, 1}
--a = {1, 5, 2, 4, 10}

sort(a, 1, 5)

for i = 1, #a, 1 do
	print (a[i])
end
