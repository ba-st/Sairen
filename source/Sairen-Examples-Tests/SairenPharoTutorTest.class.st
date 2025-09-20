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
		equals: 'Gemini responded with error: API key not valid. Please pass a valid API key.'
]
