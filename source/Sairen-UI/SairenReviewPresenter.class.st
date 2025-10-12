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

{ #category : 'configuring' }
SairenReviewPresenter >> configureToShow: aString asReviewOfAll: somePackageNames [

	packageNames := somePackageNames.
	reviewPresenter text: aString
]

{ #category : 'layout' }
SairenReviewPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: reviewPresenter;
		  yourself
]

{ #category : 'initialization' }
SairenReviewPresenter >> initializePresenters [

	reviewPresenter := self newText
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
