Class {
	#name : 'SairenMethodExplainerTest',
	#superclass : 'TestCase',
	#category : 'Sairen-Examples-Tests',
	#package : 'Sairen-Examples-Tests'
}

{ #category : 'tests' }
SairenMethodExplainerTest >> testPrompting [

	self
		assert: ( ( SairenMethodExplainer authenticatedWith: 'YOUR_API_KEY' )
				  explainAll: ( Array with: '<' )
				  in: String )
		equals:
		'Server responded HTTP/1.1 404 Not Found to https://generativelanguage.googleapis.com:443/v1beta/models/:generateContent?key=YOUR_API_KEY'
]
