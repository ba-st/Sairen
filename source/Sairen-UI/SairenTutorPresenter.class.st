Class {
	#name : 'SairenTutorPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'messageInput',
		'messageList',
		'apiKeyInput',
		'tutor',
		'askButton'
	],
	#category : 'Sairen-UI',
	#package : 'Sairen-UI'
}

{ #category : 'private - processing' }
SairenTutorPresenter >> askMessage [

	| message |

	message := messageInput text.
	messageList text: ( Text streamContents: [ :stream |
				  stream
					  nextPutAll: messageList text;
					  cr;
					  nextPutAll: 'Waiting for model response of ';
					  withAttribute: TextEmphasis bold do: [ stream nextPutAll: message ];
					  nextPutAll: '...'
			  ] ).
	[
		tutor askAbout: message.
		self updatePresenter
	] fork
]

{ #category : 'initialization' }
SairenTutorPresenter >> connectPresenters [

	apiKeyInput whenTextChangedDo: [ :newText |
			UIManager default inform: 'Updating API key and choosing the best model. Please wait'.
			[
				SairenParameters current changeAPIKeyTo: newText.
				self initializeTutor.
				self updatePresenter
			] fork
		]
]

{ #category : 'layout' }
SairenTutorPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'API Key' expand: false;
		  add: apiKeyInput expand: false;
		  add: 'Message' expand: false;
		  add: messageInput expand: false;
		  add: askButton expand: false;
		  add: 'Chat' expand: false;
		  add: messageList;
		  yourself
]

{ #category : 'private - accessing' }
SairenTutorPresenter >> formatAsText: aCollection [

	^ Text streamContents: [ :stream |
			  aCollection doWithIndex: [ :message :index |
					  ( index > 1 and: [ message key = 'user' ] ) then: [ stream cr ].
					  stream withAttribute: TextEmphasis bold do: [ stream nextPutAll: message key capitalized ].
					  stream
						  nextPutAll: ': ';
						  nextPutAll: message value trim;
						  cr
				  ]
		  ]
]

{ #category : 'initialization' }
SairenTutorPresenter >> initializeAPIKeyInput [

	apiKeyInput := self newTextInput bePassword.
	apiKeyInput text: SairenParameters current apiKey
]

{ #category : 'initialization' }
SairenTutorPresenter >> initializeAskButton [

	askButton := self newButton
		             label: 'Ask';
		             icon: ( self iconNamed: #smallPrintIt );
		             action: [ self askMessage ];
		             yourself
]

{ #category : 'initialization' }
SairenTutorPresenter >> initializeMessageList [

	messageList := self newText beNotEditable.
	self initializeMessages
]

{ #category : 'initialization' }
SairenTutorPresenter >> initializeMessages [

	messageList text: ( self formatAsText: OrderedCollection new )
]

{ #category : 'initialization' }
SairenTutorPresenter >> initializePresenters [

	self initializeAPIKeyInput.
	self initializeAskButton.
	messageInput := self newTextInput.
	self initializeMessageList.
	self initializeTutor
]

{ #category : 'initialization' }
SairenTutorPresenter >> initializeTutor [

	tutor := SairenParameters current tutor
]

{ #category : 'initialization' }
SairenTutorPresenter >> initializeWindow: aWindowPresenter [

	| addButton toolbar |

	super initializeWindow: aWindowPresenter.
	addButton := self newToolbarButton
		             label: 'Save';
		             icon: ( self iconNamed: #smallSave );
		             action: [ self saveConversation ];
		             yourself.
	toolbar := self newToolbar
		           add: addButton;
		           yourself.
	aWindowPresenter
		title: 'Sairen Pharo tutor';
		initialExtent: 600 @ 800;
		windowIcon: SairenIcons sairenIcon;
		toolbar: toolbar
]

{ #category : 'private - processing' }
SairenTutorPresenter >> saveConversation [

	| givenName |

	givenName := UIManager default
		             chooseForSaveFileReference: 'Where do you want to save the conversation?'
		             extensions: #( 'json' )
		             path: 'Sairen Conversation' asFileReference.

	givenName ifNotNil: [
			givenName writeStream
				nextPutAll: ( tutor conversationMessages collect: [ :message |
								  Dictionary new
									  add: message;
									  yourself
							  ] ) asJson;
				close
		]
]

{ #category : 'initialization' }
SairenTutorPresenter >> updatePresenter [

	messageList text: ( self formatAsText: tutor conversationMessages ).
	messageInput text: ''
]
