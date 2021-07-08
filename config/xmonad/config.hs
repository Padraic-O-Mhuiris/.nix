import XMonad
import XMonad.Util.EZConfig (additionalKeys)
  import Control.Monad (when)
  import Text.Printf (printf)
  import System.Posix.Process (executeFile)
  import System.Info (arch,os)
  import System.Environment (getArgs)
  import System.FilePath ((</>))

  compiledConfig = printf "xmonad-%s-%s" arch os

  compileRestart resume =
    whenX (recompile True) $
      when resume writeStateToFile
        *> catchIO
          ( do
              dir <- getXMonadDataDir
              args <- getArgs
              executeFile (dir </> compiledConfig) False args Nothing
          )

  main = launch defaultConfig
      { modMask = mod4Mask -- Use Super instead of Alt
      , terminal = "urxvt" }
      `additionalKeys`
      [ ( (mod4Mask,xK_r), compileRestart True)
      , ( (mod4Mask,xK_q), restart "xmonad" True ) ]

