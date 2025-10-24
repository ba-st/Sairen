Class {
	#name : 'GeminiChatTest',
	#superclass : 'TestCase',
	#category : 'Sairen-Gemini-Tests',
	#package : 'Sairen-Gemini-Tests'
}

{ #category : 'private - accessing' }
GeminiChatTest >> apiKey [

	^ 'abc123'
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
GeminiChatTest >> testChatting [

	| chat response |

	chat := GeminiChat
		        connectingWith: self clientProvider
		        authenticatedWith: self apiKey
		        instructedTo: 'Give honest answers'
		        configuringPrompterWith: [ :prompter |  ].
	self assertEmpty: chat conversationMessages.

	response := chat askAbout: 'Where is Carmen Sandiego?'.
	self assert: response equals: 'Rome'.
	self
		assertCollection: chat conversationMessages
		equals: { 'user' -> 'Where is Carmen Sandiego?' . 'model' -> 'Rome' }.

	response := chat askAbout: 'Where can I get pizza?'.
	self assert: response equals: 'Rome'.
	self
		assertCollection: chat conversationMessages
		equals:
			{ 'user' -> 'Where is Carmen Sandiego?' . 'model' -> 'Rome' . 'user' -> 'Where can I get pizza?' .
				'model' -> 'Rome' }
]

{ #category : 'test support' }
GeminiChatTest >> timeout: aNumberOfSeconds [
]

{ #category : 'test support' }
GeminiChatTest >> url: urlObject [
]
