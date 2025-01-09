Class {
	#name : 'GeminiTextPrompter',
	#superclass : 'GenerativeTextPrompter',
	#instVars : [
		'clientProvider',
		'apiKey'
	],
	#category : 'Sairen-Model',
	#package : 'Sairen-Model'
}

{ #category : 'private - accessing' }
GeminiTextPrompter >> baseUrl [

	^ 'https://generativelanguage.googleapis.com/v1beta' asUrl
]

{ #category : 'private - accessing' }
GeminiTextPrompter >> httpClient [

	^ clientProvider value
		  url: self baseUrl / '/models/gemini-1.5-flash:generateContent' ? ( #key -> apiKey );
		  yourself
]

{ #category : 'initialization' }
GeminiTextPrompter >> initializeConnectingWith: aClientProvider using: anAPIKey [

	clientProvider := aClientProvider.
	apiKey := anAPIKey
]

{ #category : 'private - accessing' }
GeminiTextPrompter >> jsonEntityFor: aText [

	^ ZnEntity json: ( '{
  "contents": [{
    "parts":[{"text": "<1s>"}]
    }]
   }' expandMacrosWith: aText )
]

{ #category : 'private - accessing' }
GeminiTextPrompter >> jsonEntityFor: aText whenListeningTo: aBase64Audio [

	^ ZnEntity json: ( '{
  "contents": [{
    "parts":[{"inlineData": {"mimeType":"<1s>","data":"<2s>"}},{"text": "<3s>"}]
    }]
   }' expandMacrosWith: 'audio/ogg' with: aBase64Audio with: aText )
]

{ #category : 'private - accessing' }
GeminiTextPrompter >> jsonEntityFor: aText whenListeningTo: aBase64Audio with: aMimeType [

	^ ZnEntity json: ( '{
  "contents": [{
    "parts":[{"inlineData": {"mimeType":"<1s>","data":"<2s>"}},{"text": "<3s>"}]
    }]
   }' expandMacrosWith: aMimeType with: aBase64Audio with: aText )
]

{ #category : 'accessing' }
GeminiTextPrompter >> prompt: aText [

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

{ #category : 'accessing' }
GeminiTextPrompter >> prompt: aText whenListeningTo: aBase64Audio with: aMimeType [

	| client responseEntity |

	client := self httpClient.
	client
		entity: ( self jsonEntityFor: aText whenListeningTo: aBase64Audio with: aMimeType );
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
