Class {
	#name : 'GeminiChatTest',
	#superclass : 'TestCase',
	#category : 'Sairen-Gemini-Tests',
	#package : 'Sairen-Gemini-Tests'
}

{ #category : 'private - accessing' }
GeminiChatTest >> apiKey [

	^ ' abc123'
]

{ #category : 'private - accessing' }
GeminiChatTest >> clientProvider [

	^ [ self ]
]

{ #category : 'test support' }
GeminiChatTest >> contentType: mimeType [
]

{ #category : 'test support' }
GeminiChatTest >> entity: anObject [
]

{ #category : 'test support' }
GeminiChatTest >> post [
]

{ #category : 'test support' }
GeminiChatTest >> response [

	^ ZnResponse ok: ( ZnEntity text: '{"candidates":[{"content":{"parts":["Rome"]}}]}' )
]

{ #category : 'tests' }
GeminiChatTest >> testAsking [

	| chat response |

	chat := GeminiChat
		        connectingWith: self clientProvider
		        authenticatedWith: self apiKey
		        instructedTo: 'Give honest answers'
		        configuringPrompterWith: [ :prompter |  ].
	response := chat askAbout: 'Where is Carmen Sandiego?'.
	self assert: response equals: 'Rome'
]

{ #category : 'test support' }
GeminiChatTest >> timeout: aNumberOfSeconds [
]

{ #category : 'test support' }
GeminiChatTest >> url: urlObject [
]
