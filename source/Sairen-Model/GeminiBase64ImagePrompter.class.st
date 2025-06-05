Class {
	#name : 'GeminiBase64ImagePrompter',
	#superclass : 'GenerativeTextPrompter',
	#instVars : [
		'clientProvider',
		'apiKey',
		'configurationOptional'
	],
	#category : 'Sairen-Model',
	#package : 'Sairen-Model'
}

{ #category : 'private - accessing' }
GeminiBase64ImagePrompter >> baseUrl [

	^ 'https://generativelanguage.googleapis.com/v1beta' asUrl
]

{ #category : 'configuring' }
GeminiBase64ImagePrompter >> changeTemperatureTo: aNumber [
	"temperature controls the randomness of the output. Use higher values for more creative responses, and lower values for more deterministic responses. Values can range from [0.0, 2.0]."

	self currentConfiguration at: 'temperature' put: aNumber
]

{ #category : 'private - accessing' }
GeminiBase64ImagePrompter >> currentConfiguration [

	^ configurationOptional withContentDo: [ :current | current ] ifUnused: [
			  | emptyConfiguration |

			  emptyConfiguration := Dictionary new.
			  configurationOptional := Optional containing: emptyConfiguration.
			  emptyConfiguration
		  ]
]

{ #category : 'private - accessing' }
GeminiBase64ImagePrompter >> httpClient [

	^ clientProvider value
		  url: self baseUrl / '/models/gemini-2.0-flash-preview-image-generation:generateContent' ? ( #key -> apiKey );
		  yourself
]

{ #category : 'initialization' }
GeminiBase64ImagePrompter >> initializeConnectingWith: aClientProvider using: anAPIKey [

	clientProvider := aClientProvider.
	apiKey := anAPIKey.
	configurationOptional := Optional unused.
	self currentConfiguration at: 'responseModalities' put: { 'TEXT' . 'IMAGE' }
]

{ #category : 'private - accessing' }
GeminiBase64ImagePrompter >> jsonEntityFor: aText [

	| parameters |

	parameters := { ( 'contents'
		                -> { { ( 'parts' -> { { ( 'text' -> aText ) } asDictionary } ) } asDictionary } ) }
		              asDictionary.
		
	configurationOptional withContentDo: [ :configuration |
			parameters at: 'generationConfig' put: configuration ].
		
	^ ZnEntity json: parameters asJson
]

{ #category : 'private - accessing' }
GeminiBase64ImagePrompter >> postResponseFor: anEntity [

	| client |

	client := self httpClient.
	client
		entity: anEntity;
		contentType: ZnMimeType applicationJson.
	client post.
	^ NeoJSONObject fromString: client response entity
]

{ #category : 'accessing' }
GeminiBase64ImagePrompter >> prompt: aText [

	^ self promptUsing: ( self jsonEntityFor: aText )
]

{ #category : 'private - accessing' }
GeminiBase64ImagePrompter >> promptUsing: anEntity [

	| responseEntity |

	responseEntity := self postResponseFor: anEntity.
	^ responseEntity candidates first content parts last inlineData data
]
