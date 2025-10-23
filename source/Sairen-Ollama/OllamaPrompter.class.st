Class {
	#name : 'OllamaPrompter',
	#superclass : 'GenerativePrompter',
	#instVars : [
		'clientProvider',
		'apiKey',
		'modelBinding',
		'timeoutInSeconds'
	],
	#category : 'Sairen-Ollama',
	#package : 'Sairen-Ollama'
}

{ #category : 'accessing' }
OllamaPrompter >> availableModels [

	| client |

	client := self httpClient.
	client url: self baseUrl / 'api/tags'.
	client get.
	^ NeoJSONObject fromString: client response entity
]

{ #category : 'private - accessing' }
OllamaPrompter >> baseUrl [

	^ ( 'http://localhost:<1p>' expandMacrosWith: self port ) asUrl
]

{ #category : 'configuring' }
OllamaPrompter >> changeTimeoutTo: aNumberOfSeconds [

	timeoutInSeconds := aNumberOfSeconds
]

{ #category : 'private - accessing' }
OllamaPrompter >> flattenedPartsFrom: responseEntity [

	^ responseEntity
		  at: 'choices'
		  ifPresent: [ :choices |
			  ( choices collect: [ :choice | ( choice at: 'message' ) at: 'content' ] ) flattened ]
		  ifAbsent: [
				  AssertionFailed signal: ( 'Ollama responded with error: <1s>' expandMacrosWith:
						    ( ( responseEntity at: 'error' ) at: 'message' ) )
			  ]
]

{ #category : 'private - accessing' }
OllamaPrompter >> httpClient [

	^ clientProvider value
		  timeout: timeoutInSeconds;
		  url: self baseUrl / 'v1/chat/completions';
		  yourself
]

{ #category : 'initialization' }
OllamaPrompter >> initializeConnectingWith: aClientProvider using: anAPIKey [

	clientProvider := aClientProvider.
	apiKey := anAPIKey.
	self changeTimeoutTo: 40.
	modelBinding := Binding undefinedExplainedBy: 'No model chosen yet'
]

{ #category : 'private - accessing' }
OllamaPrompter >> jsonEntityBasedOn: aDictionary [

	aDictionary at: 'model' put: modelBinding content.
	^ ZnEntity json: aDictionary asJson
]

{ #category : 'private - accessing' }
OllamaPrompter >> parametersForPromptingJust: aText [

	^ { 'messages' -> { { 'role' -> 'user' . 'content' -> aText } asDictionary } } asDictionary
]

{ #category : 'private - accessing' }
OllamaPrompter >> port [

	^ 11434
]

{ #category : 'private - accessing' }
OllamaPrompter >> postResponseFor: anEntity [

	| client string |

	client := self httpClient.
	client
		entity: anEntity;
		contentType: ZnMimeType applicationJson.
	client post.
	string := client response entity contents.
	^ NeoJSONObject fromString: ( String streamContents: [ :stream | stream nextPutAll: string ] )
]

{ #category : 'accessing' }
OllamaPrompter >> prompt: aText [

	| parameters |

	parameters := self parametersForPromptingJust: aText.
	^ self promptUsing: ( self jsonEntityBasedOn: parameters )
]

{ #category : 'accessing' }
OllamaPrompter >> promptBasedOn: aDictionary [

	^ self promptUsing: ( self jsonEntityBasedOn: aDictionary )
]

{ #category : 'private - accessing' }
OllamaPrompter >> promptUsing: anEntity [

	| responseEntity |

	responseEntity := self postResponseFor: anEntity.
	^ self flattenedPartsFrom: responseEntity
]

{ #category : 'configuring' }
OllamaPrompter >> setModelTo: aModelName [

	modelBinding := Binding to: aModelName
]
