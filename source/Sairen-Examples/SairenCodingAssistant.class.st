Class {
	#name : 'SairenCodingAssistant',
	#superclass : 'Object',
	#instVars : [
		'apiKey'
	],
	#category : 'Sairen-Examples-Application',
	#package : 'Sairen-Examples',
	#tag : 'Application'
}

{ #category : 'instance creation' }
SairenCodingAssistant class >> authenticatedWith: anAPIKey [
	"( SairenCodingAssistant authenticatedWith: YOUR_API_KEY ) requestReviewOfProjectStoredAt: YOUR_PROJECT_LOCATION"
	"( SairenCodingAssistant authenticatedWith: YOUR_API_KEY ) explain: '<' in: String"
	"( SairenCodingAssistant authenticatedWith: YOUR_API_KEY ) askAbout: 'What reserved words does Smalltalk have?'"

	^ self new initializeAuthenticatedWith: anAPIKey
]

{ #category : 'processing' }
SairenCodingAssistant >> askAbout: aQuery [

	| tutor |

	tutor := SairenPharoTutor authenticatedWith: apiKey.
	^ tutor askAbout: aQuery
]

{ #category : 'processing' }
SairenCodingAssistant >> explain: aSelector in: aClass [

	| explainer |

	explainer := SairenMethodExplainer authenticatedWith: apiKey.
	^ explainer explain: aSelector in: aClass
]

{ #category : 'initialization' }
SairenCodingAssistant >> initializeAuthenticatedWith: anAPIKey [

	apiKey := anAPIKey
]

{ #category : 'processing' }
SairenCodingAssistant >> requestReviewOfProjectStoredAt: aLocation [

	| reviewer |

	reviewer := SairenCodeReviewer authenticatedWith: apiKey.
	^ reviewer requestReviewOfProjectStoredAt: aLocation
]
