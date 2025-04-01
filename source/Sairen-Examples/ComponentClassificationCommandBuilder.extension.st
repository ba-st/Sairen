Extension { #name : 'ComponentClassificationCommandBuilder' }

{ #category : '*Sairen-Examples' }
ComponentClassificationCommandBuilder >> apiKey [

	^ self commandStyledWith: #apiKey
]

{ #category : '*Sairen-Examples' }
ComponentClassificationCommandBuilder >> poem [

	^ self commandStyledWith: #poem
]

{ #category : '*Sairen-Examples' }
ComponentClassificationCommandBuilder >> sairenApps [

	classificationNamespace := classificationNamespace >> #sairenApps
]

{ #category : '*Sairen-Examples' }
ComponentClassificationCommandBuilder >> translator [

	^ self commandStyledWith: #translator
]
