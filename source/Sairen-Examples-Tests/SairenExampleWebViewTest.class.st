Class {
	#name : 'SairenExampleWebViewTest',
	#superclass : 'BWRenderingTest',
	#category : 'Sairen-Examples-Tests',
	#package : 'Sairen-Examples-Tests'
}

{ #category : 'test support' }
SairenExampleWebViewTest >> charSet [

	^ GRNullCodec codecName
]

{ #category : 'test support' }
SairenExampleWebViewTest >> codec [

	^ GRNullCodec new
]

{ #category : 'test support' }
SairenExampleWebViewTest >> componentSupplier [

	^ Html5ComponentSupplier new
]

{ #category : 'test support' }
SairenExampleWebViewTest >> deploymentMode [

	^ WAApplicationInDevelopment new
]

{ #category : 'test support' }
SairenExampleWebViewTest >> handler [

	^ self
]

{ #category : 'test support' }
SairenExampleWebViewTest >> preferenceAt: aSymbol ifAbsent: aBlock [

	^ aBlock value
]

{ #category : 'test support' }
SairenExampleWebViewTest >> scriptGeneratorClass [

	^ WADefaultScriptGenerator
]

{ #category : 'test support' }
SairenExampleWebViewTest >> session [

	^ self
]

{ #category : 'test support' }
SairenExampleWebViewTest >> startUpApplicationContextFor: aWillowApplication [
	"No need to do anything extra"

	
]

{ #category : 'tests' }
SairenExampleWebViewTest >> testRenderContentOn [

	| exampleView html |

	exampleView := SairenExampleWebView new.
	html := WACurrentRequestContext value: self during: [
			        exampleView initialRequest: 'Not relevant'.
			        self fullDocumentRendering: exampleView
		        ].

	self
		assert: html
		equals:
		'<!DOCTYPE html><html lang="en"><head><title>Sairen Example</title><script type="text/javascript" src="/files/jQuery-3.7.0/jquery-3.7.0.js"></script><script type="text/javascript" src="/files/willow-8.0.1/js/willow.js"></script><link rel="stylesheet" type="text/css" href="/files/sairen-apps-1.0.0/css/sairen.css"/><script type="text/javascript" src="/files/sairen-apps-1.0.0/js/sairen.js"></script><link rel="shortcut icon" href="/files/sairen-apps-1.0.0/favicon.ico"/><link rel="stylesheet" type="text/css" href="/files/spinkit-2.0.1/spinkit.css"/></head><body onload="onLoad()"><form accept-charset="(none)" method="post" action="/" onsubmit="return false;"><div class="apiKey"><p><span>Sairen requires a Gemini API Key to negotiate requests.</span><br/><span>To learn more, check </span><a>https://ai.google.dev/gemini-api/docs/api-key</a></p><label for="text-id1">API Key</label><input value="" name="2" id="text-id1" type="text"/></div><div class="poem"><p><span>This section allows writing any subject, and get a small poem about it.</span><br/><span>To learn more about how this is done, check SairenExampleWebView</span></p><label for="text-id4">Poem subject</label><input value="" name="5" id="text-id4" type="text"/><button id="button-id9" type="button">Go!</button><div id="container-id7"></div></div><div class="translator"><p><span>This section records an audio (while the button is pressed), which is then translated to English and shown below.</span><br/><span>To learn more about how this is done, check SairenExampleWebView</span></p><button id="button-id11" type="button">Record</button><audio class="translator" id="audio-id16"></audio><div id="container-id12"><span></span></div></div></form><div id="willow-dialog-section" class="willow-dialog-container"></div><div id="willow-notification-section"></div><script type="text/javascript">function onLoad(){$("#button-id9").click(function(event){$("#container-id7").html("<div class=\"sk-flow\"><div class=\"sk-flow-dot\"></div><div class=\"sk-flow-dot\"></div><div class=\"sk-flow-dot\"></div></div>");Willow.callServer({"type":"POST","url":"/","data":["8",$(this).closest("form").find(":input").serialize()].join("&")})});$("#button-id11").mouseup(function(event){stopRecording()});$("#button-id11").mousedown(function(event){$("#container-id12").html("<div class=\"sk-flow\"><div class=\"sk-flow-dot\"></div><div class=\"sk-flow-dot\"></div><div class=\"sk-flow-dot\"></div></div>");startRecording();Willow.callServer({"type":"POST","url":"/","data":["13",$(this).closest("form").find(":input").serialize()].join("&")})});$("#audio-id16").click(function(event){Willow.callServer({"type":"POST","url":"/","data":["14","15="+encodeURIComponent(JSON.stringify($(this).parent().children("audio").prop("src")))].join("&")})});};</script></body></html>'
]
