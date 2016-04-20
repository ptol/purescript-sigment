// module Sigment.Dom.Props

function createProp(key,value){
  return {key:key, value:value};
}

function newRectangle(x, y, width, height){
  return new PIXI.Rectangle(x, y, width, height);
}


function newPoint(x, y){
  return new PIXI.Point(x, y);
}

exports._createProp = createProp;
exports._newRectangle = newRectangle;
exports._newPoint = newPoint;

exports.none = {};
