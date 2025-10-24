"
Pharo component to offer a menu that calls upon the code reviewer.
"
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

{ #category : 'private - accessing' }
SairenCodeReviewCommand >> apiKey [

	| apiKey |

	apiKey := SairenCodingAssistant current apiKey.
	apiKey ifEmpty: [
			apiKey := UIManager default
				          request: 'API key'
				          initialAnswer: ''
				          title: 'API Key not defined. Enter it now to save it'.
			( apiKey notNil and: [ apiKey notEmpty ] ) ifTrue: [
					SairenCodingAssistant current changeAPIKeyTo: apiKey ]
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

	| apiKey |

	packages ifEmpty: [ ^ UIManager default inform: 'No packages selected' ].
	apiKey := self apiKey.
	SairenSpecApplication showReviewOfAll: packages authenticatedWith: apiKey
]

{ #category : 'execution' }
SairenCodeReviewCommand >> prepareFullExecutionInContext: aBrowserContext [

	super prepareFullExecutionInContext: aBrowserContext.
	packages := aBrowserContext selectedPackageItems collect: [ :e | e actualObject ]
]
