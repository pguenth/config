" ArchMan v 0.0.1a
"
" https://github.com/atahabaki/archman-vim
"
" Copyright 2020, All rights reserved
"
" Code licensed under the MIT license
"
" @author A. Taha Baki <@atahabaki>

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "archmanhaug"

" Structure similar to the solarized color scheme structure

" Define colors
if (has("gui_running")) || &termguicolors
        let s:vmode     = "gui"
        let s:color_00   = "#FFFFFF" " white
        let s:color_01   = "#FFCC4B" " yellow
        let s:color_02   = "#7F4EFE" " lilac
        let s:color_03   = "#3D3F49" " gray1 3
        let s:color_04   = "#3DE163" " bright green
        let s:color_05   = "#1094C3" " blue
        let s:color_06   = "#FF4143" " red
        let s:color_07   = "#17556F" " teal
        let s:color_08   = "#64666d" " middle gray
        let s:color_09   = "#525563" " gray1 1
        let s:color_10   = "#467010" " forest green
        let s:color_11   = "#76A9DB" " sky
        let s:color_12   = "#3C464F" " gray1 2
        let s:color_13   = "#909194" " light gray
        let s:color_14   = "#333438" " dark gray
        let s:color_15   = "#666666" "!obsolete -> use 08
        let s:color_16   = "#FFA244" " orange
else 
        let s:vmode     = "cterm"
        let s:color_00   = "white"
        let s:color_01   = 56
        let s:color_02   = 56
        let s:color_03   = 56
        let s:color_04   = 56
        let s:color_05   = 56
        let s:color_06   = 56
        let s:color_07   = 56
        let s:color_08   = 56
        let s:color_09   = 56
        let s:color_10   = 56
        let s:color_11   = 56
        let s:color_12   = 56
        let s:color_13   = 56
        let s:color_14   = 56
        let s:color_15   = 56
        let s:color_16   = 56
endif

" Define Highlight strings
execute "let s:bg_no  = ' ".s:vmode."bg=NONE'"
execute "let s:bg_00  = ' ".s:vmode."bg=".s:color_00 ."'"
execute "let s:bg_01  = ' ".s:vmode."bg=".s:color_01 ."'"
execute "let s:bg_02  = ' ".s:vmode."bg=".s:color_02 ."'"
execute "let s:bg_03  = ' ".s:vmode."bg=".s:color_03 ."'"
execute "let s:bg_04  = ' ".s:vmode."bg=".s:color_04 ."'"
execute "let s:bg_05  = ' ".s:vmode."bg=".s:color_05 ."'"
execute "let s:bg_06  = ' ".s:vmode."bg=".s:color_06 ."'"
execute "let s:bg_07  = ' ".s:vmode."bg=".s:color_07 ."'"
execute "let s:bg_08  = ' ".s:vmode."bg=".s:color_08 ."'"
execute "let s:bg_09  = ' ".s:vmode."bg=".s:color_09 ."'"
execute "let s:bg_10  = ' ".s:vmode."bg=".s:color_10 ."'"
execute "let s:bg_11  = ' ".s:vmode."bg=".s:color_11 ."'"
execute "let s:bg_12  = ' ".s:vmode."bg=".s:color_12 ."'"
execute "let s:bg_13  = ' ".s:vmode."bg=".s:color_13 ."'"
execute "let s:bg_14  = ' ".s:vmode."bg=".s:color_14 ."'"
execute "let s:bg_15  = ' ".s:vmode."bg=".s:color_15 ."'"
execute "let s:bg_16  = ' ".s:vmode."bg=".s:color_16 ."'"

