--open file for editing
local f = 'triangle.txt'

data = {}
count = 1

--read lines from file creating a table of tables
function lines_from(f)
		
	for line in io.lines(f) do
		if line ~= nil then
			local count_temp = 1
			lines = {}
			for i in string.gmatch(line, "%S+") do
  				--print(i)
  				lines[count_temp] = i
  				count_temp = count_temp + 1
  				
			end
			--lines[count] = line
			--print (lines[2])
			data[count] = lines
			count = count + 1
			
			
		end
	end
	return lines
end

lines_from(f)


function max(a, b)
if a > b then
	return a
else
	return b
end

end

local N = count - 2

for i = N, 1, -1 do
	for j = 1, i + 1 do
	
		if (data[i][j] ~= nil) then
	
			if(data[i+1][j] ~=nil) and (data[i+1][j+1] ~= nil) then
		data[i][j] = data[i][j] + max(data[i+1][j], data[i+1][j+1])
--print (data[i][j])
			end
		end
	end 
end

print (data[1][1])

