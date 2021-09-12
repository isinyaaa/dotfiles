function spot --wraps spotify-tui_program --description 'little script for spotify tui'
	if not pgrep "spotifyd";
		spotifyd
	end
	
	spt
end
