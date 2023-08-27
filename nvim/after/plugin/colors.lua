function ColorMyVim(color)
	color = color or "onedark"
	vim.cmd.colorscheme(color)
end

ColorMyVim()
