module Sigment.Subcomponents where
import Sigment.Dom as D
import Sigment.Dom.Props as P
import Control.Monad.Eff.Ref
import Control.Monad.Eff
import Sigment.Core
import Data.Tuple
import Data.Maybe
import Prelude
import Data.Array
import Data.Array.Unsafe as U
import Sigment

type Accessor key a s subA subS = {
  actionUnwrap :: a -> Maybe subA,
  actionWrap :: key -> subA -> a,
  stateGet :: key -> s -> Maybe subS,
  stateSet :: key -> Maybe s -> subS -> s
}

newAccessor actionUnwrap actionWrap stateGet stateSet = {actionUnwrap, actionWrap, stateGet, stateSet}

type Subcomponent i a s eff = {
  init :: i -> Eff eff s,
  eval :: a -> s -> Dispatch a eff -> Eff eff s,
  render :: Maybe a -> s -> Dispatch a eff -> Maybe D.Node
}

type SubcomponentER a s eff = {
  eval :: a -> s -> Dispatch a eff -> Eff eff s,
  render :: Maybe a -> s -> Dispatch a eff -> Maybe D.Node
}

toER :: forall i a s eff. Subcomponent i a s eff -> SubcomponentER a s eff
toER meta = {eval : meta.eval, render : meta.render}

newSubcomponent3 init eval render = {init, eval, render}
type SubcomponentData key i a s subA subS eff = {
  component :: Component i subA subS eff,
  accessor :: Accessor key a s subA subS
}

newSubcomponent :: forall i a s subA subS eff. Component i subA subS eff -> Accessor Unit a s subA subS -> Subcomponent i a s eff
newSubcomponent component accessor =
  newSubcomponent3 (\i -> initSubcomponent i subData) (evalSubcomponent subData) (renderSubcomponent subData)
  where
    subData = {component, accessor}

type SubcomponentWithKey key a s eff = {
  eval :: key -> a -> s -> Dispatch a eff -> Eff eff s,
  render :: key -> Maybe a -> s -> Dispatch a eff -> Maybe D.Node
}

newSubcomponentWithKey :: forall key i a s subA subS eff. Component i subA subS eff -> Accessor key a s subA subS -> SubcomponentWithKey key a s eff
newSubcomponentWithKey component accessor =
  {eval : \key -> evalSubcomponentWithKey key subData, render : \key -> renderSubcomponentWithKey key subData}
  where
    subData = {component, accessor}

initSubcomponent :: forall i a s subA subS eff. i -> SubcomponentData Unit i a s subA subS eff -> Eff eff s
initSubcomponent initParam subcomponent = do
  initState <- subcomponent.component.init initParam
  pure $ acc.stateSet unit Nothing initState
  where
    acc = subcomponent.accessor

evalSubcomponents :: forall a m eff. Array (SubcomponentER a m eff) -> a -> m -> Dispatch a eff -> Eff eff m
evalSubcomponents subcomponents action state dispatch =
  foldM (\acc subcomponent -> subcomponent.eval action acc dispatch) state subcomponents

renderSubcomponents :: forall a m eff. Array (SubcomponentER a m eff) -> Maybe a -> m -> Dispatch a eff -> D.Node
renderSubcomponents subcomponents action state dispatch =
  if null subcomponents then D.empty
  else
    fromMaybe' (\_ -> renderSubcomponents (U.tail subcomponents) action state dispatch) node
    where
      node = (U.head subcomponents).render action state dispatch

evalSubcomponent = evalSubcomponentWithKey unit

evalSubcomponentWithKey :: forall key i a s subA subS eff. key -> SubcomponentData key i a s subA subS eff -> a -> s -> Dispatch a eff -> Eff eff s
evalSubcomponentWithKey key subcomponent action state dispatch = fromMaybe (pure state) do
  act <- acc.actionUnwrap action
  st <- acc.stateGet key state
  pure do
    x <- subcomponent.component.eval act st (\x -> dispatch (acc.actionWrap key x)) 
    pure (acc.stateSet key (Just state) x)
  where
    acc = subcomponent.accessor

renderSubcomponent = renderSubcomponentWithKey unit

renderSubcomponentWithKey :: forall key i a s subA subS eff. key -> SubcomponentData key i a s subA subS eff -> Maybe a -> s -> Dispatch a eff -> Maybe D.Node
renderSubcomponentWithKey key subcomponent action state dispatch = do
  st <- acc.stateGet key state
  pure $ render (action >>= acc.actionUnwrap) st (\x -> dispatch (acc.actionWrap key x))
  where
    acc = subcomponent.accessor
    render = subcomponent.component.render
