Class {
	#name : 'OllamaPrompterTest',
	#superclass : 'TestCase',
	#instVars : [
		'entity',
		'url'
	],
	#category : 'Sairen-Ollama-Tests',
	#package : 'Sairen-Ollama-Tests'
}

{ #category : 'private - accessing' }
OllamaPrompterTest >> clientProvider [

	^ [ self ]
]

{ #category : 'test support' }
OllamaPrompterTest >> contentType: mimeType [
]

{ #category : 'test support' }
OllamaPrompterTest >> entity: anObject [

	entity := anObject
]

{ #category : 'test support' }
OllamaPrompterTest >> post [
]

{ #category : 'test support' }
OllamaPrompterTest >> response [

	^ ZnResponse ok: ( ZnEntity text: '{"choices":[{"message":{"content":["Rome"]}}]}' )
]

{ #category : 'tests' }
OllamaPrompterTest >> testConfiguring [

	| prompter |

	prompter := OllamaPrompter connectingWith: self clientProvider authenticatedWith: ''.
	prompter setModelTo: 'the-test'.
	prompter prompt: 'Where is Carmen Sandiego?'.
	self
		assert: entity string
		equals:
		'{"model": "the-test", "messages": [{"content": "Where is Carmen Sandiego?", "role": "user"}]}'
]

{ #category : 'tests' }
OllamaPrompterTest >> testModelMustBeChosenBeforePrompting [

	| prompter |

	prompter := OllamaPrompter connectingWith: self clientProvider authenticatedWith: ''.
	self
		should: [ prompter prompt: 'A question' ]
		raise: AssertionFailed
		withMessageText: 'No model chosen yet'
]

{ #category : 'tests' }
OllamaPrompterTest >> testPromptingCustomizedContent [

	| prompter parameters promptResponse |

	prompter := OllamaPrompter connectingWith: self clientProvider authenticatedWith: ''.
	prompter setModelTo: 'test-model'.
	parameters := Dictionary new
		              at: 'messages' put: { Dictionary new
					              at: 'role' put: 'system';
					              at: 'content' put: 'Give honest answers';
					              yourself . Dictionary new
					              at: 'role' put: 'user';
					              at: 'content' put: 'Where is Carmen Sandiego?';
					              yourself };
		              yourself.
	promptResponse := prompter promptBasedOn: parameters.
	self
		assert: entity string
		equals:
		'{"model": "test-model", "messages": [{"content": "Give honest answers", "role": "system"}, {"content": "Where is Carmen Sandiego?", "role": "user"}]}'
]

{ #category : 'test support' }
OllamaPrompterTest >> timeout: aNumberOfSeconds [
]

{ #category : 'test support' }
OllamaPrompterTest >> url: urlObject [

	url := urlObject
]
