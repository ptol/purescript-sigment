module Sigment.Dom where
import Sigment.Dom.Props
import Prelude
import Data.Function

foreign import data Node :: *

foreign import _createNode :: Fn3 String Props (Array Node) Node
createNode = runFn3 _createNode

group' = createNode "group"
group = group' []

text' = createNode "text" 
text props = text' props []

sprite' = createNode "sprite"
sprite props = sprite' props []

foreign import _thunk ::forall a. Fn3 String (a -> Node) a Node
thunk = runFn3 _thunk

foreign import _thunk4 ::forall a. Fn4 String (a -> Node) a (a -> a -> Boolean) Node
thunk4 = runFn4 _thunk4

foreign import _setProps :: Fn2 Props Node Node
setProps = runFn2 _setProps

foreign import empty :: Node

permanent :: String -> Node -> Node
permanent name node = thunk name (\_ -> node) true

