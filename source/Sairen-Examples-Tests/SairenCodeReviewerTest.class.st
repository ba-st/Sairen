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
				( SairenCodingAssistant authenticatedWith: 'YOUR_API_KEY' ) requestReviewOfProjectStoredAt:
					'YOUR_PROJECT_LOCATION'
			]
		raise: FileDoesNotExistException
]
