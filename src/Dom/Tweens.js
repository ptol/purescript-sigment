function lowerFirstChar(string) {
  return string.charAt(0).toLowerCase() + string.slice(1);
}

function convertEasing(){
  var result = {};
  for(var key in TWEEN.Easing){
    var easing = TWEEN.Easing[key];
    result[lowerFirstChar(key)] = {in: easing.In, out: easing.Out, inOut : easing.InOut};
  }
  return result;
}

exports.types = convertEasing();
