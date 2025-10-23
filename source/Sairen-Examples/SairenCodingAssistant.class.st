Class {
	#name : 'SairenCodingAssistant',
	#superclass : 'Object',
	#instVars : [
		'apiKey',
		'tutor'
	],
	#classVars : [
		'Current'
	],
	#category : 'Sairen-Examples-Application',
	#package : 'Sairen-Examples',
	#tag : 'Application'
}

{ #category : 'accessing' }
SairenCodingAssistant class >> current [

	Current ifNil: [ Current := super new ].
	^ Current
]

{ #category : 'instance creation' }
SairenCodingAssistant class >> new [

	^ self current
]

{ #category : 'accessing' }
SairenCodingAssistant >> apiKey [

	^ apiKey
]

{ #category : 'configuring' }
SairenCodingAssistant >> changeAPIKeyTo: aString [

	apiKey := aString.
	self initializeTutor
]

{ #category : 'initialization' }
SairenCodingAssistant >> initialize [

	super initialize.
	apiKey := ''.
	self initializeTutor
]

{ #category : 'initialization' }
SairenCodingAssistant >> initializeTutor [

	tutor := SairenPharoTutor authenticatedWith: apiKey
]

{ #category : 'accessing' }
SairenCodingAssistant >> tutor [

	^ tutor
]
