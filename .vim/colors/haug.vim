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

let g:colors_name = "haug"

" Structure similar to the solarized color scheme structure

" Define colors
if (has("gui_running")) || &termguicolors
        let s:vmode     = "gui"

        " base colors
        let s:color_wht   = "#F1F1F4" " white
        let s:color_blk   = "#0B0C0F" " black

        " colorful colors
        let s:color_yel   = "#D4A711" " yellow
        let s:color_org   = "#D46211" " orange
        let s:color_red   = "#E5210B" " red

        let s:color_lil   = "#B599FF" " lilac
        let s:color_pur   = "#7F4EFE" " purple
        let s:color_blu   = "#4A30E8" " blue

        let s:color_lgr   = "#BCFF66" " light green
        let s:color_grn   = "#71C20A" " green
        let s:color_dgr   = "#467010" " forest green

        let s:color_sky   = "#66D1FF" " sky
        let s:color_cbl   = "#1094C3" " cool blue
        let s:color_tel   = "#17556F" " teal

        " gray
        " names are g[ray][S][L]
        " where S is saturation (a = 3, b = 8, c = 15)
        " and L is lightness (0 = -30%, 1 = -10%, 2 = 10%, 3 = 30%)

        let s:color_ga0   = "#313135" 
        let s:color_ga1   = "#61636B" 
        let s:color_ga2   = "#97989B" 
        let s:color_ga3   = "#CBCBCD" 

        let s:color_gb0   = "#2E3038" 
        let s:color_gb1   = "#5D606F" 
        let s:color_gb2   = "#9093A2" 
        let s:color_gb3   = "#C7C9D1" 

        let s:color_gc0   = "#2B313B" 
        let s:color_gc1   = "#576175" 
        let s:color_gc2   = "#8A94A8" 
        let s:color_gc3   = "#C4CAD4" 
else 
        let s:vmode     = "cterm"

        " base colors
        let s:color_wht   = 255 " white
        let s:color_blk   = 232 " black

        " colorful colors
        let s:color_yel   = 178 " yellow
        let s:color_org   = 166 " orange
        let s:color_red   = 160 " red

        let s:color_lil   = 141 " lilac
        let s:color_pur   = 99  " purple
        let s:color_blu   = 62  " blue

        let s:color_lgr   = 155 " light green
        let s:color_grn   = 70  " green
        let s:color_dgr   = 58  " forest green

        let s:color_sky   = 81  " sky
        let s:color_cbl   = 31  " cool blue
        let s:color_tel   = 23  " teal

        " gray
        " names are g[ray][S][L]
        " where S is saturation (a = 3, b = 8, c = 15)
        " and L is lightness (0 = -30%, 1 = -10%, 2 = 10%, 3 = 30%)

        let s:color_ga0   = 236
        let s:color_ga1   = 241
        let s:color_ga2   = 246
        let s:color_ga3   = 252

        let s:color_gb0   = 236
        let s:color_gb1   = 241
        let s:color_gb2   = 246
        let s:color_gb3   = 251

        let s:color_gc0   = 236
        let s:color_gc1   = 60
        let s:color_gc2   = 103
        let s:color_gc3   = 252
endif

" Define Highlight strings
execute "let s:bg_non  = ' ".s:vmode."bg=NONE'"
execute "let s:bg_wht  = ' ".s:vmode."bg=".s:color_wht ."'"
execute "let s:bg_blk  = ' ".s:vmode."bg=".s:color_blk ."'"

execute "let s:bg_yel  = ' ".s:vmode."bg=".s:color_yel ."'"
execute "let s:bg_org  = ' ".s:vmode."bg=".s:color_org ."'"
execute "let s:bg_red  = ' ".s:vmode."bg=".s:color_red ."'"

execute "let s:bg_lil  = ' ".s:vmode."bg=".s:color_lil ."'"
execute "let s:bg_pur  = ' ".s:vmode."bg=".s:color_pur ."'"
execute "let s:bg_blu  = ' ".s:vmode."bg=".s:color_blu ."'"

