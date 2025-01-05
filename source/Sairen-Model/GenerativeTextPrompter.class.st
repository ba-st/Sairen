Class {
	#name : 'GenerativeTextPrompter',
	#superclass : 'Object',
	#category : 'Sairen-Model',
	#package : 'Sairen-Model'
}

{ #category : 'instance creation' }
GenerativeTextPrompter class >> authenticatedWith: aToken [

	^ self connectingWith: self defaultHTTPClientProvider authenticatedWith: aToken
]

{ #category : 'instance creation' }
GenerativeTextPrompter class >> connectingWith: aClientProvider authenticatedWith: aToken [

	^ self new initializeConnectingWith: aClientProvider using: aToken
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
GenerativeTextPrompter >> initializeConnectingWith: aClientProvider using: aToken [

	self subclassResponsibility
]

{ #category : 'accessing' }
GenerativeTextPrompter >> prompt: aText [

	^ self subclassResponsibility
]