execute "let s:fg_no  = ' ".s:vmode."fg=NONE'"
execute "let s:fg_00  = ' ".s:vmode."fg=".s:color_00 ."'"
execute "let s:fg_01  = ' ".s:vmode."fg=".s:color_01 ."'"
execute "let s:fg_02  = ' ".s:vmode."fg=".s:color_02 ."'"
execute "let s:fg_03  = ' ".s:vmode."fg=".s:color_03 ."'"
execute "let s:fg_04  = ' ".s:vmode."fg=".s:color_04 ."'"
execute "let s:fg_05  = ' ".s:vmode."fg=".s:color_05 ."'"
execute "let s:fg_06  = ' ".s:vmode."fg=".s:color_06 ."'"
execute "let s:fg_07  = ' ".s:vmode."fg=".s:color_07 ."'"
execute "let s:fg_08  = ' ".s:vmode."fg=".s:color_08 ."'"
execute "let s:fg_09  = ' ".s:vmode."fg=".s:color_09 ."'"
execute "let s:fg_10  = ' ".s:vmode."fg=".s:color_10 ."'"
execute "let s:fg_11  = ' ".s:vmode."fg=".s:color_11 ."'"
execute "let s:fg_12  = ' ".s:vmode."fg=".s:color_12 ."'"
execute "let s:fg_13  = ' ".s:vmode."fg=".s:color_13 ."'"
execute "let s:fg_14  = ' ".s:vmode."fg=".s:color_14 ."'"
execute "let s:fg_15  = ' ".s:vmode."fg=".s:color_15 ."'"
execute "let s:fg_16  = ' ".s:vmode."fg=".s:color_16 ."'"

" Define format strings
execute "let s:fmt_none =' ".s:vmode."=NONE".                  " term=NONE".               "'"
execute "let s:fmt_bold =' ".s:vmode."=NONE,bold".             " term=NONE,bold".          "'"
execute "let s:fmt_ibld =' ".s:vmode."=NONE,inverse,bold".     " term=NONE,inverse,bold".  "'"
execute "let s:fmt_undl =' ".s:vmode."=NONE,underline".        " term=NONE,underline".     "'"
execute "let s:fmt_ital =' ".s:vmode."=NONE,italic".           " term=NONE,italic".        "'"


execute "hi Number"             . s:fmt_none . s:fg_02 . s:bg_no
execute "hi Boolean"            . s:fmt_none . s:fg_02 . s:bg_no
execute "hi Character"          . s:fmt_none . s:fg_02 . s:bg_no
execute "hi Float"              . s:fmt_none . s:fg_02 . s:bg_no
execute "hi Directory"          . s:fmt_none . s:fg_02 . s:bg_no
execute "hi Folded"             . s:fmt_none . s:fg_02 . s:bg_no

execute "hi Cursor"             . s:fmt_none . s:fg_02 . s:bg_00
execute "hi Folded"             . s:fmt_none . s:fg_02 . s:bg_no
execute "hi Todo"               . s:fmt_ibld . s:fg_02 . s:bg_no

execute "hi Underlined"         . s:fmt_undl . s:fg_no . s:bg_no
execute "hi Search"             . s:fmt_undl . s:fg_no . s:bg_no
execute "hi Constant"           . s:fmt_none . s:fg_no . s:bg_no
execute "hi Pmenu"              . s:fmt_none . s:fg_no . s:bg_no
execute "hi PmenuSel"           . s:fmt_none . s:fg_no . s:bg_no
execute "hi Visual"             . s:fmt_none . s:fg_no . s:bg_no
execute "hi CursurLine"         . s:fmt_none . s:fg_no . s:bg_no
execute "hi CursurColumn"       . s:fmt_none . s:fg_no . s:bg_no

execute "hi IncSearch"          . s:fmt_none . s:fg_no . s:bg_01
execute "hi ColorColumn"        . s:fmt_none . s:fg_no . s:bg_03
execute "hi Type"               . s:fmt_none . s:fg_04 . s:bg_no
execute "hi StorageClass"       . s:fmt_ital . s:fg_04 . s:bg_no
execute "hi Type"               . s:fmt_none . s:fg_04 . s:bg_no
execute "hi Identifier"         . s:fmt_none . s:fg_04 . s:bg_no

execute "hi Function"           . s:fmt_none . s:fg_05 . s:bg_no

execute "hi Tag"                . s:fmt_none . s:fg_06 . s:bg_no
execute "hi Statement"          . s:fmt_none . s:fg_06 . s:bg_no
execute "hi PreProc"            . s:fmt_none . s:fg_06 . s:bg_no
execute "hi Operator"           . s:fmt_none . s:fg_06 . s:bg_no
execute "hi Keyword"            . s:fmt_none . s:fg_06 . s:bg_no
execute "hi Define"             . s:fmt_none . s:fg_06 . s:bg_no
execute "hi Conditional"        . s:fmt_none . s:fg_06 . s:bg_no
execute "hi MatchParen"         . s:fmt_undl . s:fg_06 . s:bg_no
execute "hi DiffDelete"         . s:fmt_none . s:fg_06 . s:bg_no