execute "let s:bg_lgr  = ' ".s:vmode."bg=".s:color_lgr ."'"
execute "let s:bg_grn  = ' ".s:vmode."bg=".s:color_grn ."'"
execute "let s:bg_dgr  = ' ".s:vmode."bg=".s:color_dgr ."'"

execute "let s:bg_sky  = ' ".s:vmode."bg=".s:color_sky ."'"
execute "let s:bg_cbl  = ' ".s:vmode."bg=".s:color_cbl ."'"
execute "let s:bg_tel  = ' ".s:vmode."bg=".s:color_tel ."'"

execute "let s:bg_ga0  = ' ".s:vmode."bg=".s:color_ga0 ."'"
execute "let s:bg_ga1  = ' ".s:vmode."bg=".s:color_ga1 ."'"
execute "let s:bg_ga2  = ' ".s:vmode."bg=".s:color_ga2 ."'"
execute "let s:bg_ga3  = ' ".s:vmode."bg=".s:color_ga3 ."'"

execute "let s:bg_gb0  = ' ".s:vmode."bg=".s:color_gb0 ."'"
execute "let s:bg_gb1  = ' ".s:vmode."bg=".s:color_gb1 ."'"
execute "let s:bg_gb2  = ' ".s:vmode."bg=".s:color_gb2 ."'"
execute "let s:bg_gb3  = ' ".s:vmode."bg=".s:color_gb3 ."'"

execute "let s:bg_gc0  = ' ".s:vmode."bg=".s:color_gc0 ."'"
execute "let s:bg_gc1  = ' ".s:vmode."bg=".s:color_gc1 ."'"
execute "let s:bg_ga2  = ' ".s:vmode."bg=".s:color_ga2 ."'"
execute "let s:bg_gc3  = ' ".s:vmode."bg=".s:color_gc3 ."'"

execute "let s:fg_non  = ' ".s:vmode."fg=NONE'"
execute "let s:fg_wht  = ' ".s:vmode."fg=".s:color_wht ."'"
execute "let s:fg_blk  = ' ".s:vmode."fg=".s:color_blk ."'"

execute "let s:fg_yel  = ' ".s:vmode."fg=".s:color_yel ."'"
execute "let s:fg_org  = ' ".s:vmode."fg=".s:color_org ."'"
execute "let s:fg_red  = ' ".s:vmode."fg=".s:color_red ."'"

execute "let s:fg_lil  = ' ".s:vmode."fg=".s:color_lil ."'"
execute "let s:fg_pur  = ' ".s:vmode."fg=".s:color_pur ."'"
execute "let s:fg_blu  = ' ".s:vmode."fg=".s:color_blu ."'"

execute "let s:fg_lgr  = ' ".s:vmode."fg=".s:color_lgr ."'"
execute "let s:fg_grn  = ' ".s:vmode."fg=".s:color_grn ."'"
execute "let s:fg_dgr  = ' ".s:vmode."fg=".s:color_dgr ."'"

execute "let s:fg_sky  = ' ".s:vmode."fg=".s:color_sky ."'"
execute "let s:fg_cbl  = ' ".s:vmode."fg=".s:color_cbl ."'"
execute "let s:fg_tel  = ' ".s:vmode."fg=".s:color_tel ."'"

execute "let s:fg_ga0  = ' ".s:vmode."fg=".s:color_ga0 ."'"
execute "let s:fg_ga1  = ' ".s:vmode."fg=".s:color_ga1 ."'"
execute "let s:fg_ga2  = ' ".s:vmode."fg=".s:color_ga2 ."'"
execute "let s:fg_ga3  = ' ".s:vmode."fg=".s:color_ga3 ."'"

