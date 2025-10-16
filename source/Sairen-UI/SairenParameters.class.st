Class {
	#name : 'SairenParameters',
	#superclass : 'Object',
	#instVars : [
		'apiKey',
		'tutor'
	],
	#classVars : [
		'Current'
	],
	#category : 'Sairen-UI',
	#package : 'Sairen-UI'
}

{ #category : 'accessing' }
SairenParameters class >> current [

	Current ifNil: [ Current := super new ].
	^ Current
]

{ #category : 'accessing' }
SairenParameters class >> new [

	^ self current
]

{ #category : 'accessing' }
SairenParameters >> apiKey [

	^ apiKey
]

{ #category : 'configuring' }
SairenParameters >> changeAPIKeyTo: aString [

	apiKey := aString.
	self initializeTutor
]

{ #category : 'initialization' }
SairenParameters >> initialize [

	super initialize.
	apiKey := ''.
	self initializeTutor
]

{ #category : 'initialization' }
SairenParameters >> initializeTutor [

	tutor := SairenPharoTutor authenticatedWith: apiKey
]

{ #category : 'accessing' }
SairenParameters >> tutor [

	^ tutor
]
