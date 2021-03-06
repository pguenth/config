{-# LANGUAGE TypeSynonymInstances, DeriveDataTypeable, MultiParamTypeClasses, TypeApplications, LambdaCase #-}
-- ^^^ Needed for defining custom MultiToggle Transformers 

module XMonadCommon where

import qualified Data.Map        as M
import Data.Ratio
import Data.List
import Data.IORef
import System.Exit

-- hiding ||| to use JumpToLayout
import XMonad
import XMonad.Prelude
import XMonad.Operations
import XMonad.Core
import qualified XMonad.StackSet as W

import XMonad.Util.EZConfig
import XMonad.Util.Ungrab
import XMonad.Util.WorkspaceCompare
import XMonad.Util.NamedScratchpad
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.WorkspaceHistory -- (workspaceHistoryHookExclude)
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.RefocusLast (refocusLastLogHook)
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
import XMonad.Actions.EasyMotion 
import XMonad.Actions.Promote
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.Submap
import XMonad.Actions.DynamicProjects
import XMonad.Hooks.InsertPosition
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
mainDesktop = xmonad . withSB mySBDesktop . workspaceNamesEwmh . ewmh . docks $ myProjectsDesktop
mySBDesktop = statusBarProp "xmobar -x 1 ~/.xmobar/xmobar-desktop-0.config" (workspaceNamesPP myXmobarPP)

mainLatitude :: IO()
mainLatitude = xmonad . withSB mySBLatitude . workspaceNamesEwmh . ewmh . docks $ myProjectsLatitude
mySBLatitude = statusBarProp "~/.local/bin/xmobar -x 0 ~/.xmobar/xmobar-latitude.config" (workspaceNamesPP myXmobarPP)

mainThinkpad :: IO()
mainThinkpad = xmonad . withSB (mySBThinkpad0 <> mySBThinkpad1) . workspaceNamesEwmh . ewmh . docks $ myProjectsThinkpad
mySBThinkpad0 = statusBarProp "xmobar -x 0 /home/patrick/.xmobar/xmobar-thinkpad-0.config" (workspaceNamesPP myXmobarPP)
mySBThinkpad1 = statusBarProp "xmobar -x 0 /home/patrick/.xmobar/xmobar-thinkpad-1.config" (workspaceNamesPP def) 

-- projects = workspaces with default applications on them
myProjectsDesktop = dynamicProjects (projects myTerminalWrapperDesktop) myConfigDesktop
myProjectsLatitude = dynamicProjects (projects myTerminalWrapperDesktop) myConfigLatitude
myProjectsThinkpad = dynamicProjects (projects myTerminalWrapperThinkpad) myConfigThinkpad

-- compile config for either desktop or thinkpad
myConfigDesktop = myConfig mod1Mask myTerminalDesktop myTerminalWrapperDesktop 
myConfigLatitude = myConfig mod1Mask myTerminalDesktop myTerminalWrapperDesktop 
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

xpfont = "SourceCodePro-9:style=Bold"

xpconf :: XPConfig
xpconf = def { bgColor = "#000000", font = "xft:" ++ xpfont }

dmenuArgs = ["-b", "-fn", xpfont, "-i"]

emconf :: EasyMotionConfig
emconf = def {
    txtCol = "#A6200A"
  , cancelKey = xK_Escape
  , emFont = "xft:SourceCodePro-35:style=Bold"
  , sKeys = AnyKeys [xK_a, xK_s, xK_d, xK_f, xK_g, xK_h, xK_j, xK_k, xK_l]
  , overlayF = textSize
}

scratchpadPadding = 1/20
scratchpadSize = 1 - 2 * scratchpadPadding
scratchpadLayout = customFloating $ W.RationalRect scratchpadPadding scratchpadPadding scratchpadSize scratchpadSize
scratchpads terminalWrapper = [
        NS "bpytop" (terminalWrapper "bpytop" "bpytop") (title =? "bpytop") scratchpadLayout
      , NS "term" (terminalWrapper "scratch-term" "xonsh") (title =? "scratch-term") scratchpadLayout
      , NS "ranger" (terminalWrapper "ranger-term" "ranger") (title =? "ranger-term") scratchpadLayout
      --, NS "element" "element-desktop" (className =? "Element") scratchpadLayout
      --, NS "telegram" "telegram-desktop" (className =? "TelegramDesktop") scratchpadLayout
      --, NS "thunderbird" "thunderbird" (className =? "Thunderbird") scratchpadLayout
    ]

myHiddenWS = ["NSP"] ++ allProjectNames


-- keybindings given in Emacs format for Utils.EZConfig
keysSourceP myTerminal terminalWrapper myModMask = [
        -- Move windows across workspaces
        ("M-`", shiftNextScreen >> nextScreen ) -- move applications to the next screen
      , ("M-S-`", shiftPrevScreen >> prevScreen ) -- move applications to the previous screen
      , ("M-S-t", tagToEmptyWorkspace)

        -- move windows inside the current workspace
      , ("M-d", promote) -- swap window with the master window
      , ("M-<Return>", windows W.swapMaster) -- swap window with the master window
      , ("M-o", rotAllDown) -- rotate the windows in the current workspace
      , ("M-i", rotAllUp) -- rotate the windows in the current workspace
      --, ("M-S-s", rotAllDown) -- for one-handed access
      --, ("M-S-d", rotAllUp) -- for one-handed access
      , ("M-S-i", rotUnfocusedDown) -- rotate the unfocused windows 
      , ("M-S-o", rotUnfocusedUp)  -- rotate the unfocused windows 
      , ("M-c", windows W.focusMaster >> rotUnfocusedUp >> windows W.focusDown)  -- rotate the unfocused windows 
      , ("M-S-j", windows W.swapDown) -- swap window with the master window
      , ("M-S-k", windows W.swapUp) -- swap window with the master window
      , ("M-S-z", windows W.swapDown) -- swap window with the master window
      , ("M-S-x", windows W.swapUp) -- swap window with the master window

        -- move foxus
      , ("M-j", windows W.focusDown) -- swap window with the master window
      , ("M-k", windows W.focusUp) -- swap window with the master window
      , ("M-z", windows W.focusDown) -- swap window with the master window
      , ("M-x", windows W.focusUp) -- swap window with the master window
      , ("M-m", windows W.focusMaster) -- swap window with the master window

        -- spawn applications
      , ("M-g", unGrab *> (spawn $ "cd " ++ screenshotPath ++ "; scrot -s " )    ) -- screenshot (selection)
      , ("M-S-g", unGrab *> (spawn $ "cd " ++ screenshotPath ++ "; scrot"     )) -- screenshot (whole screen)
      , ("M-v", spawn "firefox") -- start firefox
      , ("M-<Space>", spawn "gmrun")
      , ("M-p", spawn "gmrun") -- gmrun instead of dmenu
      , ("M-S-p", spawn "gmrun")
      , ("M-S-c", kill)
      , ("M-y", spawn "systemctl suspend") -- suspend
      , ("M-<Escape>", spawn myTerminal) -- spawn a terminal
      , ("M-S-<Return>", spawn myTerminal) -- spawn a terminal
      , ("M-S-<Escape>", spawn $ terminalWrapper myFileManager myFileManager) -- spawn ranger

        -- other things
      , ("M-<F4>", kill) -- enable usual Alt-F4 for killing 
      , ("M-<F7>", spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi") -- move recompile key to F7 to use q for something that is used more often
      , ("M-<F8>", submap $ M.fromList [ ((myModMask, xK_F8), io (exitWith ExitSuccess)) ] ) -- move exit key to F8 to free up q
      , ("M-<F1>", windowPrompt xpconf Goto allWindows) -- not working...
      , ("M-<F2>", goToSelected def) 
      -- , ("M-S-t", banish LowerLeft) -- move the cursor out of the way
      , ("M-S-m", spawn "killall -SIGUSR1 xmobar")

        -- EasyMotion
      , ("M-l", selectWindow emconf >>= (`whenJust` windows . W.focusWindow))
      , ("M-S-f", selectWindow emconf >>= (`whenJust` windows . W.focusWindow))

        -- switching workspaces
      , ("M-<Tab>", cycleWS' myModMask)
      , ("M-S-<Tab>", windows W.focusDown)
      --, ("M-c", (sendMessage $ Toggle MYMIRROR) >> (multiSpawn ["telegram-desktop", "thunderbird", "element-desktop", terminalWrapper "Treetasks" "python /home/patrick/treetasks/treetasks.py"]))
      , ("M-h", gotoMenuConfig $ def { menuArgs = dmenuArgs } ) -- show dmenu to quickly move to a currently open window by title (WindowBringer)
      , ("M-t", viewEmptyWorkspace)
      , ("M-n", renameWorkspace xpconf )
      , ("M-<F6>", sendMessage ToggleStruts)

      -- DynamicWorkspaceGroups
      , ("M-S-n", promptWSGroupForget xpconf "Forget ")
      , ("M-S-b", promptWSGroupAdd xpconf "Add to ")
      , ("M-b", promptWSGroupView xpconf "Go to ")

        -- changing layout properties
      , ("M-S-h", sendMessage Shrink) -- %! Shrink the master area
      , ("M-S-l", sendMessage Expand) -- %! Expand the master area
      --, ("M-x", sendMessage (IncMasterN (-1))) -- decrease/increase the number of windows in the master pane
      --, ("M-z", sendMessage (IncMasterN 1))
      , ("M-.", sendMessage (IncMasterN (-1))) -- decrease/increase the number of windows in the master pane
      , ("M-,", sendMessage (IncMasterN 1))
      , ("M-f", namedScratchpadAction (scratchpads terminalWrapper) "term")
      , ("M-a" , sendMessage $ Toggle MYFULL) -- toggle fullscreen layout
      , ("M-S-r", sendMessage $ Toggle MYMIRROR) -- toggle mirrored layout
      , ("M-S-a", submap $ M.fromList [ 
            ((myModMask .|. shiftMask, xK_a), sendMessage $ JumpToLayout "0T")
          , ((myModMask .|. shiftMask, xK_s), sendMessage $ JumpToLayout "0Tg")
          , ((myModMask .|. shiftMask, xK_d), sendMessage $ JumpToLayout "0Ta")
        ])
      , ("M-S-s", sendMessage $ JumpToLayout "0G")
      , ("M-S-d", sendMessage $ JumpToLayout "0A")
      , ("M-<F3>", withFocused $ windows . W.sink )
      -- , ("M-s", submap $ submapOptionalModifier myModMask [ (xK_a, namedScratchpadAction (scratchpads terminalWrapper) "bpytop") ] )
      , ("M-s", submap $ M.fromList [ 
            ((myModMask, xK_t), namedScratchpadAction (scratchpads terminalWrapper) "bpytop")
          , ((myModMask, xK_a), switchProject $ projectMail terminalWrapper)
          , ((myModMask, xK_f), switchProject $ projectMessenger terminalWrapper)
        ])
      , ("M-r", namedScratchpadAction (scratchpads terminalWrapper) "ranger")

      -- select xinerama layouts stored in the default arandr directory (.screenlayout) using dmenu
      -- if there is a script ".screenlayout/.sh" it will be run as a side effect on canceling dmenu
      -- currently used to spawn arandr in that case
      , ("M-u", spawn $ "bash -c .screenlayout/$(ls .screenlayout | rev | cut -c4- | rev | dmenu " ++ (intercalate " " dmenuArgs) ++ ").sh")
      -- doesnt work, dont know why
      , ("M-S-u", spawn $ "bash -c sudo netctl-auto switch-to $(ls /etc/netctl | dmenu " ++ (intercalate " " dmenuArgs) ++ ")")

      -- keybindings for LinkWorkspaces
      -- , ("M-S-b", toggleLinkWorkspaces message)
      -- , ("M-S-v", removeAllMatchings message)
      ]

-- combination of W.shift and W.view to enable moving windows to other screens while keeping them focused
shiftAndView :: WorkspaceId -> W.StackSet WorkspaceId (Layout Window) Window ScreenId ScreenDetail -> W.StackSet WorkspaceId (Layout Window) Window ScreenId ScreenDetail
shiftAndView i s1 = W.view i s2 
    where
        s2 = W.shift i s1

-- for physicalScreens
-- shiftAndViewPhys:: WorkspaceId -> W.StackSet WorkspaceId (Layout Window) Window ScreenId ScreenDetail -> W.StackSet WorkspaceId (Layout Window) Window ScreenId ScreenDetail
shiftAndViewPhys comp physsc = sendToScreen comp physsc >> viewScreen comp physsc

-- move the currently focused workspace to the screen at which the workspace given by WorkspaceId currently is
-- used to implement workspace to screen movements
moveWStoScreen :: WorkspaceId -> W.StackSet WorkspaceId (Layout Window) Window ScreenId ScreenDetail -> W.StackSet WorkspaceId (Layout Window) Window ScreenId ScreenDetail
moveWStoScreen i s1 = W.greedyView current s2 
    where
        s2 = W.view i s1
        current = W.currentTag s1

--physScreenAction comp physsc f = (whenJust (get $ getScreen comp physsc) screenWorkspace ) >>= flip whenJust (windows . f)

physScreenAction :: (WorkspaceId -> W.StackSet WorkspaceId (Layout Window) Window ScreenId ScreenDetail -> W.StackSet WorkspaceId (Layout Window) Window ScreenId ScreenDetail) -> ScreenComparator -> PhysicalScreen -> X ()
physScreenAction f comp physsc = do i <- getScreen comp physsc
                                    whenJust i $ \s -> do
                                      w <- screenWorkspace s
                                      whenJust w $ windows . f

moveWStoScreenPhys comp physsc = physScreenAction moveWStoScreen comp physsc 

-- keybindings generated as list comprehensions
keysSource myModMask = 
-- w/o physicalScreens [((m .|. myModMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      [((m .|. myModMask, key), f def sc)
        | (key, sc) <- zip [xK_q, xK_w, xK_e] [0..]
-- w/o physicalScreens        , (f, m) <- [(W.view, 0), (shiftAndView, shiftMask), (moveWStoScreen, controlMask), (W.greedyView, controlMask .|. shiftMask)]]
        , (f, m) <- [(viewScreen, 0), (shiftAndViewPhys, shiftMask), (physScreenAction moveWStoScreen, controlMask), (physScreenAction W.greedyView, controlMask .|. shiftMask)]]
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

-- make the keys toggleable (with shift + xK_t) (from: https://www.reddit.com/r/xmonad/comments/8xrmki/is_there_a_way_to_temporarily_disable_keybindings/)
-- (not at the moment:) the shiftMask is set in the definition of makeToggleable because I was lazy
myToggleableKeys myTerminal terminalWrapper myModMask = makeToggleable xK_F5 $ myKeys myTerminal terminalWrapper myModMask

-- the main config (as function to dynamically set the terminal-dependent stuff)
myConfig myModMask myTerminal terminalWrapper = def
    { focusedBorderColor = "#AAAAAA"
    , modMask = myModMask
    , normalBorderColor = "#000000"
    , borderWidth = 1
    , layoutHook = myLayoutHook'
    , manageHook = namedScratchpadManageHook (scratchpads terminalWrapper) <+> insertPosition Master Newer <+> myManageHook
    , focusFollowsMouse = True
    --, workspaces =  map show [1..9] -- project workspaces c and s are automatically added
    , terminal = myTerminal
    , logHook = refocusLastLogHook >> nsHideOnFocusLoss (scratchpads terminalWrapper) >> updatePointer (0.5, 0.5) (0, 0) >> workspaceHistoryHookExclude myHiddenWS -- move pointer to the center if a window is focused, historyHook for cycleWOrkspaceByScreen
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
cycleWS' 8 = cycleWorkspaceOnCurrentScreenExclude myHiddenWS [xK_Alt_L] xK_Tab xK_n
cycleWS' 64 = cycleWorkspaceOnCurrentScreenExclude myHiddenWS [xK_Super_L] xK_Tab xK_n

-- Check if the current workspace on screen ScreenId is in the given list
isWSOnScreenHidden :: [WorkspaceId] -> ScreenId -> X (Bool)
isWSOnScreenHidden hiddenWS screenId = do
  currentWSId <- screenWorkspace screenId
  return $ case currentWSId of
    Just id -> if (elem id hiddenWS) then True else False
    Nothing -> False 

-- similar to cycleWorkspaceOnScreen from XMonad.Action.CycleWorkspaceByScreen
-- but checks if the current workspace is in hiddenWS and if so goes back to the last recorded entry in the history hook
-- instead of the second-last entry
-- (the history hook is expected to ignore the same workspaces as the ones that are given here)
cycleWorkspaceOnScreenExclude :: [WorkspaceId] -> ScreenId -> [KeySym] -> KeySym -> KeySym -> X ()
cycleWorkspaceOnScreenExclude hiddenWS screenId mods nextKey prevKey = workspaceHistoryTransaction $ do
  startingHistory <- workspaceHistoryByScreen
  isHidden <- isWSOnScreenHidden hiddenWS screenId
  let cycleWorkspaces = fromMaybe [] $ lookup screenId startingHistory
  case isHidden of
    True -> (windows . W.greedyView) $ head cycleWorkspaces
    False -> cycleWorkspaceOnScreen screenId mods nextKey prevKey
  return ()


-- the following function is copied from 
-- https://hackage.haskell.org/package/xmonad-contrib-0.17.0/docs/src/XMonad.Actions.CycleWorkspaceByScreen.html#cycleWorkspaceOnScreen
-- and modified to use the *Exclude version above
cycleWorkspaceOnCurrentScreenExclude :: [WorkspaceId] -> [KeySym] -> KeySym -> KeySym -> X ()
cycleWorkspaceOnCurrentScreenExclude hiddenWS mods n p =
  withWindowSet $ \ws ->
    cycleWorkspaceOnScreenExclude hiddenWS (W.screen $ W.current ws) mods n p

-- define the projects to have some default workspaces at hand
projects :: ([Char] -> [Char] -> [Char]) -> [Project]
projects terminalWrapper = sequence projectsUnwrapped terminalWrapper

projectsUnwrapped = [projectMail, projectMessenger]

projectMail terminalWrapper = Project { projectName = w
   , projectDirectory = "/home/patrick"
   , projectStartHook = Just $ do spawnOn w "thunderbird"
} where w = "mail"

projectMessenger terminalWrapper = Project { projectName = w
   , projectDirectory = "/home/patrick"
   , projectStartHook = Just $ do
             spawnOn w "telegram-desktop"
             spawnOn w "element-desktop"
} where w = "messenger"

allProjectNames :: [ProjectName]
allProjectNames = fmap (\p -> projectName p) $ projects (\s -> (\s -> s))

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
    [ title =? "Media viewer" --> doFloat
    , isDialog --> doFloat

    -- this fixes firefox developer console tooltips that show on hovering the circled 'i' when inspecting invalid CSS.
    , isInProperty "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_UTILITY" --> doIgnore 
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
    $ layoutTall ||| layoutGrid ||| layoutAccordion ||| layoutTallGrid ||| layoutTallAccordion

myLayoutHook' = avoidStruts myLayoutHook


-- define the used layouts
layoutTall = rename "T" $ Tall layoutNMaster layoutDelta layoutRatio
layoutGrid = rename "G" $ GridRatio layoutGridRatio
layoutAccordion = rename "A" $ FixedAccordion 12
layoutTallGrid = rename "Tg" $ ifMax 1 Full ( multimastered layoutNMaster layoutDelta layoutRatio $ layoutGrid )
layoutTallAccordion = rename "Ta" $ ifMax 1 Full ( multimastered layoutNMaster layoutDelta layoutRatio $ layoutAccordion )

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
myXmobarPP = filterOutWsPP myHiddenWS myXmobarPP'
myXmobarPP' :: PP
myXmobarPP' = def
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
