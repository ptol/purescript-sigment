// module Sigment.Core

var execActionF = null;
var renderer = null;
var stage = null;
var config = null;
var mapFunction = null;
function initSigment(pExecAction, pMapFunction, pConfig, cb){
  mapFunction = pMapFunction;
  config = pConfig;
  execActionF = pExecAction;
  renderer = PIXI.autoDetectRenderer(config.width, config.height, {backgroundColor : parseInt("0x" + pConfig.backgroundColor)});
  stage = virtualPixi.api.createElement("group");
  var container = config.containerId ? document.getElementById(config.containerId) : document.body;
  container.appendChild(renderer.view);
  if(config.containerId){
    resize(container.clientWidth, container.clientHeight);
  }else{
    resize(window.innerWidth, window.innerHeight);
  }
  if(config.sprites.length > 0){
    PIXI.loader.add(config.sprites).load(() => {cb();startRender();});
  }else{
    cb();
    startRender();
  }
}

// window.onresize = () => resize(window.innerWidth, window.innerHeight);

function resize(width, height) {
  var ratio = config.width/config.height;
  var x = 0;
  var y = 0;
  var w = 0;
  var h = 0;
  if (width / height >= ratio) {
    w = height * ratio;
    x = (width - w)/2;
    h = height;
  } else {
    w = width;
    h = width / ratio;
    y = (height - h)/2;
  }
  renderer.view.style.width = w + 'px';
  renderer.view.style.height = h + 'px';
  renderer.view.style.left = x + 'px';
  renderer.view.style.top = y + 'px';
  renderer.view.style.position = "relative";
}

var currentVNode = null;
function updateStage(vNode){
  var vn = virtualPixi.h("group", {}, [vNode]);
  if(currentVNode){
    currentVNode = virtualPixi.patch(currentVNode, vn);
  }else{
    currentVNode = virtualPixi.patch(stage, vn);
  }
}

function startRender(){
  requestAnimationFrame(render);
}

var prevTimestamp = null;

function render(timestamp) {
  requestAnimationFrame(render);
  if (!prevTimestamp) prevTimestamp = timestamp;
  var interval = timestamp - prevTimestamp;
  prevTimestamp = timestamp;
  mapFunction(x => {
    execActionF(x(interval))();
  })(config.frameAction);
  TWEEN.update(timestamp);
  renderer.render(stage);
}

exports._updateStage = updateStage;
exports._initSigment = initSigment;
exports._requestAnimationFrame = requestAnimationFrame;
