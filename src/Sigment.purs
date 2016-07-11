module Sigment where

import Prelude
import Control.Monad.Eff.Ref (REF, Ref, readRef, writeRef, newRef)
import Control.Monad.Eff (Eff)
import Data.Maybe (Maybe(..), maybe)
import Sigment.Core (Config, updateStage, requestAnimationFrame, initSigment)
import Sigment.Dom as D

type EvalResult state eff = Eff eff state
type Dispatch a eff = a -> Eff eff Unit
type Eval a state eff = a -> state -> Dispatch a eff -> EvalResult state eff
type PureEval a state = a -> state -> state

type Render a state eff = Maybe a -> state -> Dispatch a eff -> D.Node
type Init i state eff = i -> Eff eff state

type Component i a state eff = {
  init :: Init i state eff,
  eval :: Eval a state eff,
  render :: Render a state eff
}

pureEval :: forall a state eff. PureEval a state -> Eval a state eff
pureEval eval a s d = pure $ (eval a s)

newComponent :: forall i a state eff. Init i state eff -> Eval a state eff -> Render a state eff -> Component i a state eff
newComponent = {init:_, eval:_, render:_}

defConfig :: forall a. Config a
defConfig = {
  sprites: [],
  width: 800,
  height: 600,
  frameAction : Nothing,
  containerId : "",
  backgroundColor : "000000",
  initAction : Nothing
}

init :: forall i state a eff. Config a -> i -> Component i a state (ref :: REF | eff) -> Eff (ref :: REF | eff) (a -> Eff (ref :: REF | eff) Unit)
init config initParam component = do
  initState <- (component.init initParam)
  stateRef <- newRef initState
  let dispatch = updateStateRef stateRef component.eval component.render
  initSigment dispatch map config
    (config.initAction # maybe (updateStage (component.render Nothing initState dispatch)) dispatch)
  pure $ dispatch

updateStateRef :: forall state a eff. Ref state -> Eval a state (ref :: REF | eff) -> Render a state (ref :: REF | eff) -> a -> Eff ( ref :: REF | eff) Unit
updateStateRef stateRef eval render action = do
  oldState <- readRef stateRef
  let dispatch = updateStateRef stateRef eval render
  let dispatchNextFrame a = requestAnimationFrame (dispatch a)
  result <- eval action oldState dispatchNextFrame
  writeRef stateRef result
  newState <- readRef stateRef
  let vNode = render (Just action) newState dispatch
  updateStage vNode

