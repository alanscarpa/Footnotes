var MMExtensionClass = function() {};

MMExtensionClass.prototype = {
run: function(arguments) {
    arguments.completionFunction({"content": document.body.innerHTML});
},
    
finalize: function(arguments) {
    document.body.innerHTML = arguments["content"];
}
};

var ExtensionPreprocessingJS = new MMExtensionClass;