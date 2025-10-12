Class {
	#name : 'SairenSpecApplication',
	#superclass : 'SpApplication',
	#category : 'Sairen-UI',
	#package : 'Sairen-UI'
}

{ #category : 'accessing' }
SairenSpecApplication class >> open [

	( self new newPresenter: SairenTutorPresenter ) open
]

{ #category : 'accessing' }
SairenSpecApplication class >> show: aString asReviewOfAll: somePackageNames [

	( self new newPresenter: SairenReviewPresenter )
		configureToShow: aString asReviewOfAll: somePackageNames;
		open
]