execute "hi Label"              . s:fmt_none . s:fg_01 . s:bg_no
execute "hi String"             . s:fmt_none . s:fg_01 . s:bg_no

execute "hi DiffText"           . s:fmt_bold . s:fg_00 . s:bg_07
execute "hi DiffChange"         . s:fmt_none . s:fg_00 . s:bg_07
execute "hi StatusLine"         . s:fmt_bold . s:fg_00 . s:bg_08
execute "hi StatusLineNC"       . s:fmt_none . s:fg_00 . s:bg_08
execute "hi Special"            . s:fmt_none . s:fg_00 . s:bg_no
execute "hi Title"              . s:fmt_bold . s:fg_00 . s:bg_no

execute "hi ErrorMsg"           . s:fmt_none . s:fg_00 . s:bg_06
execute "hi WarningMsg"         . s:fmt_bold . s:fg_00 . s:bg_06


execute "hi NonText"            . s:fmt_none . s:fg_09 . s:bg_no

execute "hi SpecialKey"         . s:fmt_none . s:fg_09 . s:bg_no

execute "hi DiffAdd"            . s:fmt_bold . s:fg_00 . s:bg_10

execute "hi LineNr"             . s:fmt_none . s:fg_11 . s:bg_no

execute "hi VertSplit"          . s:fmt_bold . s:fg_12 . s:bg_no

execute "hi Comment"            . s:fmt_none . s:fg_11 . s:bg_no

execute "hi SignColumn"         . s:fmt_none . s:fg_13 . s:bg_no
execute "hi FoldColmun"         . s:fmt_none . s:fg_13 . s:bg_no

execute "hi Normal"             . s:fmt_none . s:fg_00 . s:bg_no

execute "hi TabLineFill"        . s:fmt_none . s:fg_00 . s:bg_no
execute "hi Normal"             . s:fmt_none . s:fg_00 . s:bg_no
execute "hi Normal"             . s:fmt_none . s:fg_00 . s:bg_no

execute "hi TabLineFill"        . s:fmt_none . s:fg_14 . s:bg_no
execute "hi TabLine"            . s:fmt_none . s:fg_15 . s:bg_no

execute "hi TabLineSel"         . s:fmt_none . s:fg_00 . s:bg_no 

" Ruby
execute "hi rubyClass"                          . s:fmt_none . s:fg_06 . s:bg_no
execute "hi rubyFunction"                       . s:fmt_none . s:fg_05 . s:bg_no
execute "hi rubyInterpolationDelimiter"         . s:fmt_none . s:fg_no . s:bg_no
execute "hi rubySymbol"                         . s:fmt_none . s:fg_02 . s:bg_no
execute "hi rubyConstant"                       . s:fmt_ital . s:fg_04 . s:bg_no
execute "hi rubyStringDelimiter"                . s:fmt_none . s:fg_01 . s:bg_no
execute "hi rubyBlockParameter"                 . s:fmt_ital . s:fg_16 . s:bg_no
execute "hi rubyInstanceVariable"               . s:fmt_none . s:fg_no . s:bg_no
execute "hi rubyInclude"                        . s:fmt_none . s:fg_06 . s:bg_no
execute "hi rubyGlobalVariable"                 . s:fmt_none . s:fg_no . s:bg_no
execute "hi rubyRegexp"                         . s:fmt_none . s:fg_01 . s:bg_no
execute "hi rubyRegexpDelimiter"                . s:fmt_none . s:fg_01 . s:bg_no
execute "hi rubyEscape"                         . s:fmt_none . s:fg_02 . s:bg_no
execute "hi rubyControl"                        . s:fmt_none . s:fg_06 . s:bg_no
execute "hi rubyClassVariable"                  . s:fmt_none . s:fg_no . s:bg_no
execute "hi rubyOperator"                       . s:fmt_none . s:fg_06 . s:bg_no
execute "hi rubyException"                      . s:fmt_none . s:fg_06 . s:bg_no
execute "hi rubyPseudoVariable"                 . s:fmt_none . s:fg_no . s:bg_no
execute "hi rubyRailsUserClass"                 . s:fmt_ital . s:fg_04 . s:bg_no
execute "hi rubyRailsARAssociationMethod"       . s:fmt_none . s:fg_04 . s:bg_no
execute "hi rubyRailsARMethod"                  . s:fmt_none . s:fg_04 . s:bg_no
execute "hi rubyRailsRenderMethod"              . s:fmt_none . s:fg_04 . s:bg_no
execute "hi rubyRailsMethod"                    . s:fmt_none . s:fg_04 . s:bg_no
execute "hi erubyDelimiter"                     . s:fmt_none . s:fg_no . s:bg_no
execute "hi erubyComment"                       . s:fmt_none . s:fg_02 . s:bg_no
execute "hi erubyRailsMethod"                   . s:fmt_none . s:fg_04 . s:bg_no

