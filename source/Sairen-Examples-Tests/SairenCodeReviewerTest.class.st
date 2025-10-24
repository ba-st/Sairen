Class {
	#name : 'SairenCodeReviewerTest',
	#superclass : 'TestCase',
	#category : 'Sairen-Examples-Tests',
	#package : 'Sairen-Examples-Tests'
}

{ #category : 'tests' }
SairenCodeReviewerTest >> testPrompting [

	self
		assert: ( ( SairenCodeReviewer authenticatedWith: 'YOUR_API_KEY' ) requestReviewOfCodeIn:
				  'YOUR_PROJECT_LOCATION' )
		equals:
		'Server responded HTTP/1.1 404 Not Found to https://generativelanguage.googleapis.com:443/v1beta/models/:generateContent?key=YOUR_API_KEY'
]
