Class {
	#name : 'SairenCodeReviewCommand',
	#superclass : 'ClyBrowserCommand',
	#instVars : [
		'packages'
	],
	#category : 'Sairen-UI',
	#package : 'Sairen-UI'
}

{ #category : 'activation' }
SairenCodeReviewCommand class >> fullBrowserMenuActivation [
	<classAnnotation>

	^CmdContextMenuActivation byRootGroupItemFor: ClyFullBrowserPackageContext
]

{ #category : 'private - accessing' }
SairenCodeReviewCommand >> apiKey [

	| apiKey |

	apiKey := SairenPresenter storedSairenParameters at: #apiKey ifAbsent: ''.
	apiKey ifEmpty: [
			apiKey := UIManager default
				          request: 'API key'
				          initialAnswer: ''
				          title: 'API Key not defined. Enter it now to save it'.
			( apiKey notNil and: [ apiKey notEmpty ] ) ifTrue: [
					SairenPresenter storedSairenParameters at: #apiKey put: apiKey ]
		].
	^ apiKey
]

{ #category : 'private - processing' }
SairenCodeReviewCommand >> ask: aReviewer toReview: aProject [

	| codeStream review |

	codeStream := self codeStreamOf: aProject.
	review := aReviewer requestReviewOfCodeIn: codeStream.
	review inspect
]

{ #category : 'private - accessing' }
SairenCodeReviewCommand >> codeStreamOf: aProject [

	| internalStream |

	internalStream := ( String new: 1000 ) writeStream.

	aProject tags do: [ :tag | tag fileOutOn: internalStream ].
	( aProject instVarNamed: #extensionSelectors ) keysAndValuesDo: [ :class :selectors |
			selectors do: [ :selector | class fileOutMethod: selector on: internalStream ] ].
	^ internalStream
]

{ #category : 'accessing' }
SairenCodeReviewCommand >> defaultMenuIconName [
	^#userProfile
]

{ #category : 'accessing' }
SairenCodeReviewCommand >> defaultMenuItemName [

	^ 'Sairen Code Review'
]

{ #category : 'accessing' }
SairenCodeReviewCommand >> description [

	^ 'Perform a generative code review on the selected packages.'
]

{ #category : 'execution' }
SairenCodeReviewCommand >> execute [

	| apiKey reviewer |

	packages ifEmpty: [ ^ UIManager default inform: 'No packages selected' ].
	apiKey := self apiKey.
	reviewer := SairenCodeReviewer authenticatedWith: apiKey.
	packages do: [ :package | self ask: reviewer toReview: package ]
]

{ #category : 'accessing' }
SairenCodeReviewCommand >> packages [

	^ packages
]

{ #category : 'accessing' }
SairenCodeReviewCommand >> packages: anObject [

	packages := anObject
]

{ #category : 'execution' }
SairenCodeReviewCommand >> prepareFullExecutionInContext: aBrowserContext [

	super prepareFullExecutionInContext: aBrowserContext.
	packages := aBrowserContext selectedPackageItems collect: [ :e | e actualObject ]
]
