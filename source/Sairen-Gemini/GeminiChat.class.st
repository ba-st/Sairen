Class {
	#name : 'GeminiChat',
	#superclass : 'Object',
	#instVars : [
		'conversation',
		'systemPrompt',
		'prompter'
	],
	#category : 'Sairen-Gemini',
	#package : 'Sairen-Gemini'
}

{ #category : 'instance creation' }
GeminiChat class >> authenticatedWith: anAPIKey [
	"(GeminiChat authenticatedWith: 'API_KEY' ) askAbout: 'What is Smalltalk?'"

	^ self
		  connectingWith: GenerativePrompter defaultHTTPClientProvider
		  authenticatedWith: anAPIKey
		  instructedTo: ''
		  configuringPrompterWith: [ :prompter |  ]
]

{ #category : 'instance creation' }
GeminiChat class >> connectingWith: aClientProvider authenticatedWith: anAPIKey instructedTo: anInstructionString configuringPrompterWith: aBlock [

	^ self new
		  initializeConnectingWith: aClientProvider
		  authenticatedWith: anAPIKey
		  instructedTo: anInstructionString
		  configuringPrompterWith: aBlock
]

{ #category : 'private - processing' }
GeminiChat >> addAsModelResponse: aString [

	conversation add: 'model' -> aString
]

{ #category : 'private - processing' }
GeminiChat >> addAsUserQuery: aString [

	conversation add: 'user' -> aString
]

{ #category : 'processing' }
GeminiChat >> askAbout: aQuery [

	| answer |

	self addAsUserQuery: aQuery.
	answer := self promptBasedOn: self promptParameters.
	self addAsModelResponse: answer.
	^ answer
]

{ #category : 'accessing' }
GeminiChat >> conversationMessages [

	^ conversation asArray
]

{ #category : 'initialization' }
GeminiChat >> initializeConnectingWith: aClientProvider authenticatedWith: anAPIKey instructedTo: anInstructionString configuringPrompterWith: aBlock [

	conversation := OrderedCollection new.
	systemPrompt := anInstructionString.
	self
		initializePrompterConnectingWith: aClientProvider
		authenticatedWith: anAPIKey
		configuredWith: aBlock
]

{ #category : 'initialization' }
GeminiChat >> initializePrompterConnectingWith: aClientProvider authenticatedWith: anAPIKey configuredWith: aBlock [

	prompter := GeminiTextPrompter connectingWith: aClientProvider authenticatedWith: anAPIKey.
	aBlock value: prompter
]

{ #category : 'private - processing' }
GeminiChat >> promptBasedOn: aDictionary [

	^ [ ( prompter promptBasedOn: aDictionary ) any ]
		  on: AssertionFailed , NameLookupFailure
		  do: [ :ex | ex return: ex messageText ]
]

{ #category : 'private - accessing' }
GeminiChat >> promptHistory [

	^ conversation collect: [ :message |
			  { 'role' -> message key . 'parts' -> { { 'text' -> message value } asDictionary } }
				  asDictionary ]
]

{ #category : 'private - accessing' }
GeminiChat >> promptParameters [

	| attributes |

	attributes := Dictionary new.
	systemPrompt ifNotEmpty: [
			attributes
				at: 'system_instruction'
				put: { 'parts' -> { { 'text' -> systemPrompt } asDictionary } } asDictionary
		].
	attributes at: 'contents' put: self promptHistory.
	^ attributes
]
