//
//  Action.js
//  TransloaderActionExtension2
//
//  Created by Matthias Gansrigler on 26.01.2015.
//  Copyright (c) 2015 Eternal Storms Software. All rights reserved.
// https://eternalstorms.wordpress.com/2015/01/29/ios-8-safari-action-extension-uiwebview-zoom-scale-scroll-position-and-javascript/

var Action = function() {}

Action.prototype = {
    
    run: function(arguments) {
		
		//we pass:
		//	the pageXOffset and pageYOffset (the horizontal and vertical scroll position)
		//	the pageScale, which is how far into the page the user has zoomed
		//	the base URI
		arguments.completionFunction({
									 "pageXOffset":window.pageXOffset,
									 "pageYOffset":window.pageYOffset,
									 "pageScale":(document.body.clientWidth/window.innerWidth),
									 "baseURI":document.URL
									 })
    },
    
    finalize: function(arguments) {
        //doesn't do anything in this example
    }
    
}
    
var ExtensionPreprocessingJS = new Action
