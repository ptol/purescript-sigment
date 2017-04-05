module Sigment.Core where

import Prelude (Unit)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Uncurried (EffFn1, EffFn4, runEffFn1, runEffFn4)
import Data.Maybe (Maybe)
import Sigment.Dom (Node)

type Url = String

type Urls = Array Url

type Config a =
  { sprites :: Urls
  , width :: Int
  , height :: Int
  , backgroundColor :: String
  , frameAction :: Maybe (Number -> a)
  , containerId :: String
  , initAction :: Maybe a
  }

foreign import _initSigment :: forall eff any a. EffFn4 eff any ((a -> Unit) -> Maybe a -> Maybe Unit) (Config a) (Eff eff Unit) Unit

initSigment :: forall eff any a. any -> ((a -> Unit) -> Maybe a -> Maybe Unit) -> (Config a) -> (Eff eff Unit) -> Eff eff Unit
initSigment = runEffFn4 _initSigment

foreign import _updateStage :: forall eff. EffFn1 eff Node Unit

updateStage :: forall eff. Node -> Eff eff Unit
updateStage = runEffFn1 _updateStage

foreign import _requestAnimationFrame :: forall eff. EffFn1 eff (Eff eff Unit) Unit

requestAnimationFrame :: forall eff. (Eff eff Unit) -> Eff eff Unit
requestAnimationFrame = runEffFn1 _requestAnimationFrame
