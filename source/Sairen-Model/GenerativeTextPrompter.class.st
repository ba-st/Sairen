Class {
	#name : 'GenerativeTextPrompter',
	#superclass : 'Object',
	#category : 'Sairen-Model',
	#package : 'Sairen-Model'
}

{ #category : 'instance creation' }
GenerativeTextPrompter class >> authenticatedWith: anAPIKey [

	^ self connectingWith: self defaultHTTPClientProvider authenticatedWith: anAPIKey
]

{ #category : 'instance creation' }
GenerativeTextPrompter class >> connectingWith: aClientProvider authenticatedWith: anAPIKey [

	^ self new initializeConnectingWith: aClientProvider using: anAPIKey
]

{ #category : 'private - accessing' }
GenerativeTextPrompter class >> defaultHTTPClientProvider [

	^ [
		  ZnClient new
			  beOneShot;
			  yourself
	  ]
]

{ #category : 'initialization' }
GenerativeTextPrompter >> initializeConnectingWith: aClientProvider using: anAPIKey [

	self subclassResponsibility
]

{ #category : 'accessing' }
GenerativeTextPrompter >> prompt: aText [

	^ self subclassResponsibility
]
