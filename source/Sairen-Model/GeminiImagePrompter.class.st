Class {
	#name : 'GeminiImagePrompter',
	#superclass : 'GenerativeTextPrompter',
	#instVars : [
		'clientProvider',
		'apiKey'
	],
	#category : 'Sairen-Model',
	#package : 'Sairen-Model'
}

{ #category : 'private - accessing' }
GeminiImagePrompter >> baseUrl [

	^ 'https://generativelanguage.googleapis.com/v1beta' asUrl
]

{ #category : 'private - accessing' }
GeminiImagePrompter >> httpClient [
	"This model is not yet available"

	^ clientProvider value
		  url: self baseUrl / '/models/imagen-3.0-generate-001:generateContent' ? ( #key -> apiKey );
		  yourself
]

{ #category : 'initialization' }
GeminiImagePrompter >> initializeConnectingWith: aClientProvider using: anAPIKey [

	clientProvider := aClientProvider.
	apiKey := anAPIKey
]

{ #category : 'private - accessing' }
GeminiImagePrompter >> jsonEntityFor: aText [

	^ ZnEntity json: ( '{
  "contents": [{
    "parts":[{"text": "<1s>"}]
    }]
   }' expandMacrosWith: aText )
]

{ #category : 'accessing' }
GeminiImagePrompter >> listModels [

	| client |

	client := clientProvider value
		          url: self baseUrl / 'models' ? ( #key -> apiKey );
		          yourself.
	client get.
	^ NeoJSONObject fromString: client response entity
]

{ #category : 'accessing' }
GeminiImagePrompter >> prompt: aText [

	| client responseEntity |

	client := self httpClient.
	client
		entity: ( self jsonEntityFor: aText );
		contentType: ZnMimeType applicationJson.
	client post.
	responseEntity := NeoJSONObject fromString: client response entity.

	^ responseEntity
		  at: 'candidates'
		  ifPresent: [ :candidates |
				  ( candidates collect: [ :candidate | ( candidate at: 'content' ) at: 'parts' ] ) flattened ]
		  ifAbsent: [
				  AssertionFailed signal: ( 'Gemini responded with error: <1s>' expandMacrosWith:
						    ( ( responseEntity at: 'error' ) at: 'message' ) )
			  ]
]
