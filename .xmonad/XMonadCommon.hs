{-# LANGUAGE TypeSynonymInstances, DeriveDataTypeable, MultiParamTypeClasses, TypeApplications, LambdaCase #-}
-- ^^^ Needed for defining custom MultiToggle Transformers 

module XMonadCommon where

import qualified Data.Map        as M
import Data.Ratio
import System.Exit

-- hiding ||| to use JumpToLayout
import XMonad
import XMonad.Operations
import XMonad.Core
import qualified XMonad.StackSet as W

import XMonad.Util.EZConfig
import XMonad.Util.Ungrab
import XMonad.Util.WorkspaceCompare
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.WorkspaceHistory (workspaceHistoryHook)
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Grid
import XMonad.Layout.Renamed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.IfMax
import XMonad.Layout.PerWorkspace
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.MultiToggle
import XMonad.Layout.Accordion
import XMonad.Layout.Master
import XMonad.Prompt
import XMonad.Prompt.Window
import XMonad.Actions.SpawnOn
import XMonad.Actions.CycleWS
import XMonad.Actions.RotSlaves
import XMonad.Actions.CycleWindows
import XMonad.Actions.UpdatePointer
import XMonad.Actions.Warp
import XMonad.Actions.GridSelect
import XMonad.Actions.CycleRecentWS
import XMonad.Actions.CycleWorkspaceByScreen
import XMonad.Actions.OnScreen
import XMonad.Actions.FindEmptyWorkspace
import XMonad.Actions.WindowBringer
import XMonad.Actions.WorkspaceNames
import XMonad.Actions.DynamicWorkspaceGroups
import XMonad.Actions.LinkWorkspaces
import XMonad.Actions.EasyMotion (selectWindow)
import qualified XMonad.Util.ExtensibleState as XS
import qualified XMonad.Util.Paste as XP


--- https://www.reddit.com/r/xmonad/comments/8xrmki/is_there_a_way_to_temporarily_disable_keybindings/
data KeysToggle = KeysEnabled | KeysDisabled deriving Typeable

instance ExtensionClass KeysToggle where
  initialValue = KeysEnabled

makeToggleable :: KeySym -> (XConfig Layout -> M.Map (KeyMask, KeySym) (X ())) -> XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
makeToggleable togSym origKeys conf =
  M.insert (modMask conf, togSym) toggleKeys $ M.mapWithKey ifKeys (origKeys conf)
  where

    ifKeys :: (KeyMask, KeySym) -> X () -> X ()
    ifKeys (km, ks) act = XS.get @KeysToggle >>= \case
      KeysEnabled -> act
      KeysDisabled -> XP.sendKey km ks

    toggleKeys :: X ()
    toggleKeys = XS.modify @KeysToggle $ \case
      KeysEnabled -> KeysDisabled
      KeysDisabled -> KeysEnabled
------------------------------------------------------------------------------------------------------

-- main functions to be called from xmonad.hs
mainDesktop :: IO()
mainDesktop = xmonad . withSB mySBDesktop . workspaceNamesEwmh . ewmh . docks $ myConfigDesktop
mySBDesktop = statusBarProp "xmobar -x 1 ~/.xmobar/xmobar-desktop-0.config" (workspaceNamesPP myXmobarPP)

mainThinkpad :: IO()
mainThinkpad = xmonad . withSB (mySBThinkpad0 <> mySBThinkpad1) . workspaceNamesEwmh . ewmh . docks $ myConfigThinkpad
mySBThinkpad0 = statusBarProp "xmobar -x 0 /home/patrick/.xmobar/xmobar-thinkpad-0.config" (workspaceNamesPP myXmobarPP)
mySBThinkpad1 = statusBarProp "xmobar -x 0 /home/patrick/.xmobar/xmobar-thinkpad-1.config" (workspaceNamesPP def) 

-- projects = workspaces with default applications on them
--myProjectsDesktop = dynamicProjects (projects myTerminalWrapperDesktop) myConfigDesktop
--myProjectsThinkpad = dynamicProjects (projects myTerminalWrapperThinkpad) myConfigThinkpad

-- compile config for either desktop or thinkpad
myConfigDesktop = myConfig mod1Mask myTerminalDesktop myTerminalWrapperDesktop 
myConfigThinkpad = myConfig mod4Mask myTerminalThinkpad myTerminalWrapperThinkpad  

-- configs that differ
myTerminalDesktop = "alacritty"
myTerminalThinkpad = "sakura"
myFileManager = "ranger"
myCalendar = "/home/patrick/s/calcurse-autosync.sh"

-- wrapper for starting applications that run inside the terminal
myTerminalWrapperThinkpad title command = myTerminalThinkpad ++ " -e " ++ command
myTerminalWrapperDesktop title command = myTerminalDesktop ++ " -t " ++ title ++ " -e " ++ command

-- tags for the project workspaces
-- workspaceTagSystem = "s"
-- workspaceTagCommunication = "c"
myWorkspaces = map show [1..9 :: Int]

-- folder to store screenshots with scrot
screenshotPath = "/home/patrick/screenshots"

-- keybindings given in Emacs format for Utils.EZConfig
keysSourceP myTerminal terminalWrapper myModMask = [
        -- Move windows across workspaces
        ("M-`", shiftNextScreen >> nextScreen ) -- move applications to the next screen
      , ("M-S-`", shiftPrevScreen >> prevScreen ) -- move applications to the previous screen
      , ("M-S-f", tagToEmptyWorkspace)

        -- move windows inside the current workspace
      , ("M-d", windows W.swapMaster) -- swap window with the master window
      , ("M-<Return>", windows W.swapMaster) -- swap window with the master window
      , ("M-i", rotAllDown) -- rotate the windows in the current workspace
      , ("M-o", rotAllUp) -- rotate the windows in the current workspace
      --, ("M-S-s", rotAllDown) -- for one-handed access
      --, ("M-S-d", rotAllUp) -- for one-handed access
      , ("M-S-i", rotUnfocusedDown) -- rotate the unfocused windows 
      , ("M-S-o", rotUnfocusedUp)  -- rotate the unfocused windows 
      , ("M-S-j", windows W.swapDown) -- swap window with the master window
      , ("M-S-k", windows W.swapUp) -- swap window with the master window

        -- move foxus
      , ("M-j", windows W.focusDown) -- swap window with the master window
      , ("M-k", windows W.focusUp) -- swap window with the master window
      , ("M-m", windows W.focusMaster) -- swap window with the master window

        -- spawn applications
      , ("M-S-g", unGrab *> (spawn $ "cd " ++ screenshotPath ++ "; scrot -s " )    ) -- screenshot (selection)
      , ("M-g", unGrab *> (spawn $ "cd " ++ screenshotPath ++ "; scrot"     )) -- screenshot (whole screen)
      , ("M-v", spawn "firefox") -- start firefox
      , ("M-<Space>", spawn "gmrun")
      , ("M-p", spawn "gmrun") -- gmrun instead of dmenu
      , ("M-S-p", spawn "gmrun")
      , ("M-S-c", kill)
      , ("M-S-z", spawn "systemctl suspend") -- suspend
      , ("M-<Escape>", spawn myTerminal) -- spawn a terminal
      , ("M-S-<Return>", spawn myTerminal) -- spawn a terminal
      , ("M-S-<Escape>", spawn $ terminalWrapper myFileManager myFileManager) -- spawn ranger

        -- other things
      , ("M-<F4>", kill) -- enable usual Alt-F4 for killing 
      , ("M-y", spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi") -- move recompile key to y to use q for something that is used more often
      , ("M-S-y", io (exitWith ExitSuccess)) -- move exit key to shift-y to free up q
      , ("M-<F5>", windowPrompt def Goto allWindows) -- not working...
      , ("M-S-t", banish LowerLeft) -- move the cursor out of the way
      , ("M-S-m", refresh)

        -- EasyMotion
      , ("M-h", selectWindow def >>= (`whenJust` windows . W.focusWindow))
      , ("M-S-x", selectWindow def >>= (`whenJust` windows . W.focusWindow))

        -- switching workspaces
      , ("M-<Tab>", cycleWS' myModMask)
      , ("M-S-<Tab>", windows W.focusDown)
      , ("M-c", (sendMessage $ Toggle MYMIRROR) >> (multiSpawn ["telegram-desktop", "thunderbird", "element-desktop", terminalWrapper "Treetasks" "python /home/patrick/treetasks/treetasks.py"]))
      , ("M-l", gotoMenu) -- show dmenu to quickly move to a currently open window by title (WindowBringer)
      , ("M-f", viewEmptyWorkspace)
      , ("M-b", renameWorkspace def)
      , ("M-S-v", sendMessage ToggleStruts)

      -- DynamicWorkspaceGroups
      , ("M-S-b", promptWSGroupForget def "Forget ")
      , ("M-S-n", promptWSGroupAdd def "Add to ")
      , ("M-n", promptWSGroupView def "Go to ")

        -- changing layout properties
      , ("M-S-h", sendMessage Shrink) -- %! Shrink the master area
      , ("M-S-l", sendMessage Expand) -- %! Expand the master area
      , ("M-x", sendMessage (IncMasterN (-1))) -- decrease/increase the number of windows in the master pane
      , ("M-z", sendMessage (IncMasterN 1))
      , ("M-.", sendMessage (IncMasterN (-1))) -- decrease/increase the number of windows in the master pane
      , ("M-,", sendMessage (IncMasterN 1))
      , ("M-s", sendMessage $ Toggle MYMIRROR) -- toggle mirrored layout
      , ("M-a" , sendMessage $ Toggle MYFULL) -- toggle fullscreen layout
      , ("M-S-a", sendMessage $ JumpToLayout "0T")
      , ("M-S-s", sendMessage $ JumpToLayout "0G")
      , ("M-S-d", sendMessage $ JumpToLayout "0A")
      , ("M-t", withFocused $ windows . W.sink )

      -- keybindings for LinkWorkspaces
      -- , ("M-S-b", toggleLinkWorkspaces message)
      -- , ("M-S-v", removeAllMatchings message)
      ]

-- keybindings generated as list comprehensions
keysSource myModMask = 
      [((m .|. myModMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_q, xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (shiftAndView, shiftMask)]]
      ++ 
      [((m .|. myModMask, k), windows $ f i)
        | (i, k) <- zip (myWorkspaces) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    -- keybindings for LinkWorkspaces
    -- [ ((myModMask .|. m, k), a i)
    -- | (a, m) <- [(switchWS (\y -> windows $ W.view y) message, 0),(switchWS (\x -> windows $ W.shift x . W.view x) message, shiftMask)]
    --  , (i, k) <- zip (XMonad.workspaces def) [xK_1 .. xK_9]]

    -- no idea what this is for
    -- ++ [((shiftMask .|. myModMask, key), windows $ greedyViewOnScreen sc (W.currentTag $ gets windowset))
    --    | (key, sc) <- zip [xK_q, xK_w, xK_e, xK_r] [0..]]

-- similar to Utils.EZConfig additionalKeys but for adding keys to a
-- XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
-- instead of a config
addKeys keys keyList = \c -> M.union (M.fromList keyList) (keys c)

-- generate a keymap (XConfig Layout -> M.Map (KeyMask, KeySym) (X ()))
-- from a list of keys (like additionalKeysP)
myKeysP myTerminal terminalWrapper myModMask c = mkKeymap c $ keysSourceP myTerminal terminalWrapper myModMask

-- add the emacs-style generated keymap and the list comprehension classic keybindings
-- together in one function
myKeys myTerminal terminalWrapper myModMask = addKeys (myKeysP myTerminal terminalWrapper myModMask) (keysSource myModMask)

-- make the keys toggleable (with xK_u) (from: https://www.reddit.com/r/xmonad/comments/8xrmki/is_there_a_way_to_temporarily_disable_keybindings/)
myToggleableKeys myTerminal terminalWrapper myModMask = makeToggleable xK_u $ myKeys myTerminal terminalWrapper myModMask

-- the main config (as function to dynamically set the terminal-dependent stuff)
myConfig myModMask myTerminal terminalWrapper = def
    { focusedBorderColor = "#AAAAAA"
    , modMask = myModMask
    , normalBorderColor = "#000000"
    , borderWidth = 1
    , layoutHook = myLayoutHook'
    , manageHook = myManageHook
    , focusFollowsMouse = True
    --, workspaces =  map show [1..9] -- project workspaces c and s are automatically added
    , terminal = myTerminal
    , logHook = updatePointer (0.5, 0.5) (0, 0) >> workspaceHistoryHook -- move pointer to the center if a window is focused, historyHook for cycleWOrkspaceByScreen
    , keys = myToggleableKeys myTerminal terminalWrapper myModMask
    }

-- LinkWorkspaces Message config
message_command (S screen) = " dzen2 -p 1 -w 300 -xs " ++ show (screen + 1)
message_color_func c1 c2 msg = dzenColor c1 c2 msg
message' screen c1 c2 msg = spawn $ "echo '" ++ (message_color_func c1 c2 msg) ++ "' | " ++ message_command screen
message = MessageConfig { messageFunction = message'
          , background = "#000000"
          , alertedForeground = "#ff7701"
          , foreground = "#00ff00" }
    
--getCurrentScreen :: ScreenId
--getCurrentScreen = head $ (W.screen . W.current) `fmap` gets windowset

--greedyMove :: ScreenId -> WorkspaceId -> W.StackSet WorkspaceId (Layout Window) Window ScreenId ScreenDetail -> W.StackSet WorkspaceId (Layout Window) Window ScreenId ScreenDetail
--greedyMove sc wid = greedyViewOnScreen sc (W.currentTag $ gets windowset)

--startConversations = Just $ do
--    spawn "telegram-desktop"
--    spawn "thunderbird"

multiSpawn :: [String] -> X()
multiSpawn (x:xs) = spawn x >> multiSpawn xs
multiSpawn (x:[]) = spawn x

-- cycle recent workspaces function call, bind to both the forward and backward keybinding
-- cycleWS' = cycleWorkspaceOnCurrentScreen [xK_Alt_L, xK_Shift_L] xK_a xK_Escape
cycleWS' :: KeyMask -> X()
cycleWS' 8 = cycleWorkspaceOnCurrentScreen [xK_Alt_L] xK_Tab xK_n
cycleWS' 64 = cycleWorkspaceOnCurrentScreen [xK_Super_L] xK_Tab xK_n

-- combination of W.shift and W.view to enable moving windows to other screens while keeping them focused
shiftAndView :: WorkspaceId -> W.StackSet WorkspaceId (Layout Window) Window ScreenId ScreenDetail -> W.StackSet WorkspaceId (Layout Window) Window ScreenId ScreenDetail
shiftAndView i s1 = W.view i s2 
    where
        s2 = W.shift i s1

-- define the projects to have some default workspaces at hand
--projects :: ([Char] -> [Char] -> [Char]) -> [Project]
--projects terminalWrapper = [projectCommunication terminalWrapper, projectSystem terminalWrapper]

-- a project for communication applications
--projectCommunication terminalWrapper = Project { projectName = w
--                   , projectDirectory = "/home/patrick"
--                   , projectStartHook = Just $ do 
--                        spawnOn w "telegram-desktop"
--                        spawnOn w "thunderbird"
--                        spawnOn w $ terminalWrapper "calcurse" myCalendar
--                   }
--    where
--        w = workspaceTagCommunication

-- a project for system settings and monitoring
--projectSystem terminalWrapper = Project { projectName = w
--                   , projectDirectory = "/home/patrick"
--                   , projectStartHook = Just $ do 
--                        spawnOn w "nvidia-settings"
--                        spawnOn w $ terminalWrapper "top" "top -o %CPU"
--                        spawnOn w $ terminalWrapper "alsamixer" "alsamixer"
--                   }
--    where
--        w = workspaceTagSystem

-- automatically float dialogs, gimp, and telegram media viewer
myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "Gimp" --> doFloat
    , title =? "Media viewer" --> doFloat
    , isDialog --> doFloat
    ]

-- Get the name of the active layout.
-- https://churchman.nl/2019/06/17/xmonad-per-layout-keybindings/
--
--getActiveLayoutDescription :: X String
--getActiveLayoutDescription = do
--    workspaces <- gets windowset
--    return $ description . W.layout . W.workspace . W.current $ workspaces
--
-- Trying to switch different layouts, not working
--switchTwoLayouts layoutDescr1 layoutDescr2 = do
--    currentLayout <- getActiveLayoutDescription
--    if currentLayout == layoutDescr1
--        then sendMessage $ JumpToLayout layoutDescr2
--        else sendMessage $ JumpToLayout layoutDescr1

-- define the default layout parameters
layoutNMaster = 1
layoutRatio = 1/2
layoutDelta = 3/100
layoutGridRatio = (1/1)
layoutDescrFS = "FS"
layoutDescrPrefixMirror = "M"

-- define a new transformer that resembles the ones in XMonad.Layout.MultiToggle.Instances
-- to provide sensible description modifications
data MyTransformers = MYFULL
                    | MYMIRROR
    deriving (Read, Show, Eq, Typeable)

instance Transformer MyTransformers Window where
    transform MYFULL x k = k (renamed [Replace layoutDescrFS] Full) (const x)
    transform MYMIRROR x k = k (renamed [CutWordsLeft 1, CutLeft 1, Prepend layoutDescrPrefixMirror] (Mirror x)) (const x) 

-- layout hook, enables MultiToggle of fullscreen and mirroring and defines the used base layouts
myLayoutHook = id
    . mkToggle (NOBORDERS ?? MYFULL ?? EOT)
    . mkToggle (single MYMIRROR)
    $ layoutTall ||| layoutGrid ||| layoutAccordion 

myLayoutHook' = avoidStruts myLayoutHook


-- define the used layouts
layoutTall = rename "T" $ Tall layoutNMaster layoutDelta layoutRatio
layoutGrid = rename "G" $ ifMax 1 Full ( multimastered layoutNMaster layoutDelta layoutRatio $ GridRatio layoutGridRatio )
layoutAccordion = rename "A" $ FixedAccordion 12

rename s l = renamed [Replace $ "0" ++ s] l

-- old code to handle default layouts on the project workspaces, not really useful
    --
    --myLayoutHook = onWorkspace workspaceTagCommunication (myLayoutWide ||| myLayoutTall) $
    --               onWorkspace workspaceTagSystem (myLayoutTall ||| myLayoutWide) $
    --               myLayoutGeneral

    --myLayoutGeneral = myLayoutTall ||| myLayoutWide ||| renamed [Replace "F"] Full ||| renamed [Replace "G"] Grid

    --myLayoutWide = renamed [Replace "H"] $ Mirror myLayoutTall

-- Custom Accordion

data FixedAccordion a = FixedAccordion Int deriving ( Read, Show )

instance LayoutClass FixedAccordion Window where
    pureLayout = fixedAccordionLayout
    pureMessage = fixedAccordionMessage

fixedAccordionLayout :: FixedAccordion a -> Rectangle -> W.Stack a -> [(a, Rectangle)]
fixedAccordionLayout (FixedAccordion factor) sc ws = zip ups tops ++ [(W.focus ws, mainPane)] ++ zip dns bottoms
    where
        ups    = reverse $ W.up ws
        dns    = W.down ws
        lups   = length ups
        ldns   = length dns
        lall   = lups + ldns + factor
        (top,  allButTop) = splitVerticallyBy (lups%lall :: Ratio Int) sc
        (center,  bottom) = splitVerticallyBy (factor%(factor + ldns) :: Ratio Int) allButTop
        (allButBottom, _) = splitVerticallyBy ((lups + factor)%lall :: Ratio Int) sc
        mainPane | lups /= 0 && ldns /= 0 = center
                 | lups /= 0              = allButTop
                 | ldns /= 0              = allButBottom
                 | otherwise              = sc
        tops    = if lups /= 0 then splitVertically (lups) top    else []
        bottoms = if ldns /= 0 then splitVertically (ldns) bottom else []

fixedAccordionMessage :: FixedAccordion a -> SomeMessage -> Maybe (FixedAccordion a)
fixedAccordionMessage (FixedAccordion factor) m = fmap resize (fromMessage m)
    where
        resize Shrink = FixedAccordion (factor - 1)
        resize Expand = FixedAccordion (factor + 1)

-- xmobar config of the xmonad-related information
myXmobarPP :: PP
myXmobarPP = def
      { ppSep             = red (" | ")
      , ppTitleSanitize   = ppWindow . xmobarStrip -- limit the window title to 50 characters
      , ppLayout          = yellow . wrap "" (red " | ")
      , ppCurrent         = white . wrap (red "[") (red "]")
      , ppHidden          = lowWhite . wrap " " ""
      --, ppHiddenNoWindows = lowWhite . wrap " " ""
      , ppUrgent          = red . wrap (yellow "!") (yellow "!")
      , ppSort            = getSortByXineramaRule
      , ppOrder           = \[ws, l, cw] -> [cw, ws, l] -- ordering of the title, workspaces and layout descriptions
      --, ppExtras          = [logTitles formatFocused formatUnfocused]
      }
    where
      --formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
      --formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

      -- | Windows should have *some* title, which should not not exceed a
      -- sane length.
      ppWindow :: String -> String
      ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 50

      blue, lowWhite, magenta, red, white, yellow :: String -> String
      magenta  = xmobarColor "#ff79c6" ""
      blue     = xmobarColor "#bd93f9" ""
      white    = xmobarColor "#f8f8f2" ""
      yellow   = xmobarColor "#f1fa8c" ""
      red      = xmobarColor "#ff5555" ""
      lowWhite = xmobarColor "#bbbbbb" ""
