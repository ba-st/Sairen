Class {
	#name : 'OllamaChatTest',
	#superclass : 'TestCase',
	#category : 'Sairen-Ollama-Tests',
	#package : 'Sairen-Ollama-Tests'
}

{ #category : 'private - accessing' }
OllamaChatTest >> clientProvider [

	^ [ self ]
]

{ #category : 'test support' }
OllamaChatTest >> contentType: mimeType [
]

{ #category : 'test support' }
OllamaChatTest >> entity: anObject [
]

{ #category : 'test support' }
OllamaChatTest >> post [
]

{ #category : 'test support' }
OllamaChatTest >> response [

	^ ZnResponse ok: ( ZnEntity text: '{"choices":[{"message":{"content":["Rome"]}}]}' )
]

{ #category : 'tests' }
OllamaChatTest >> testChatting [

	| chat response |

	chat := OllamaChat
		        connectingWith: self clientProvider
		        authenticatedWith: ''
		        instructedTo: 'Give honest answers'
		        configuringPrompterWith: [ :prompter | prompter setModelTo: 'test-model' ].
	self assertCollection: chat conversationMessages equals: { 'system' -> 'Give honest answers' }.

	response := chat askAbout: 'Where is Carmen Sandiego?'.
	self assert: response equals: 'Rome'.
	self
		assertCollection: chat conversationMessages
		equals: { 'system' -> 'Give honest answers' . 'user' -> 'Where is Carmen Sandiego?' .
				'assistant' -> 'Rome' }.

	response := chat askAbout: 'Where can I get pizza?'.
	self assert: response equals: 'Rome'.
	self
		assertCollection: chat conversationMessages
		equals: { 'system' -> 'Give honest answers' . 'user' -> 'Where is Carmen Sandiego?' .
				'assistant' -> 'Rome' . 'user' -> 'Where can I get pizza?' . 'assistant' -> 'Rome' }
]

{ #category : 'test support' }
OllamaChatTest >> timeout: aNumberOfSeconds [
]

{ #category : 'test support' }
OllamaChatTest >> url: urlObject [
]
