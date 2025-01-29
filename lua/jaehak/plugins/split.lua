return {
	"wurli/split.nvim",
	opts = {
		keymaps = {
			-- interactive : after keymap input, dialog opens to get which character is criteria
			-- 				 'gsi' + ',' (, is criteria to split)
			-- operator_pending : after keymap input, wait to recognize what is the range to apply split
			-- 				 'gsi' + 'i]' + ','(if interactive), it splits with ',' in []
			-- 				 if it is false, it split all ',' in plain text out of braces
			-- break_placement : where the split character is located after split
			-- 				'before_pattern' : ',' is located before word
			-- 				'after_pattern'  : ',' is located after word
			-- samrt_ignore : as default, if there are both code and comment, the split is applied for code
			["gsf"] = {
                interactive = true,
				operator_pending = true,
				break_placement = 'after_pattern',
			},
			["gsb"] = {
                interactive = true,
				operator_pending = true,
				break_placement = 'before_pattern',
			},
			["gsF"] = {
				interactive = true,
				operator_pending = false,
				break_placement = 'after_pattern',
			},
			["gsB"] = {
				interactive = true,
				operator_pending = false,
				break_placement = 'before_pattern',
			},
		},
        interactive_options = {
            [","] = ",",
            [";"] = ";",
            [" "] = "%s+",            -- white space more than 1
			["+"] = false,
            ["-"] = {
				pattern = "%.?[+-/%*%%\\]",
				transform_segments = function(x, _, line)
					if x:match(";$") then
						return x
					end

					local extra = (line.filetype == "c" and " \\")
								or (line.filetype == "matlab" and " ...")
								or ""

					return x .. extra
				end
			}, -- arithmetic operators
            ["|"] = "[&|][&|]?",      -- condition operators
            ["<"] = {                 -- all inequality like <, <=, >=
                pattern = "[<>=]=?",
            },
            ["."] = {                 -- all period of sentence (.?!)
                pattern = "[%.?!]%s+",
                unsplitter = " ",
                smart_ignore = "code",
                quote_characters = {},
                brace_characters = {}
            }
        },
		set_default_mappings = false,
	},
}
