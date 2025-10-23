Class {
	#name : 'SairenCodeReviewerTest',
	#superclass : 'TestCase',
	#category : 'Sairen-Examples-Tests',
	#package : 'Sairen-Examples-Tests'
}

{ #category : 'tests' }
SairenCodeReviewerTest >> testPrompting [

	self
		should: [
				( SairenCodeReviewer authenticatedWith: 'YOUR_API_KEY' ) requestReviewOfCodeIn:
					'YOUR_PROJECT_LOCATION'
			]
		raise: FileDoesNotExistException
]
