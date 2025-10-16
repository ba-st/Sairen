Class {
	#name : 'SairenMethodExplanationPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'explanationPresenter',
		'methodNames'
	],
	#category : 'Sairen-UI',
	#package : 'Sairen-UI'
}

{ #category : 'configuring' }
SairenMethodExplanationPresenter >> configureToExplainAll: someMethods authenticatedWith: apiKey [

	methodNames := someMethods collect: #name.
	explanationPresenter text: 'Preparing explanation. Please wait...'.

	[
		| explanation |

		explanation := self explainAll: someMethods authenticatedWith: apiKey.
		explanationPresenter text: explanation
	] fork
]

{ #category : 'layout' }
SairenMethodExplanationPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: explanationPresenter;
		  yourself
]

{ #category : 'private - processing' }
SairenMethodExplanationPresenter >> explainAll: someMethods authenticatedWith: apiKey [

	| explainer selectors classes |

	selectors := someMethods collect: #selector.
	classes := someMethods collect: #methodClass.
	classes size > 1 then: [
			AssertionFailed signal:
				'The current implementation can only explain methods from a single class.' ].
			
	explainer := SairenMethodExplainer authenticatedWith: apiKey.
	^ explainer explainAll: selectors in: classes any
]

{ #category : 'initialization' }
SairenMethodExplanationPresenter >> initializePresenters [

	explanationPresenter := self newText beNotEditable
]

{ #category : 'initialization' }
SairenMethodExplanationPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.

	aWindowPresenter
		title: ( 'Sairen explanation of <1s>' expandMacrosWith:
					  ( ( CollectionFormatter separatingWith: ', ' ) format: methodNames ) );
		initialExtent: 600 @ 600;
		windowIcon: SairenIcons sairenIcon
]
