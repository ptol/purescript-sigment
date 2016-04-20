module Sigment.Dom.Utils where
import Prelude
import Sigment.Dom as D
import Sigment.Dom.Props as P
import Data.Array as A

mapIndex :: forall a c. (a -> Int -> c) -> Array a -> Array c
mapIndex f a = A.zipWith f a (A.range 0 (A.length a - 1))

stackH distance = mapIndex (\x i -> D.setProps [P.x $ i * distance] x)
stackV distance = mapIndex (\x i -> D.setProps [P.y $ i * distance] x)
