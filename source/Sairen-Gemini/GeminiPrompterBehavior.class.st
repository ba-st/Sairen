Class {
	#name : 'GeminiPrompterBehavior',
	#superclass : 'GenerativePrompter',
	#instVars : [
		'clientProvider',
		'apiKey',
		'configurationOptional',
		'modelName',
		'timeoutInSeconds'
	],
	#category : 'Sairen-Gemini',
	#package : 'Sairen-Gemini'
}

{ #category : 'private - processing' }
GeminiPrompterBehavior >> addAvailableModelsTo: someModels optionallyQuerying: aNextPageTokenOptional [

	| url client response |

	url := self baseUrl / 'models' ? ( #key -> apiKey ).
	aNextPageTokenOptional withContentDo: [ :nextPageToken |
			url := url ? ( #pageToken -> nextPageToken ) ].
	client := clientProvider value
		          url: url;
		          yourself.
	client get.
	response := NeoJSONObject fromString: client response entity.
	someModels addAll: ( response at: #models ifAbsent: [ Array with: response ] ).

	response at: #nextPageToken ifPresent: [ :nextPageToken |
			self addAvailableModelsTo: someModels optionallyQuerying: ( Optional containing: nextPageToken ) ]
]

{ #category : 'private - accessing' }
GeminiPrompterBehavior >> availableModels [

	| models |

	models := OrderedCollection new.
	
	self addAvailableModelsTo: models optionallyQuerying: Optional unused.
	
	^ models
]

{ #category : 'private - accessing' }
GeminiPrompterBehavior >> baseUrl [

	^ 'https://generativelanguage.googleapis.com/v1beta' asUrl
]

{ #category : 'configuring' }
GeminiPrompterBehavior >> changeModelNameTo: aString [

	modelName := aString
]

{ #category : 'configuring' }
GeminiPrompterBehavior >> changeTemperatureTo: aNumber [
	"temperature controls the randomness of the output. Use higher values for more creative responses, and lower values for more deterministic responses. Values can range from [0.0, 2.0]."

	self currentConfiguration at: 'temperature' put: aNumber
]

{ #category : 'configuring' }
GeminiPrompterBehavior >> changeTimeoutTo: aNumberOfSeconds [

	timeoutInSeconds := aNumberOfSeconds
]

{ #category : 'private - accessing' }
GeminiPrompterBehavior >> currentConfiguration [

	^ configurationOptional withContentDo: [ :current | current ] ifUnused: [
			  | emptyConfiguration |

			  emptyConfiguration := Dictionary new.
			  configurationOptional := Optional containing: emptyConfiguration.
			  emptyConfiguration
		  ]
]

{ #category : 'private - accessing' }
GeminiPrompterBehavior >> httpClient [

	^ clientProvider value
		  timeout: timeoutInSeconds;
		  url: self baseUrl / 'models' / ( '<1s>:<2s>' expandMacrosWith: modelName with: self method )
			  ? ( #key -> apiKey );
		  yourself
]

{ #category : 'initialization' }
GeminiPrompterBehavior >> initializeConnectingWith: aClientProvider using: anAPIKey [

	clientProvider := aClientProvider.
	apiKey := anAPIKey.
	configurationOptional := Optional unused.
	self changeTimeoutTo: 40.
	self initializeModelName
]

{ #category : 'initialization' }
GeminiPrompterBehavior >> initializeModelName [

	self subclassResponsibility
]

{ #category : 'private - accessing' }
GeminiPrompterBehavior >> jsonEntityBasedOn: aDictionary [

	configurationOptional withContentDo: [ :configuration |
			aDictionary at: 'generationConfig' put: configuration ].

	^ ZnEntity json: aDictionary asJson
]

{ #category : 'private - accessing' }
GeminiPrompterBehavior >> method [

	^ 'generateContent'
]

{ #category : 'private - accessing' }
GeminiPrompterBehavior >> parametersForPromptingJust: aText [

	^ { 'contents' -> { { 'parts' -> { { 'text' -> aText } asDictionary } } asDictionary } }
		  asDictionary
]

{ #category : 'private - accessing' }
GeminiPrompterBehavior >> postResponseFor: anEntity [

	| client responseEntity |

	client := self httpClient.
	client
		entity: anEntity;
		contentType: ZnMimeType applicationJson.
	client post.
	responseEntity := client response entity.
	responseEntity ifNil: [
			AssertionFailed signal: ( 'Server responded <1s> to <2p>'
					  expandMacrosWith:
					  ( String streamContents: [ :stream | client response statusLine writeOn: stream ] ) trim
					  with: client request uri )
		].

	^ NeoJSONObject fromString: responseEntity
]

{ #category : 'accessing' }
GeminiPrompterBehavior >> prompt: aText [

	| parameters |

	parameters := self parametersForPromptingJust: aText.
	^ self promptUsing: ( self jsonEntityBasedOn: parameters )
]

{ #category : 'private - accessing' }
GeminiPrompterBehavior >> promptUsing: anEntity [

	^ self subclassResponsibility
]
