Class {
	#name : 'SairenMethodExplainerTest',
	#superclass : 'TestCase',
	#category : 'Sairen-Examples-Tests',
	#package : 'Sairen-Examples-Tests'
}

{ #category : 'tests' }
SairenMethodExplainerTest >> testPrompting [

	self
		assert: ( ( SairenMethodExplainer authenticatedWith: 'YOUR_API_KEY' ) explain: '<' in: String )
		equals: 'Gemini responded with error: API key not valid. Please pass a valid API key.'
]
