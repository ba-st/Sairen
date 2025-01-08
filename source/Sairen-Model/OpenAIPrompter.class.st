Class {
	#name : 'OpenAIPrompter',
	#superclass : 'GenerativeTextPrompter',
	#instVars : [
		'clientProvider',
		'apiKey'
	],
	#category : 'Sairen-Model',
	#package : 'Sairen-Model'
}

{ #category : 'accessing' }
OpenAIPrompter >> availableModels [

	^ ( ( self get: self baseUrl / 'models' ) at: 'data' ) collect: [ :json | json at: 'id' ]
]

{ #category : 'private - accessing' }
OpenAIPrompter >> baseUrl [

	^ 'https://api.openai.com/v1/' asUrl
]

{ #category : 'accessing' }
OpenAIPrompter >> billingUsage [

	^ self get: self baseUrl / 'dashboard/billing/usage'
]

{ #category : 'private - accessing' }
OpenAIPrompter >> get: anUrl [

	| client |

	client := clientProvider value
		          url: anUrl;
		          yourself.
	client request setAuthorization: ( 'Bearer <1s>' expandMacrosWith: apiKey ).
	client get.

	^ NeoJSONObject fromString: client response entity
]

{ #category : 'initialization' }
OpenAIPrompter >> initializeConnectingWith: aClientProvider using: anAPIKey [

	clientProvider := aClientProvider.
	apiKey := anAPIKey
]

{ #category : 'accessing' }
OpenAIPrompter >> prompt: aText [

	| client |

	client := clientProvider value
		          url: self baseUrl / 'chat/completions';
		          yourself.
	client request setAuthorization: ( 'Bearer <1s>' expandMacrosWith: apiKey ).
	client entity: ( ZnEntity json: ( '{
  "model": "gpt-4o-mini",
  "messages": [
    {
      "role": "user",
      "content": "<1s>"
    }
  ],
  "temperature": 0.7
}' expandMacrosWith: aText ) ).
	client post.

	^ client response entity
]
