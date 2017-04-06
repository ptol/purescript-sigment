module Sigment.Dom where

import Sigment.Dom.Props (Props)
import Data.Function.Uncurried (Fn2, Fn4, Fn3, runFn2, runFn4, runFn3)

foreign import data Node :: Type

foreign import _createNode :: Fn3 String Props (Array Node) Node

createNode :: String -> Props -> Array Node -> Node
createNode = runFn3 _createNode

group' :: Props -> Array Node -> Node
group' = createNode "group"

group :: Array Node -> Node
group = group' []

text' :: Props -> Array Node -> Node
text' = createNode "text"

text :: Props -> Node
text props = text' props []

sprite' :: Props -> Array Node -> Node
sprite' = createNode "sprite"

sprite :: Props -> Node
sprite props = sprite' props []

foreign import _thunk ::forall a. Fn3 String (a -> Node) a Node

thunk :: forall a. String -> (a -> Node) -> a -> Node
thunk = runFn3 _thunk

foreign import _thunk4 ::forall a. Fn4 String (a -> Node) a (a -> a -> Boolean) Node

thunk4 :: forall a. String -> (a -> Node) -> a -> (a -> a -> Boolean) -> Node
thunk4 = runFn4 _thunk4

foreign import _setProps :: Fn2 Props Node Node

setProps :: Props -> Node -> Node
setProps = runFn2 _setProps

foreign import empty :: Node

permanent :: String -> Node -> Node
permanent name node = thunk name (\_ -> node) true

