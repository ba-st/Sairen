"
Common superclass for all LLM providers. The protocol here must be kept to a minimum, and configuration must be specified in the subclasses.
"
Class {
	#name : 'GenerativePrompter',
	#superclass : 'Object',
	#category : 'Sairen-Model',
	#package : 'Sairen-Model'
}

{ #category : 'instance creation' }
GenerativePrompter class >> authenticatedWith: anAPIKey [

	^ self connectingWith: self defaultHTTPClientProvider authenticatedWith: anAPIKey
]

{ #category : 'instance creation' }
GenerativePrompter class >> connectingWith: aClientProvider authenticatedWith: anAPIKey [

	^ self new initializeConnectingWith: aClientProvider using: anAPIKey
]

{ #category : 'private - accessing' }
GenerativePrompter class >> defaultHTTPClientProvider [

	^ [
		  ZnClient new
			  beOneShot;
			  yourself
	  ]
]

{ #category : 'initialization' }
GenerativePrompter >> initializeConnectingWith: aClientProvider using: anAPIKey [

	self subclassResponsibility
]

{ #category : 'accessing' }
GenerativePrompter >> prompt: aText [

	^ self subclassResponsibility
]
