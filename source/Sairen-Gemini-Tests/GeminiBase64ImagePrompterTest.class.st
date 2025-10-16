Class {
	#name : 'GeminiBase64ImagePrompterTest',
	#superclass : 'TestCase',
	#category : 'Sairen-Gemini-Tests',
	#package : 'Sairen-Gemini-Tests'
}

{ #category : 'private - accessing' }
GeminiBase64ImagePrompterTest >> apiKey [

	^ ' abc123'
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

	| prompter response |

	prompter := GeminiBase64ImagePrompter
		            connectingWith: self clientProvider
		            authenticatedWith: self apiKey.
	prompter changeTemperatureTo: 0.1.
	response := prompter prompt: 'Draw Carmen Sandiego?'.
	self assert: response equals: '$IMG_BASE64'
]

{ #category : 'tests' }
GeminiBase64ImagePrompterTest >> testPromptingForImage [

	| prompter response |

	prompter := GeminiBase64ImagePrompter
		            connectingWith: self clientProvider
		            authenticatedWith: self apiKey.
	response := prompter prompt: 'Draw Carmen Sandiego?'.
	self assert: response equals: '$IMG_BASE64'
]

{ #category : 'test support' }
GeminiBase64ImagePrompterTest >> timeout: aNumberOfSeconds [
]

{ #category : 'test support' }
GeminiBase64ImagePrompterTest >> url: urlObject [
]
