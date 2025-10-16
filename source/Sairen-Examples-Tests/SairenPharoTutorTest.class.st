Class {
	#name : 'SairenPharoTutorTest',
	#superclass : 'TestCase',
	#category : 'Sairen-Examples-Tests',
	#package : 'Sairen-Examples-Tests'
}

{ #category : 'tests' }
SairenPharoTutorTest >> testPrompting [

	self
		assert: ( ( SairenPharoTutor authenticatedWith: 'YOUR_API_KEY' ) askAbout: 'What is Pharo?' )
		equals:
		'Server responded HTTP/1.1 404 Not Found to https://generativelanguage.googleapis.com:443/v1beta/models/:generateContent?key=YOUR_API_KEY'
]