execute "let s:fg_gb0  = ' ".s:vmode."fg=".s:color_gb0 ."'"
execute "let s:fg_gb1  = ' ".s:vmode."fg=".s:color_gb1 ."'"
execute "let s:fg_gb2  = ' ".s:vmode."fg=".s:color_gb2 ."'"
execute "let s:fg_gb3  = ' ".s:vmode."fg=".s:color_gb3 ."'"

execute "let s:fg_gc0  = ' ".s:vmode."fg=".s:color_gc0 ."'"
execute "let s:fg_gc1  = ' ".s:vmode."fg=".s:color_gc1 ."'"
execute "let s:fg_ga2  = ' ".s:vmode."fg=".s:color_ga2 ."'"
execute "let s:fg_gc3  = ' ".s:vmode."fg=".s:color_gc3 ."'"

" Define format strings
let s:fmt_none = ' gui=NONE cterm=NONE term=NONE'
let s:fmt_bold = ' gui=NONE,bold cterm=NONE,bold term=NONE,bold'
let s:fmt_ibld = ' gui=NONE,inverse,bold cterm=NONE,inverse,bold term=NONE,inverse,bold'
let s:fmt_undl = ' gui=NONE,underline cterm=NONE,underline term=NONE,underline'
let s:fmt_ital = ' gui=NONE,italic cterm=NONE,italic term=NONE,italic'


execute "hi Number"             . s:fmt_none . s:fg_red . s:bg_non
execute "hi Boolean"            . s:fmt_none . s:fg_red . s:bg_non
execute "hi Character"          . s:fmt_none . s:fg_red . s:bg_non
execute "hi Float"              . s:fmt_none . s:fg_red . s:bg_non
execute "hi Directory"          . s:fmt_none . s:fg_red . s:bg_non
execute "hi Folded"             . s:fmt_none . s:fg_red . s:bg_non

execute "hi Cursor"             . s:fmt_none . s:fg_red . s:bg_wht
execute "hi Folded"             . s:fmt_none . s:fg_red . s:bg_non
execute "hi Todo"               . s:fmt_ibld . s:fg_red . s:bg_non

execute "hi Underlined"         . s:fmt_undl . s:fg_non . s:bg_non
execute "hi Search"             . s:fmt_undl . s:fg_non . s:bg_non
execute "hi Constant"           . s:fmt_none . s:fg_non . s:bg_non
execute "hi Pmenu"              . s:fmt_none . s:fg_non . s:bg_non
execute "hi PmenuSel"           . s:fmt_none . s:fg_non . s:bg_non
execute "hi Visual"             . s:fmt_none . s:fg_non . s:bg_non
execute "hi CursurLine"         . s:fmt_none . s:fg_non . s:bg_non
execute "hi CursurColumn"       . s:fmt_none . s:fg_non . s:bg_non

execute "hi IncSearch"          . s:fmt_none . s:fg_non . s:bg_yel
execute "hi ColorColumn"        . s:fmt_none . s:fg_non . s:bg_gb0
execute "hi Type"               . s:fmt_none . s:fg_grn . s:bg_non
execute "hi StorageClass"       . s:fmt_ital . s:fg_grn . s:bg_non
execute "hi Type"               . s:fmt_none . s:fg_grn . s:bg_non
execute "hi Identifier"         . s:fmt_none . s:fg_grn . s:bg_non

execute "hi Function"           . s:fmt_none . s:fg_sky . s:bg_non

execute "hi Tag"                . s:fmt_none . s:fg_org . s:bg_non
execute "hi Statement"          . s:fmt_none . s:fg_org . s:bg_non
execute "hi PreProc"            . s:fmt_none . s:fg_org . s:bg_non
execute "hi Operator"           . s:fmt_none . s:fg_org . s:bg_non
execute "hi Keyword"            . s:fmt_none . s:fg_org . s:bg_non
execute "hi Define"             . s:fmt_none . s:fg_org . s:bg_non
execute "hi Conditional"        . s:fmt_none . s:fg_org . s:bg_non
execute "hi MatchParen"         . s:fmt_undl . s:fg_org . s:bg_non
execute "hi DiffDelete"         . s:fmt_none . s:fg_org . s:bg_non

