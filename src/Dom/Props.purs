module Sigment.Dom.Props where

import Prelude
import Control.Monad.Eff (Eff)
import Data.Function.Uncurried (Fn2, Fn4, runFn2, runFn4)

type Props = Array Prop

foreign import data Prop :: *

foreign import data Rectangle :: *

foreign import data Point :: *

foreign import none :: Prop

foreign import _createProp :: forall val. Fn2 String val Prop

createProp :: forall val. String -> val -> Prop
createProp = runFn2 _createProp

foreign import _newRectangle :: Fn4 Int Int Int Int Rectangle

newRectangle :: Int -> Int -> Int -> Int -> Rectangle
newRectangle = runFn4 _newRectangle

foreign import _newPoint :: forall a. Fn2 a a Point

newPoint :: forall a. a -> a -> Point
newPoint = runFn2 _newPoint

newPoint1 :: forall a. a -> Point
newPoint1 x' = newPoint x' x'

x :: forall a. Ring a => a-> Prop
x = createProp "x"

y :: forall a. Ring a => a-> Prop
y = createProp "y"

width :: forall a. Ring a => a-> Prop
width = createProp "width"

height :: forall a. Ring a => a-> Prop
height = createProp "height"

type KeyData eff =
  { keys :: String
  , callback :: Eff eff Unit
  , action :: String
  }

newKeys :: forall eff. String -> Eff eff Unit -> KeyData eff
newKeys keys callback = { keys, callback, action : "keydown" }

keyboard :: forall eff. Array (KeyData eff) -> Prop
keyboard = createProp "keyboard"

scale :: Point -> Prop
scale = createProp "scale"

scaleOne :: Prop
scaleOne = scale1 1.0

scaleZero :: Prop
scaleZero = scale1 0.0

scale1 :: forall a. a -> Prop
scale1 x' = scale (newPoint1 x')

scale2 :: forall a. a -> a -> Prop
scale2 x' y' = scale (newPoint x' y')

hitArea :: Rectangle -> Prop
hitArea = createProp "hitArea"

anchor :: Point -> Prop
anchor = createProp "anchor"

anchorCenter :: Prop
anchorCenter = anchor (newPoint1 0.5)

pivot :: Point -> Prop
pivot = createProp "pivot"

pivotAnchor :: Point -> Prop
pivotAnchor = createProp "pivotAnchor"

pivotCenter :: Prop
pivotCenter = pivotAnchor (newPoint1 0.5)

pivotCenterX :: Prop
pivotCenterX = pivotAnchor (newPoint 0.5 0.0)

pivotCenterY :: Prop
pivotCenterY = pivotAnchor (newPoint 0.0 0.5)

alpha :: Number -> Prop
alpha = createProp "alpha"

rotation :: Number -> Prop
rotation = createProp "rotation"

txt :: String -> Prop
txt = createProp "text"

style :: forall vals. { | vals } -> Prop
style = createProp "style"

key :: forall a. a -> Prop
key = createProp "key"

src :: String -> Prop
src = createProp "src"

cacheAsBitmap :: Boolean -> Prop
cacheAsBitmap = createProp "cacheAsBitmap"

onClick :: forall eff. Eff eff Unit -> Prop
onClick = createProp "on-click"

onMouseDown :: forall eff. Eff eff Unit -> Prop
onMouseDown = createProp "on-mousedown"

onTouchStart :: forall eff. Eff eff Unit -> Prop
onTouchStart = createProp "on-touchstart"

onMouseOrTouchStart :: forall eff. Eff eff Unit -> Prop
onMouseOrTouchStart = createProp "on-mouseortouchstart"
