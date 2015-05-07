fibonacci = {}

fibonacci[0] = 1
fibonacci[1] = 1

for i=2, 10, 1 do
  fibonacci[i] = fibonacci[i-2] + fibonacci[i-1]
  print (fibonacci[i])
end
