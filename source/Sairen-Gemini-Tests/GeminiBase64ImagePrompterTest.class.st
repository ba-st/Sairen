Class {
	#name : 'GeminiBase64ImagePrompterTest',
	#superclass : 'TestCase',
	#instVars : [
		'entity'
	],
	#category : 'Sairen-Gemini-Tests',
	#package : 'Sairen-Gemini-Tests'
}

{ #category : 'private - accessing' }
GeminiBase64ImagePrompterTest >> apiKey [

	^ 'abc123'
]

{ #category : 'private - accessing' }
GeminiBase64ImagePrompterTest >> clientProvider [

	^ [ self ]
]

{ #category : 'test support' }
GeminiBase64ImagePrompterTest >> contentType: mimeType [
]

{ #category : 'test support' }
GeminiBase64ImagePrompterTest >> entity: anObject [

	entity := anObject
]

{ #category : 'test support' }
GeminiBase64ImagePrompterTest >> post [
]

{ #category : 'test support' }
GeminiBase64ImagePrompterTest >> response [

	^ ZnResponse ok:
		  ( ZnEntity text: '{"candidates":[{"content":{"parts":[{"inlineData":{"data":"$IMG_BASE64"}}]}}]}' )
]

{ #category : 'tests' }
GeminiBase64ImagePrompterTest >> testConfiguring [

	| prompter |

	prompter := GeminiBase64ImagePrompter
		            connectingWith: self clientProvider
		            authenticatedWith: self apiKey.
	prompter changeTemperatureTo: 0.1.
	prompter prompt: 'Draw Carmen Sandiego?'.
	self
		assert: entity string
		equals:
		'{"generationConfig": {"responseModalities": ["TEXT", "IMAGE"], "temperature": 0.1}, "contents": [{"parts": [{"text": "Draw Carmen Sandiego?"}]}]}'
]

{ #category : 'tests' }
GeminiBase64ImagePrompterTest >> testPromptingForImage [

	| prompter promptResponse |

	prompter := GeminiBase64ImagePrompter
		            connectingWith: self clientProvider
		            authenticatedWith: self apiKey.
	promptResponse := prompter prompt: 'Draw Carmen Sandiego?'.
	self assert: promptResponse equals: '$IMG_BASE64'
]

{ #category : 'test support' }
GeminiBase64ImagePrompterTest >> timeout: aNumberOfSeconds [
]

{ #category : 'test support' }
GeminiBase64ImagePrompterTest >> url: urlObject [
]
