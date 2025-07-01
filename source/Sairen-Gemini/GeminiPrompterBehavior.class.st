Class {
	#name : 'GeminiPrompterBehavior',
	#superclass : 'GenerativePrompter',
	#instVars : [
		'clientProvider',
		'apiKey',
		'configurationOptional'
	],
	#category : 'Sairen-Gemini',
	#package : 'Sairen-Gemini'
}

{ #category : 'private - accessing' }
GeminiPrompterBehavior >> baseUrl [

	^ 'https://generativelanguage.googleapis.com/v1beta' asUrl
]

{ #category : 'configuring' }
GeminiPrompterBehavior >> changeTemperatureTo: aNumber [
	"temperature controls the randomness of the output. Use higher values for more creative responses, and lower values for more deterministic responses. Values can range from [0.0, 2.0]."

	self currentConfiguration at: 'temperature' put: aNumber
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
		  url: self baseUrl / 'models' / ( '<1s>:<2s>' expandMacrosWith: self model with: self method )
			  ? ( #key -> apiKey );
		  yourself
]

{ #category : 'initialization' }
GeminiPrompterBehavior >> initializeConnectingWith: aClientProvider using: anAPIKey [

	clientProvider := aClientProvider.
	apiKey := anAPIKey.
	configurationOptional := Optional unused
]

{ #category : 'private - accessing' }
GeminiPrompterBehavior >> jsonEntityFor: aText [

	| parameters |

	parameters := { ( 'contents'
		                -> { { ( 'parts' -> { { ( 'text' -> aText ) } asDictionary } ) } asDictionary } ) }
		              asDictionary.
		
	configurationOptional withContentDo: [ :configuration |
			parameters at: 'generationConfig' put: configuration ].
		
	^ ZnEntity json: parameters asJson
]

{ #category : 'private - accessing' }
GeminiPrompterBehavior >> method [

	^ 'generateContent'
]

{ #category : 'private - accessing' }
GeminiPrompterBehavior >> model [

	^ self subclassResponsibility
]

{ #category : 'private - accessing' }
GeminiPrompterBehavior >> postResponseFor: anEntity [

	| client |

	client := self httpClient.
	client
		entity: anEntity;
		contentType: ZnMimeType applicationJson.
	client post.
	^ NeoJSONObject fromString: client response entity
]

{ #category : 'accessing' }
GeminiPrompterBehavior >> prompt: aText [

	^ self promptUsing: ( self jsonEntityFor: aText )
]
