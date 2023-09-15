ifndef VERBOSE
.SILENT:
endif

luacheck:
	luacheck .

stylua:
	stylua --check .

lua-language-server: dependencies
	rm -rf lua-language-server-log
	lua-language-server --configpath .luarc.$(version).json --logpath lua-language-server-log --check .
	[ -f lua-language-server-log/check.json ] && { cat lua-language-server-log/check.json 2>/dev/null; exit 1; } || true

dependencies:
	if [ ! -d vendor ]; then \
		git clone --depth 1 \
			https://github.com/folke/neodev.nvim \
			vendor/pack/vendor/start/neodev.nvim; \
	fi
