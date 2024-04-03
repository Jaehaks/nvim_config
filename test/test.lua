for key,value in pairs(vim.g) do
	print(key .. ' = ' .. vim.inspect(value))
end