execute "hi Label"              . s:fmt_none . s:fg_yel . s:bg_non
execute "hi String"             . s:fmt_none . s:fg_yel . s:bg_non

execute "hi DiffText"           . s:fmt_bold . s:fg_wht . s:bg_tel
execute "hi DiffChange"         . s:fmt_none . s:fg_wht . s:bg_tel
execute "hi StatusLine"         . s:fmt_bold . s:fg_wht . s:bg_ga1
execute "hi StatusLineNC"       . s:fmt_none . s:fg_wht . s:bg_ga1
execute "hi Special"            . s:fmt_none . s:fg_wht . s:bg_non
execute "hi Title"              . s:fmt_bold . s:fg_wht . s:bg_non

execute "hi ErrorMsg"           . s:fmt_none . s:fg_wht . s:bg_org
execute "hi WarningMsg"         . s:fmt_bold . s:fg_wht . s:bg_org


execute "hi NonText"            . s:fmt_none . s:fg_gb1 . s:bg_non

execute "hi SpecialKey"         . s:fmt_none . s:fg_gb1 . s:bg_non

execute "hi DiffAdd"            . s:fmt_bold . s:fg_wht . s:bg_dgr

execute "hi LineNr"             . s:fmt_none . s:fg_cbl . s:bg_non

execute "hi VertSplit"          . s:fmt_bold . s:fg_gc0 . s:bg_non

execute "hi Comment"            . s:fmt_none . s:fg_cbl . s:bg_non

execute "hi SignColumn"         . s:fmt_none . s:fg_ga2 . s:bg_non
execute "hi FoldColmun"         . s:fmt_none . s:fg_ga2 . s:bg_non


execute "hi Normal"             . s:fmt_none . s:fg_wht . s:bg_blk

execute "hi TabLineFill"        . s:fmt_none . s:fg_ga0 . s:bg_non
execute "hi TabLine"            . s:fmt_none . s:fg_ga1 . s:bg_non

execute "hi TabLineSel"         . s:fmt_none . s:fg_wht . s:bg_non 
execute "hi Conceal"            . s:fmt_none . s:fg_grn . s:bg_non

" Ruby
execute "hi rubyClass"                          . s:fmt_none . s:fg_org . s:bg_non
execute "hi rubyFunction"                       . s:fmt_none . s:fg_sky . s:bg_non
execute "hi rubyInterpolationDelimiter"         . s:fmt_none . s:fg_non . s:bg_non
execute "hi rubySymbol"                         . s:fmt_none . s:fg_red . s:bg_non
execute "hi rubyConstant"                       . s:fmt_ital . s:fg_grn . s:bg_non
execute "hi rubyStringDelimiter"                . s:fmt_none . s:fg_yel . s:bg_non
execute "hi rubyBlockParameter"                 . s:fmt_ital . s:fg_lil . s:bg_non
execute "hi rubyInstanceVariable"               . s:fmt_none . s:fg_non . s:bg_non
execute "hi rubyInclude"                        . s:fmt_none . s:fg_org . s:bg_non
execute "hi rubyGlobalVariable"                 . s:fmt_none . s:fg_non . s:bg_non
execute "hi rubyRegexp"                         . s:fmt_none . s:fg_yel . s:bg_non
execute "hi rubyRegexpDelimiter"                . s:fmt_none . s:fg_yel . s:bg_non
execute "hi rubyEscape"                         . s:fmt_none . s:fg_red . s:bg_non
execute "hi rubyControl"                        . s:fmt_none . s:fg_org . s:bg_non
execute "hi rubyClassVariable"                  . s:fmt_none . s:fg_non . s:bg_non
execute "hi rubyOperator"                       . s:fmt_none . s:fg_org . s:bg_non
execute "hi rubyException"                      . s:fmt_none . s:fg_org . s:bg_non
execute "hi rubyPseudoVariable"                 . s:fmt_none . s:fg_non . s:bg_non
execute "hi rubyRailsUserClass"                 . s:fmt_ital . s:fg_grn . s:bg_non
execute "hi rubyRailsARAssociationMethod"       . s:fmt_none . s:fg_grn . s:bg_non
execute "hi rubyRailsARMethod"                  . s:fmt_none . s:fg_grn . s:bg_non
execute "hi rubyRailsRenderMethod"              . s:fmt_none . s:fg_grn . s:bg_non
execute "hi rubyRailsMethod"                    . s:fmt_none . s:fg_grn . s:bg_non
execute "hi erubyDelimiter"                     . s:fmt_none . s:fg_non . s:bg_non
execute "hi erubyComment"                       . s:fmt_none . s:fg_red . s:bg_non
execute "hi erubyRailsMethod"                   . s:fmt_none . s:fg_grn . s:bg_non

