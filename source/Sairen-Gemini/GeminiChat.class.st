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

	^ self
		  connectingWith: self defaultHTTPClientProvider
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

{ #category : 'private - accessing' }
GeminiChat class >> defaultHTTPClientProvider [

	^ [
		  ZnClient new
			  beOneShot;
			  yourself
	  ]
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
	answer := self prompt: self jsonPrompt.
	self addAsModelResponse: answer.
	^ answer
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

{ #category : 'private - accessing' }
GeminiChat >> jsonPrompt [

	^ { 'system_instruction' -> { 'parts' -> { { 'text' -> systemPrompt } asDictionary } } asDictionary .
		  'contents' -> self promptHistory } asDictionary asJson
]

{ #category : 'private - processing' }
GeminiChat >> prompt: aJSON [

	^ [ ( prompter prompt: aJSON ) any ]
		  on: AssertionFailed , NameLookupFailure
		  do: [ :ex | ex return: ex messageText ]
]

{ #category : 'private - accessing' }
GeminiChat >> promptHistory [

	^ conversation collect: [ :message |
			  { 'role' -> message key . 'parts' -> { 'text' -> message value } asDictionary } asDictionary ]
]
