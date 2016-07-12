module Sigment.Dom.Tweens where

import Prelude (Unit)
import Sigment.Dom.Props (Prop, Props, createProp)
import Control.Monad.Eff (Eff)

to :: Props -> Prop
to = createProp "to"

from :: Props -> Prop
from = createProp "from"

duration :: Int -> Prop
duration = createProp "duration"

yoyo :: Boolean -> Prop
yoyo = createProp "yoyo"

yoyoOnce :: Props
yoyoOnce = [yoyo true, repeat 1]

repeat :: Int -> Prop
repeat = createProp "repeat"

foreign import data EasingType :: *

type InAndOut a =
  { in :: a
  , out :: a
  , inOut :: a
  }

map :: forall a b. (a -> b) -> InAndOut a -> InAndOut b
map f x =
  { in : f x.in
  , out : f x.out
  , inOut : f x.inOut
  }

foreign import types ::
  { linear :: InAndOut EasingType
  , quadratic :: InAndOut EasingType
  , cubic :: InAndOut EasingType
  , quartic :: InAndOut EasingType
  , quintic :: InAndOut EasingType
  , sinusoidal :: InAndOut EasingType
  , exponential :: InAndOut EasingType
  , circular :: InAndOut EasingType
  , elastic :: InAndOut EasingType
  , back :: InAndOut EasingType
  , bounce :: InAndOut EasingType
  }

easing :: EasingType -> Prop
easing = createProp "easing"

easingLinear :: InAndOut Prop
easingLinear = map easing types.linear

easingQuadratic :: InAndOut Prop
easingQuadratic = map easing types.quadratic

easingCubic :: InAndOut Prop
easingCubic = map easing types.cubic

easingQuartic :: InAndOut Prop
easingQuartic = map easing types.quartic

easingQuintic :: InAndOut Prop
easingQuintic = map easing types.quintic

easingSinusoidal :: InAndOut Prop
easingSinusoidal = map easing types.sinusoidal

easingExponential :: InAndOut Prop
easingExponential = map easing types.exponential

easingCircular :: InAndOut Prop
easingCircular = map easing types.circular

easingElastic :: InAndOut Prop
easingElastic = map easing types.elastic

easingBack :: InAndOut Prop
easingBack = map easing types.back

easingBounce :: InAndOut Prop
easingBounce = map easing types.bounce

onComplete :: forall eff. Eff eff Unit -> Prop
onComplete = createProp "onComplete"

updating :: Props -> Prop
updating = createProp "tween-update"

removing :: Props -> Prop
removing = createProp "tween-remove"

creating :: Props -> Prop
creating = createProp "tween-create"