" HTML
execute "hi htmlTag"            . s:fmt_none . s:fg_non . s:bg_non
execute "hi htmlEndTag"         . s:fmt_none . s:fg_non . s:bg_non
execute "hi htmlTagName"        . s:fmt_none . s:fg_non . s:bg_non
execute "hi htmlArg"            . s:fmt_none . s:fg_non . s:bg_non
execute "hi htmlSpecialChar"    . s:fmt_none . s:fg_red . s:bg_non

" JS
execute "hi javaScriptFunction"         . s:fmt_ital . s:fg_grn . s:bg_non
execute "hi javaScriptRailsFunction"    . s:fmt_none . s:fg_grn . s:bg_non
execute "hi javaScriptBraces"           . s:fmt_none . s:fg_non . s:bg_non

" YAML
execute "hi yamlKey"            . s:fmt_none . s:fg_org . s:bg_non
execute "hi yamlAnchor"         . s:fmt_none . s:fg_non . s:bg_non
execute "hi yamlAlias"          . s:fmt_none . s:fg_non . s:bg_non
execute "hi yamlDocumentHeader" . s:fmt_none . s:fg_yel . s:bg_non

" CSS
execute "hi cssURL"             . s:fmt_ital . s:fg_lil . s:bg_non
execute "hi cssFunctionName"    . s:fmt_none . s:fg_grn . s:bg_non
execute "hi cssColor"           . s:fmt_none . s:fg_red . s:bg_non
execute "hi cssPseudoClassId"   . s:fmt_none . s:fg_sky . s:bg_non
execute "hi cssClassName"       . s:fmt_none . s:fg_sky . s:bg_non
execute "hi cssValueLength"     . s:fmt_none . s:fg_red . s:bg_non
execute "hi cssCommonAttr"      . s:fmt_none . s:fg_sky . s:bg_non
execute "hi cssBraces"          . s:fmt_none . s:fg_non . s:bg_non


" Elixir {{{
execute "hi elixirAtom"                         . s:fmt_ital . s:fg_grn . s:bg_non
execute "hi elixirModuleDeclaration"            . s:fmt_ital . s:fg_grn . s:bg_non
execute "hi elixirAlias"                        . s:fmt_ital . s:fg_grn . s:bg_non
execute "hi elixirInterpolationDelimiter"       . s:fmt_none . s:fg_sky . s:bg_non
execute "hi elixirStringDelimiter"              . s:fmt_none . s:fg_yel . s:bg_non
"}}}
"
" Vim Script {{{
execute "hi vimGroupName"          . s:fg_grn . s:bg_non
execute "hi vimGroup"              . s:fg_grn . s:bg_non
execute "hi vimOption"             . s:fg_grn . s:bg_non
execute "hi vimHiCtermFgBg"        . s:fg_non . s:bg_non
execute "hi vimHiGuiFgBg"          . s:fg_non . s:bg_non
" }}}
"

