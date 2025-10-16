Class {
	#name : 'SairenReviewPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'reviewPresenter',
		'packageNames'
	],
	#category : 'Sairen-UI',
	#package : 'Sairen-UI'
}

{ #category : 'private - processing' }
SairenReviewPresenter >> addCodeStreamOf: aProject to: aStream [

	aProject tags do: [ :tag | tag fileOutOn: aStream ].
	( aProject instVarNamed: #extensionSelectors ) keysAndValuesDo: [ :class :selectors |
			selectors do: [ :selector | class fileOutMethod: selector on: aStream ] ]
]

{ #category : 'configuring' }
SairenReviewPresenter >> configureToReviewAll: somePackages authenticatedWith: apiKey [

	packageNames := somePackages collect: #name.
	reviewPresenter text: 'Preparing review. Please wait...'.

	[
		| review |

		review := self reviewAll: somePackages authenticatedWith: apiKey.
		reviewPresenter text: ( self formatAsText: review )
	] fork
]

{ #category : 'layout' }
SairenReviewPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: reviewPresenter;
		  yourself
]

{ #category : 'private - processing' }
SairenReviewPresenter >> formatAsText: aString [

	^ Text streamContents: [ :stream |
			  aString linesDo: [ :line |
					  self write: stream to: line.
					  stream cr
				  ]
		  ]
]

{ #category : 'initialization' }
SairenReviewPresenter >> initializePresenters [

	reviewPresenter := self newText beNotEditable
]

{ #category : 'initialization' }
SairenReviewPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.

	aWindowPresenter
		title: ( 'Sairen review of <1s>' expandMacrosWith:
					  ( ( CollectionFormatter separatingWith: ', ' ) format: packageNames ) );
		initialExtent: 600 @ 600;
		windowIcon: SairenIcons sairenIcon
]

{ #category : 'private - processing' }
SairenReviewPresenter >> reviewAll: somePackages authenticatedWith: apiKey [

	| codeStream reviewer |

	codeStream := ( String new: 1000 ) writeStream.
	somePackages do: [ :package | self addCodeStreamOf: package to: codeStream ].

	reviewer := SairenCodeReviewer authenticatedWith: apiKey.
	^ reviewer requestReviewOfCodeIn: codeStream
]

{ #category : 'private - processing' }
SairenReviewPresenter >> write: stream to: line [

	| firstPart |

	firstPart := ( line copyReplaceAll: ' class' with: 'ñclass' ) copyUpTo: Character space.

	( ( firstPart includesSubstring: '>>#' ) or: [ { 'Issue:' . 'Suggestion:' } includes: firstPart ] )
		then: [
				stream
					withAttribute: TextEmphasis bold
					do: [ stream nextPutAll: ( line copyFirst: firstPart size ) ].
				stream nextPutAll: ( line allButFirst: firstPart size )
			]
		otherwise: [ stream nextPutAll: line ]
]
