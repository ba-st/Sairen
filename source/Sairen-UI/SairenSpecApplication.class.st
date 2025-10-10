Class {
	#name : 'SairenSpecApplication',
	#superclass : 'SpApplication',
	#category : 'Sairen-UI',
	#package : 'Sairen-UI'
}

{ #category : 'accessing' }
SairenSpecApplication class >> open [

	( self new newPresenter: SairenPresenter ) open
]