" vimtex
execute "hi texComment" . s:fmt_none . s:fg_lil . s:bg_non
execute "hi texGroup" . s:fmt_none . s:fg_sky . s:bg_non
execute "hi texLength" . s:fmt_none . s:fg_sky . s:bg_non
execute "hi texGroupError" . s:fmt_none . s:fg_sky . s:bg_non
execute "hi texOpt" . s:fmt_none . s:fg_sky . s:bg_non
execute "hi texOptEqual" . s:fmt_none . s:fg_sky . s:bg_non
execute "hi texOptSep" . s:fmt_none . s:fg_sky . s:bg_non
execute "hi texDelim" . s:fmt_none . s:fg_sky . s:bg_non

execute "hi texCmd" . s:fmt_none . s:fg_sky . s:bg_non
execute "hi texCmdEnv" . s:fmt_none . s:fg_red . s:bg_non
execute "hi texCmdEnvM" . s:fmt_none . s:fg_yel . s:bg_non
execute "hi texCmdFootnote" . s:fmt_none . s:fg_sky . s:bg_non
execute "hi texCmdGreek" . s:fmt_none . s:fg_sky . s:bg_non
execute "hi texCmdMinipage" . s:fmt_none . s:fg_sky . s:bg_non
execute "hi texCmdParbox" . s:fmt_none . s:fg_sky . s:bg_non
execute "hi texCmdRef" . s:fmt_none . s:fg_cbl . s:bg_non
execute "hi texCmdSize" . s:fmt_none . s:fg_sky . s:bg_non
execute "hi texCmdStyle" . s:fmt_none . s:fg_sky . s:bg_non
execute "hi texCmdTodo" . s:fmt_none . s:fg_sky . s:bg_non
execute "hi texCmdVerb" . s:fmt_none . s:fg_sky . s:bg_non

execute "hi texMathCmd" . s:fmt_none . s:fg_lgr . s:bg_non
execute "hi texMathCmdEnv" . s:fmt_none . s:fg_grn . s:bg_non
execute "hi texMathCmdStyle" . s:fmt_none . s:fg_grn . s:bg_non
execute "hi texMathCmdStyleBold" . s:fmt_none . s:fg_grn . s:bg_non
execute "hi texMathCmdStyleItal" . s:fmt_none . s:fg_grn . s:bg_non
execute "hi texMathCmdText" . s:fmt_none . s:fg_grn . s:bg_non
execute "hi texMathDelim" . s:fmt_none . s:fg_grn . s:bg_non
execute "hi texMathDelimMod" . s:fmt_none . s:fg_grn . s:bg_non
execute "hi texMathGroup" . s:fmt_none . s:fg_grn . s:bg_non
execute "hi texMathOper" . s:fmt_none . s:fg_grn . s:bg_non
execute "hi texMathSuperSub" . s:fmt_none . s:fg_grn . s:bg_non
execute "hi texMathSymbol" . s:fmt_none . s:fg_grn . s:bg_non
execute "hi texMathZoneEnv" . s:fmt_none . s:fg_grn . s:bg_non
execute "hi texMathZoneX" . s:fmt_none . s:fg_grn . s:bg_non

execute "hi texPartArgTitle" . s:fmt_bold . s:fg_wht . s:bg_ga0



"execute "au BufEnter *.tex hi Conceal" . s:fmt_none . s:fg_grn . s:bg_non
"execute "au BufLeave *.tex hi Conceal" . s:fmt_none . s:fg_ga1 . s:bg_non 


"
"cygwin has an annoying behavior where it resets background to light
"regardless of what is set above, so we force it yet again
"
"add these to get cygwin shell working when used to ssh into a centos6 vm
"this requires your TERM=xterm-256color in the guest vm
"- one way to do this is to append to /home/vagrant/.bash_profile ala:
"      TERM=xterm-256color
"      export $TERM

"execute "set background=dark"
"-------------------
