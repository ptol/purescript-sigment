Sigment (SImple GaMe ENgine) uses [virtual-pixi](https://github.com/ptol/virtual-pixi) and can use Canvas or WebGL for scene rendering

Also it uses approach similar to [Elm architecture](https://github.com/evancz/elm-architecture-tutorial/)

# Counter

```
data Action = Increase | Decrease

type Model = Int

initState = 0

component :: Component Unit Action Model _
component = newComponent (const initState >>> pure) (pureEval eval) render

eval :: PureEval Action Model
eval Increase = (_ + 1)
eval Decrease = (_ - 1)

render :: Render Action Model _
render action state dispatch = D.group' [P.x 120, P.y 200] [
  D.text [P.txt "+", P.onClick (dispatch Increase), P.x 30],
  D.text [P.txt "-", P.onClick (dispatch Decrease), P.x 60],
  D.text [P.txt (show state), P.x 120]
]

main = do
   init (defConfig {width = 400, height = 400, containerId = "container"}) unit component
```

# Other examples

## Snake

[Demo](http://ptol.github.io/purescript-sigment-examples/snake/public.html) 

[Source](https://github.com/ptol/purescript-sigment-examples/tree/master/snake/src)

## Counter

[Demo](http://ptol.github.io/purescript-sigment-examples/counter/public.html) 

[Source](https://github.com/ptol/purescript-sigment-examples/tree/master/counter/src)

## Counter list

[Demo](http://ptol.github.io/purescript-sigment-examples/counter-list/public.html) 

[Source](https://github.com/ptol/purescript-sigment-examples/tree/master/counter-list/src)
