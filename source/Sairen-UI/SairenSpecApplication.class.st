Class {
	#name : 'SairenSpecApplication',
	#superclass : 'SpApplication',
	#category : 'Sairen-UI',
	#package : 'Sairen-UI'
}

{ #category : 'accessing' }
SairenSpecApplication class >> showExplanationOfAll: someMethods authenticatedWith: apiKey [

	( self new newPresenter: SairenMethodExplanationPresenter )
		configureToExplainAll: someMethods authenticatedWith: apiKey;
		open
]

{ #category : 'accessing' }
SairenSpecApplication class >> showReviewOfAll: somePackages authenticatedWith: apiKey [

	( self new newPresenter: SairenReviewPresenter )
		configureToReviewAll: somePackages authenticatedWith: apiKey;
		open
]

{ #category : 'accessing' }
SairenSpecApplication class >> showTutor [

	( self new newPresenter: SairenTutorPresenter ) open
]
