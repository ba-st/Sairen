Class {
	#name : 'SairenExampleWebView',
	#superclass : 'WillowApplication',
	#instVars : [
		'subjectView',
		'generateButton',
		'generatedPoemContainer',
		'poemLines',
		'apiKeyView',
		'listenButton',
		'translationContainer',
		'translation'
	],
	#category : 'Sairen-Examples-Application',
	#package : 'Sairen-Examples',
	#tag : 'Application'
}

{ #category : 'accessing' }
SairenExampleWebView class >> applicationTitle [

	^ 'Sairen Example'
]

{ #category : 'accessing' }
SairenExampleWebView class >> handlerName [

	^ 'sairen-example'
]

{ #category : 'private-utility' }
SairenExampleWebView class >> registerAsApplicationUsing: deploymentModeClass [

	| application |

	application := super registerAsApplicationUsing: deploymentModeClass.
	application configuration at: #maximumRelativeAge put: 3600.
	application cache: application createCache.
	^ application
]

{ #category : 'accessing' }
SairenExampleWebView class >> start [

	SairenExampleWebView registerAsDevelopmentApplication.
	( ZnZincServerAdaptor port: 8080 )
		codec: ( GRCodec forEncoding: 'utf8' );
		start
]

{ #category : 'accessing' }
SairenExampleWebView class >> stop [

	ZnServer stopDefault.
	ZnZincServerAdaptor allInstancesDo: [ :each | each shutDown ].
	SairenExampleWebView unregisterFromApplications.
	Smalltalk garbageCollect
]

{ #category : 'private - accessing' }
SairenExampleWebView >> audioSourceQuery [

	^ ( JSStream new javascript jQuery this parent children: 'audio' ) propertyAt: 'src'
]

{ #category : 'accessing' }
SairenExampleWebView >> componentSupplierForApplication [

	^ Bootstrap3ComponentSupplier
		withBootstrapLibrary: (self deploymentMode libraryFor: Bootstrap3MetadataLibrary) withoutOptionalTheme
		selectLibrary: ((self deploymentMode libraryFor: BootstrapSelectLibrary) using: self language)
		datepickerLibrary: ((self deploymentMode libraryFor: BootstrapDatepickerLibrary) using: self language)
		typeaheadLibrary: (self deploymentMode libraryFor: BootstrapTypeaheadLibrary) new
]

{ #category : 'private - processing' }
SairenExampleWebView >> configureToUpdateTranslation: aRequest [

	aRequest onRespond serverDo: [ :request |
			self updateTranslationFrom: aRequest parameter.
			request onRespond render: translationContainer
		]
]

{ #category : 'private - accessing' }
SairenExampleWebView >> contentFrom: aBase64Audio [

	^ aBase64Audio copyAfter: $,
]

{ #category : 'accessing' }
SairenExampleWebView >> contentView [

	^ [ :canvas |
		  canvas form
			  doNotSubmit;
			  with: [
					  self renderApiKeyOn: canvas.
					  self renderPoemGeneratorOn: canvas.
					  self renderTranslatorOn: canvas
				  ]
	  ]
]

{ #category : 'private - accessing' }
SairenExampleWebView >> geminiTextPrompter [

	^ ( GeminiTextPrompter authenticatedWith: apiKeyView contents )
		  changeMaximumOutputTokensTo: 200;
		  changeTemperatureTo: 0.1;
		  changeTopTokenIndividualProbabilityTo: 5;
		  yourself
]

{ #category : 'initialization' }
SairenExampleWebView >> initialRequest: request [

	super initialRequest: request.

	self initializeApiKeyView.
	self initializeSubjectView.
	self initializeGeneratedPoemContainer.
	self initializeGenerateButton.
	self updatePoem.
	translation := ''.
	self initializeTranslationContainer.
	self initializeListenButton
]

{ #category : 'initialization' }
SairenExampleWebView >> initializeApiKeyView [

	apiKeyView := self componentSupplier singleLineTextFieldApplying: [  ]
]

{ #category : 'initialization' }
SairenExampleWebView >> initializeGenerateButton [

	generateButton := self componentSupplier asynchronicButtonLabeled: 'Go!' applying: [  ].
	generateButton on trigger
		transform: generatedPoemContainer into: SpinKitFlow new;
		serializeContainerForm;
		serverDo: [ :request |
				self updatePoem.
				request onRespond render: generatedPoemContainer
			]
]

{ #category : 'initialization' }
SairenExampleWebView >> initializeGeneratedPoemContainer [

	generatedPoemContainer := self componentSupplier
		                          divisionContainerWrapping: [ :canvas |
			                          poemLines
				                          do: [ :line | canvas span: line ]
				                          separatedBy: [ canvas break ] ]
		                          applying: [  ]
]

{ #category : 'initialization' }
SairenExampleWebView >> initializeListenButton [

	listenButton := self componentSupplier asynchronicButtonLabeled: 'Record' applying: [  ].
	( listenButton on eventNamed: #mousedown )
		transform: translationContainer into: SpinKitFlow new;
		serializeContainerForm;
		userAgentDo: [ JSFunctionCall for: 'startRecording' ].
	( listenButton on eventNamed: #mouseup ) userAgentDo: [ JSFunctionCall for: 'stopRecording' ]
]

{ #category : 'initialization' }
SairenExampleWebView >> initializeSubjectView [

	subjectView := self componentSupplier singleLineTextFieldApplying: [  ]
]

{ #category : 'initialization' }
SairenExampleWebView >> initializeTranslationContainer [

	translationContainer := self componentSupplier
		                        divisionContainerWrapping: [ :canvas | canvas span: translation ]
		                        applying: [  ]
]

{ #category : 'accessing' }
SairenExampleWebView >> jQueryLibrary [

	^ ( self deploymentMode libraryFor: JQuery3MetadataLibrary ) default
]

{ #category : 'private - accessing' }
SairenExampleWebView >> labeledApiKeyView [

	^ LabeledWebView obtainingContentFrom: [ 'API Key' ] boundTo: apiKeyView applying: [  ]
]

{ #category : 'private - accessing' }
SairenExampleWebView >> labeledSubjectView [

	^ LabeledWebView obtainingContentFrom: [ 'Poem subject' ] boundTo: subjectView applying: [  ]
]

{ #category : 'private - accessing' }
SairenExampleWebView >> mimeTypeFrom: aBase64Audio [

	^ ( aBase64Audio copyAfter: $: ) copyUpTo: $;
]

{ #category : 'private - accessing' }
SairenExampleWebView >> poemPromptFor: aSubject [

	^ 'Context: You are an award winning poet, who also admires the programming language Smalltalk. There is a poem contest, where you want it to participate to create a witty poem, that also references some distinctive aspect of Smalltalk, without making explicit mention of the language.
	
Task: You are participating in a challenge where you have to write a poem. The subject is "<1s>". The poem must be in whatever language the subject seems to imply. It must have 4 sentences.

Restrictions: The Poem must use words that are suitable and understandable by a 10 year old. The answer must not include any additional information nor explanation.'
		  expandMacrosWith: aSubject
]

{ #category : 'private - rendering' }
SairenExampleWebView >> renderApiKeyExplanationOn: aCanvas [

	aCanvas paragraph: [
			aCanvas
				span: 'Sairen requires a Gemini API Key to negotiate requests.';
				break;
				span: 'To learn more, check ';
				anchor: 'https://ai.google.dev/gemini-api/docs/api-key'
		]
]

{ #category : 'private - rendering' }
SairenExampleWebView >> renderApiKeyOn: aCanvas [

	aCanvas div
		with: [
				self renderApiKeyExplanationOn: aCanvas.
				aCanvas render: self labeledApiKeyView
			]
		applying: [ :div | div addClass sairenApps apiKey ]
]

{ #category : 'private - rendering' }
SairenExampleWebView >> renderPoemExplanationOn: aCanvas [

	aCanvas paragraph: [
			aCanvas
				span: 'This section allows writing any subject, and get a small poem about it.';
				break;
				span:
					( 'To learn more about how this is done, check <1p>' expandMacrosWith: thisContext contextClass )
		]
]

{ #category : 'private - rendering' }
SairenExampleWebView >> renderPoemGeneratorOn: aCanvas [

	aCanvas div
		with: [
				self renderPoemExplanationOn: aCanvas.
				aCanvas
					render: self labeledSubjectView;
					render: generateButton;
					render: generatedPoemContainer
			]
		applying: [ :div | div addClass sairenApps poem ]
]

{ #category : 'private - rendering' }
SairenExampleWebView >> renderRecordedAudioOn: aCanvas [

	| audio interactionInterpreter |

	audio := aCanvas audio apply: [ :view | view addClass sairenApps translator ].
	interactionInterpreter := EventInterpreterDispatcher defaultingToClick.
	interactionInterpreter trigger
		with: self audioSourceQuery
		serverDo: [ :request | self configureToUpdateTranslation: request ].
	audio interactUsing: interactionInterpreter
]

{ #category : 'private - rendering' }
SairenExampleWebView >> renderTranslatorExplanationOn: aCanvas [

	aCanvas paragraph: [
			aCanvas
				span:
					'This section records an audio (while the button is pressed), which is then translated to English and shown below.';
				break;
				span:
					( 'To learn more about how this is done, check <1p>' expandMacrosWith: thisContext contextClass )
		]
]

{ #category : 'private - rendering' }
SairenExampleWebView >> renderTranslatorOn: aCanvas [

	aCanvas div
		with: [
				self renderTranslatorExplanationOn: aCanvas.
				aCanvas render: listenButton.
				self renderRecordedAudioOn: aCanvas.
				aCanvas render: translationContainer
			]
		applying: [ :div | div addClass sairenApps translator ]
]

{ #category : 'accessing' }
SairenExampleWebView >> requiredLibraries [
	" Libraries added here are not considered until the server is restarted.
	  Including a library with a favicon.ico will automatically use it.	"

	^ { SairenExampleFileMetadataLibrary default . ( self deploymentMode libraryFor:
			    SpinKitMetadataLibrary ) default }
]

{ #category : 'private - accessing' }
SairenExampleWebView >> translationPrompt [

	^ 'You are a sound interpreter. Without taking further instructions, listen to the words in the audio, and return their meaning in English, without providing any additional information. When unsure, or if it seems like nothing was said, just return an empty string.'
]

{ #category : 'private - processing' }
SairenExampleWebView >> updatePoem [

	subjectView contents
		ifEmpty: [ poemLines := #(  ) ]
		ifNotEmpty: [ :subject | self updatePoemFor: subject ]
]

{ #category : 'private - processing' }
SairenExampleWebView >> updatePoemFor: aSubject [

	| prompt generativeDescription |

	prompt := self poemPromptFor: aSubject.
	generativeDescription := [ self geminiTextPrompter prompt: prompt ]
		                         on: AssertionFailed
		                         do: [ :ex | ex return: ( Array with: ex messageText ) ].
	poemLines := generativeDescription any substrings: ( Array with: Character cr with: Character lf )
]

{ #category : 'private - processing' }
SairenExampleWebView >> updateTranslationFrom: aBase64Audio [

	translation := [
		               self geminiTextPrompter
			               prompt: self translationPrompt
			               whenListeningTo: ( self contentFrom: aBase64Audio )
			               with: ( self mimeTypeFrom: aBase64Audio )
	               ]
		               on: AssertionFailed
		               do: [ :ex | ex return: ex messageText ]
]
