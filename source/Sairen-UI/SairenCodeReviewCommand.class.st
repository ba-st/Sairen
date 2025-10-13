Class {
	#name : 'SairenCodeReviewCommand',
	#superclass : 'CmdCommand',
	#instVars : [
		'packages'
	],
	#category : 'Sairen-UI',
	#package : 'Sairen-UI'
}

{ #category : 'activation' }
SairenCodeReviewCommand class >> fullBrowserMenuActivation [

	<classAnnotation>
	^ CmdContextMenuActivation byRootGroupItemFor: ClyFullBrowserPackageContext
]

{ #category : 'private - processing' }
SairenCodeReviewCommand >> addCodeStreamOf: aProject to: aStream [

	aProject tags do: [ :tag | tag fileOutOn: aStream ].
	( aProject instVarNamed: #extensionSelectors ) keysAndValuesDo: [ :class :selectors |
			selectors do: [ :selector | class fileOutMethod: selector on: aStream ] ]
]

{ #category : 'private - accessing' }
SairenCodeReviewCommand >> apiKey [

	| apiKey |

	apiKey := SairenParameters current apiKey.
	apiKey ifEmpty: [
			apiKey := UIManager default
				          request: 'API key'
				          initialAnswer: ''
				          title: 'API Key not defined. Enter it now to save it'.
			( apiKey notNil and: [ apiKey notEmpty ] ) ifTrue: [
					SairenParameters current changeAPIKeyTo: apiKey ]
		].
	^ apiKey
]

{ #category : 'accessing' }
SairenCodeReviewCommand >> defaultMenuIconFormSet [

	| form |

	form := SairenIcons sairenIcon.
	^ FormSet extent: form extent depth: form depth forms: ( Array with: form )
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

	packages ifEmpty: [ ^ self inform: 'No packages selected' ].
	apiKey := self apiKey.
	reviewer := SairenCodeReviewer authenticatedWith: apiKey.
	self obtainReviewFrom: reviewer
]

{ #category : 'private - processing' }
SairenCodeReviewCommand >> inform: aString [

	UIManager default inform: aString
]

{ #category : 'private - processing' }
SairenCodeReviewCommand >> obtainReviewFrom: aReviewer [

	| codeStream packageNames review |

	codeStream := ( String new: 1000 ) writeStream.
	packages do: [ :package | self addCodeStreamOf: package to: codeStream ].

	packageNames := packages collect: #name.
	self inform: ( 'Starting review of <1s>. A window will appear with suggestions once it is ready.'
			  expandMacrosWith: ( ( CollectionFormatter separatingWith: ', ' ) format: packageNames ) ).

	[
		review := aReviewer requestReviewOfCodeIn: codeStream.
		SairenSpecApplication show: review asReviewOfAll: packageNames
	] fork
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