" HTML
execute "hi htmlTag"            . s:fmt_none . s:fg_no . s:bg_no
execute "hi htmlEndTag"         . s:fmt_none . s:fg_no . s:bg_no
execute "hi htmlTagName"        . s:fmt_none . s:fg_no . s:bg_no
execute "hi htmlArg"            . s:fmt_none . s:fg_no . s:bg_no
execute "hi htmlSpecialChar"    . s:fmt_none . s:fg_02 . s:bg_no

" JS
execute "hi javaScriptFunction"         . s:fmt_ital . s:fg_04 . s:bg_no
execute "hi javaScriptRailsFunction"    . s:fmt_none . s:fg_04 . s:bg_no
execute "hi javaScriptBraces"           . s:fmt_none . s:fg_no . s:bg_no

" YAML
execute "hi yamlKey"            . s:fmt_none . s:fg_06 . s:bg_no
execute "hi yamlAnchor"         . s:fmt_none . s:fg_no . s:bg_no
execute "hi yamlAlias"          . s:fmt_none . s:fg_no . s:bg_no
execute "hi yamlDocumentHeader" . s:fmt_none . s:fg_01 . s:bg_no

" CSS
execute "hi cssURL"             . s:fmt_ital . s:fg_16 . s:bg_no
execute "hi cssFunctionName"    . s:fmt_none . s:fg_04 . s:bg_no
execute "hi cssColor"           . s:fmt_none . s:fg_02 . s:bg_no
execute "hi cssPseudoClassId"   . s:fmt_none . s:fg_05 . s:bg_no
execute "hi cssClassName"       . s:fmt_none . s:fg_05 . s:bg_no
execute "hi cssValueLength"     . s:fmt_none . s:fg_02 . s:bg_no
execute "hi cssCommonAttr"      . s:fmt_none . s:fg_05 . s:bg_no
execute "hi cssBraces"          . s:fmt_none . s:fg_no . s:bg_no


" Elixir {{{
execute "hi elixirAtom"                         . s:fmt_ital . s:fg_04 . s:bg_no
execute "hi elixirModuleDeclaration"            . s:fmt_ital . s:fg_04 . s:bg_no
execute "hi elixirAlias"                        . s:fmt_ital . s:fg_04 . s:bg_no
execute "hi elixirInterpolationDelimiter"       . s:fmt_none . s:fg_05 . s:bg_no
execute "hi elixirStringDelimiter"              . s:fmt_none . s:fg_01 . s:bg_no
"}}}
"
" Vim Script {{{
execute "hi vimGroupName"          . s:fg_04 . s:bg_no
execute "hi vimGroup"              . s:fg_04 . s:bg_no
execute "hi vimOption"             . s:fg_04 . s:bg_no
execute "hi vimHiCtermFgBg"        . s:fg_no . s:bg_no
execute "hi vimHiGuiFgBg"          . s:fg_no . s:bg_no
" }}}


"
"cygwin has an annoying behavior where it resets background to light
"regardless of what is set above, so we force it yet again
"
"add these to get cygwin shell working when used to ssh into a centos6 vm
"this requires your TERM=xterm-256color in the guest vm
"- one way to do this is to append to /home/vagrant/.bash_profile ala:
"      TERM=xterm-256color
"      export $TERM

execute "set background=dark"
"-------------------
