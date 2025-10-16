Class {
	#name : 'SairenMethodExplainerCommand',
	#superclass : 'SycMethodCommand',
	#category : 'Sairen-UI',
	#package : 'Sairen-UI'
}

{ #category : 'activation' }
SairenMethodExplainerCommand class >> methodMenuActivation [

	<classAnnotation>
	^ CmdContextMenuActivation byRootGroupItemFor: ClyMethod asCalypsoItemContext
]

{ #category : 'private - accessing' }
SairenMethodExplainerCommand >> apiKey [

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
SairenMethodExplainerCommand >> defaultMenuIconFormSet [

	| form |

	form := SairenIcons sairenIcon.
	^ FormSet extent: form extent depth: form depth forms: ( Array with: form )
]

{ #category : 'accessing' }
SairenMethodExplainerCommand >> defaultMenuItemName [

	^ 'Sairen Method Explainer'
]

{ #category : 'accessing' }
SairenMethodExplainerCommand >> description [

	^ 'Perform a generative explanation of the selected methods.'
]

{ #category : 'execution' }
SairenMethodExplainerCommand >> execute [

	| apiKey |

	methods ifEmpty: [ ^ UIManager default inform: 'No methods selected' ].
	apiKey := self apiKey.
	SairenSpecApplication showExplanationOfAll: methods authenticatedWith: apiKey
]

{ #category : 'execution' }
SairenMethodExplainerCommand >> prepareFullExecutionInContext: aBrowserContext [

	super prepareFullExecutionInContext: aBrowserContext.
	methods := aBrowserContext selectedMethods
]
