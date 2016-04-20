// module Sigment.Dom
var vp = virtualPixi;
function merge(props){
  var result = {};
  if(props){
    props.forEach(x => {
      result[x.key] = x.value;
    });
  }
  return result;
}

function createTween(value){
  var tween = merge(value);
  tween.from = merge(tween.from);
  tween.to = merge(tween.to);
  return tween;
}

var dataKeys = ["props", "on", "tween", "keyboard"];
var tweenPrefix = "tween-";
var onPrefix = "on-";
function convertProps(props){
  var o = {};
  dataKeys.forEach(x => o[x] = {});
  props.forEach(x => {
    var value = x.value;
    var key = x.key;
    if(!key){
    }else if(key == "key"){
      o.key = value;
    }else if(key.indexOf(tweenPrefix) == 0){
      var tweenKey = key.replace(tweenPrefix, "");
      o.tween[tweenKey] = createTween(value);
    }else if(key.indexOf(onPrefix) == 0){
      var onKey = key.replace(onPrefix, "");
      if(onKey == "mouseortouchstart"){
        o.on["touchstart"] = value;
        o.on["mousedown"] = value;
      }else{
        o.on[onKey] = value;
      }
    }else if(key == "keyboard"){
      value.forEach(x => {
        o.keyboard[x.keys] = x;
      });
    }else{
      o.props[key] = value;
    }
  });
  return o;
};

function createNode(name, props, children){
  var data = convertProps(props);
  var s = vp.h(name, data, children.filter(x => x != null));
  return s;
}

function thunk(name, render, state){
  return vp.thunk(name, render, state);
}

function thunk4(name, render, state, compare){
  return vp.thunk(name, render, state, (x,y) => compare(x)(y));
}


function addProps(newData, oldData){
  dataKeys.forEach(dataKey => {
    var newProps = newData[dataKey];
    var oldProps = oldData[dataKey];
    for(var key in oldProps){
      if(!newProps[key]){
        newProps[key] = oldProps[key];
      }
    }
  });
}

function setProps(props, node){
  var data = convertProps(props);
  addProps(data, node.data);
  return vp.h(node.sel, data, node.children);
}

exports._createNode = createNode;
exports._thunk = thunk;
exports._thunk4 = thunk4;
exports._setProps = setProps;
exports.empty = null;
