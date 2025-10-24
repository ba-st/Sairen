"
A prompter to request jobs to Cursor.
"
Class {
	#name : 'CursorPrompter',
	#superclass : 'GenerativePrompter',
	#instVars : [
		'clientProvider',
		'apiKey',
		'repositoryBinding'
	],
	#category : 'Sairen-Cursor',
	#package : 'Sairen-Cursor'
}

{ #category : 'private - accessing' }
CursorPrompter >> baseUrl [

	^ 'https://api.cursor.com' asUrl
]

{ #category : 'private - accessing' }
CursorPrompter >> flattenedPartsFrom: responseEntity [

	^ responseEntity
]

{ #category : 'private - accessing' }
CursorPrompter >> getStatusOf: anAgentId [

	| client |

	client := clientProvider value
		          url: self baseUrl / 'v0/agents' / anAgentId;
		          setBearerAuthentication: apiKey;
		          yourself.
	client get.
	^ NeoJSONObject fromString: client response entity
]

{ #category : 'private - accessing' }
CursorPrompter >> httpClient [

	^ clientProvider value
		  url: self baseUrl / 'v0/agents';
		  setBearerAuthentication: apiKey;
		  yourself
]

{ #category : 'initialization' }
CursorPrompter >> initializeConnectingWith: aClientProvider using: anAPIKey [

	"( CursorPrompter
		  connectingWith: CursorPrompter defaultHTTPClientProvider
		  authenticatedWith: 'YOUR_CURSOR_API_KEY' )
		setRepositoryTo: 'YOUR_REPO_URL';
		prompt: 'Suggest the content of a Smalltalk method that prints Hello World'."

	clientProvider := aClientProvider.
	apiKey := anAPIKey.
	repositoryBinding := Binding undefinedExplainedBy: 'No repository chosen yet'
]

{ #category : 'private - accessing' }
CursorPrompter >> jsonEntityBasedOn: aDictionary [

	^ ZnEntity json: aDictionary asJson
]

{ #category : 'private - accessing' }
CursorPrompter >> parametersForPromptingJust: aText [

	^ { 'prompt' -> { 'text' -> aText } asDictionary . 'source'
		  -> { 'repository' -> repositoryBinding content } asDictionary } asDictionary
]

{ #category : 'private - accessing' }
CursorPrompter >> postResponseFor: anEntity [

	| client |

	client := self httpClient.
	client
		entity: anEntity;
		contentType: ZnMimeType applicationJson.
	client post.
	^ NeoJSONObject fromString: client response entity
]

{ #category : 'accessing' }
CursorPrompter >> prompt: aText [

	| parameters |

	parameters := self parametersForPromptingJust: aText.
	^ self promptUsing: ( self jsonEntityBasedOn: parameters )
]

{ #category : 'private - accessing' }
CursorPrompter >> promptUsing: anEntity [

	| responseEntity agentId |

	responseEntity := self postResponseFor: anEntity.
	agentId := responseEntity at: #id.

	^ '	( CursorPrompter
		  connectingWith: CursorPrompter defaultHTTPClientProvider
		  authenticatedWith: ''YOUR_CURSOR_API_KEY'' )
getStatusOf: <1p>' expandMacrosWith: agentId
]

{ #category : 'configuring' }
CursorPrompter >> setRepositoryTo: aGithubURL [

	repositoryBinding := Binding to: aGithubURL
]
