"
Specific protocol for Gemini image prompting.
"
Class {
	#name : 'GeminiBase64ImagePrompter',
	#superclass : 'GeminiPrompterBehavior',
	#category : 'Sairen-Gemini',
	#package : 'Sairen-Gemini'
}

{ #category : 'initialization' }
GeminiBase64ImagePrompter >> initializeConnectingWith: aClientProvider using: anAPIKey [

	super initializeConnectingWith: aClientProvider using: anAPIKey.
	self currentConfiguration at: 'responseModalities' put: { 'TEXT' . 'IMAGE' }
]

{ #category : 'initialization' }
GeminiBase64ImagePrompter >> initializeModelName [

	self changeModelNameTo: 'gemini-2.0-flash-preview-image-generation'
]

{ #category : 'private - accessing' }
GeminiBase64ImagePrompter >> promptUsing: anEntity [

	| responseEntity |

	responseEntity := self postResponseFor: anEntity.
	^ responseEntity
		  at: #candidates
		  ifPresent: [ :candidates | candidates first content parts last inlineData data ]
		  ifAbsent: [
				  responseEntity
					  at: #error
					  ifPresent: [ :error | AssertionFailed signal: error message ]
					  ifAbsent: [
							  AssertionFailed signal:
								  ( 'Unexpected response structure: <1s>' expandMacrosWith: responseEntity ) ]
			  ]
]
