s = "hello world from Lua red 'red' \"red\" UredP"
-- for w in string.gmatch(s, "%pred%p") do
for w in string.gmatch(s, "[\'\"]red[\"\']") do
	print(w)
end
