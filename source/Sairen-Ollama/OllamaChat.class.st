Class {
	#name : 'OllamaChat',
	#superclass : 'Object',
	#instVars : [
		'conversation',
		'prompter'
	],
	#category : 'Sairen-Ollama',
	#package : 'Sairen-Ollama'
}

{ #category : 'instance creation' }
OllamaChat class >> authenticatedWith: anAPIKey [
	"(OllamaChat authenticatedWith: '') setModelTo: 'gemma3:12b-it-q4_K_M'"

	^ self
		  connectingWith: GenerativePrompter defaultHTTPClientProvider
		  authenticatedWith: anAPIKey
		  instructedTo: ''
		  configuringPrompterWith: [ :prompter |  ]
]

{ #category : 'instance creation' }
OllamaChat class >> connectingWith: aClientProvider authenticatedWith: anAPIKey instructedTo: anInstructionString configuringPrompterWith: aBlock [

	^ self new
		  initializeConnectingWith: aClientProvider
		  authenticatedWith: anAPIKey
		  instructedTo: anInstructionString
		  configuringPrompterWith: aBlock
]

{ #category : 'private - processing' }
OllamaChat >> addAsModelResponse: aString [

	conversation add: 'assistant' -> aString
]

{ #category : 'private - processing' }
OllamaChat >> addAsUserQuery: aString [

	conversation add: 'user' -> aString
]

{ #category : 'processing' }
OllamaChat >> askAbout: aQuery [

	| answer |

	self addAsUserQuery: aQuery.
	answer := self promptBasedOn: self promptParameters.
	self addAsModelResponse: answer.
	^ answer
]

{ #category : 'accessing' }
OllamaChat >> conversationMessages [

	^ conversation asArray
]

{ #category : 'initialization' }
OllamaChat >> initializeConnectingWith: aClientProvider authenticatedWith: anAPIKey instructedTo: anInstructionString configuringPrompterWith: aBlock [

	conversation := OrderedCollection new.
	anInstructionString ifNotEmpty: [ conversation add: 'system' -> anInstructionString ].
	self
		initializePrompterConnectingWith: aClientProvider
		authenticatedWith: anAPIKey
		configuredWith: aBlock
]

{ #category : 'initialization' }
OllamaChat >> initializePrompterConnectingWith: aClientProvider authenticatedWith: anAPIKey configuredWith: aBlock [

	prompter := OllamaPrompter connectingWith: aClientProvider authenticatedWith: anAPIKey.
	aBlock value: prompter
]

{ #category : 'private - processing' }
OllamaChat >> promptBasedOn: aDictionary [

	^ [ ( prompter promptBasedOn: aDictionary ) any ]
		  on: AssertionFailed , NameLookupFailure
		  do: [ :ex | ex return: ex messageText ]
]

{ #category : 'private - accessing' }
OllamaChat >> promptHistory [

	^ conversation collect: [ :message |
			  { 'role' -> message key . 'content' -> message value } asDictionary ]
]

{ #category : 'private - accessing' }
OllamaChat >> promptParameters [

	| attributes |

	attributes := Dictionary new.
	attributes at: 'messages' put: self promptHistory.
	^ attributes
]
