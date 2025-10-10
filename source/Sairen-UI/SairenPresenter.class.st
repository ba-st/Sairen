Class {
	#name : 'SairenPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'messageInput',
		'messageList',
		'apiKeyInput',
		'tutor',
		'askButton'
	],
	#classVars : [
		'StoredSairenParameters'
	],
	#category : 'Sairen-UI',
	#package : 'Sairen-UI'
}

{ #category : 'accessing' }
SairenPresenter class >> storedSairenParameters [

	StoredSairenParameters ifNil: [ StoredSairenParameters := Dictionary new ].
	^ StoredSairenParameters
]

{ #category : 'private - processing' }
SairenPresenter >> askMessage [

	| message |

	message := messageInput text.
	tutor askAbout: message.

	self updatePresenter
]

{ #category : 'initialization' }
SairenPresenter >> connectPresenters [

	apiKeyInput whenTextChangedDo: [ :newText |
			self storedParameters at: #apiKey put: newText.
			self initializeTutor.
			self updatePresenter
		]
]

{ #category : 'layout' }
SairenPresenter >> defaultLayout [

	^ SpGridLayout build: [ :rowBuilder |
			  rowBuilder
				  beColumnHomogeneous;
				  beRowHomogeneous;
				  add: ( SpGridLayout build: [ :builder |
								    builder
									    beColumnNotHomogeneous;
									    column: 2 expand: true;
									    add: 'API Key';
									    add: apiKeyInput
							    ] );
				  nextRow;
				  add: messageList;
				  nextRow;
				  add: ( SpGridLayout build: [ :builder |
							    builder
								    beColumnNotHomogeneous;
								    column: 2 expand: true;
								    add: 'Message';
								    add: messageInput;
								    add: askButton
						    ] )
		  ]
]

{ #category : 'private - accessing' }
SairenPresenter >> formatAsText: aCollection [

	^ Text streamContents: [ :stream |
			  aCollection do: [ :message |
					  stream withAttribute: TextEmphasis bold do: [ stream nextPutAll: message key capitalized ].
					  stream
						  nextPutAll: ': ';
						  nextPutAll: message value trim;
						  cr
				  ]
		  ]
]

{ #category : 'initialization' }
SairenPresenter >> initializeAPIKeyInput [

	apiKeyInput := self newTextInput.
	apiKeyInput text: ( self storedParameters at: #apiKey ifAbsent: '' )
]

{ #category : 'initialization' }
SairenPresenter >> initializeAskButton [

	askButton := self newButton
		             label: 'Ask';
		             icon: ( self iconNamed: #smallPrintIt );
		             action: [ self askMessage ];
		             yourself
]

{ #category : 'initialization' }
SairenPresenter >> initializeMessageList [

	messageList := self newText.
	self initializeMessages
]

{ #category : 'initialization' }
SairenPresenter >> initializeMessages [

	messageList text:
		( self formatAsText: ( self storedParameters at: #messages ifAbsent: OrderedCollection new ) )
]

{ #category : 'initialization' }
SairenPresenter >> initializePresenters [

	self initializeAPIKeyInput.
	self initializeAskButton.
	messageInput := self newTextInput.
	self initializeMessageList.
	self initializeTutor
]

{ #category : 'initialization' }
SairenPresenter >> initializeTutor [

	tutor := SairenPharoTutor authenticatedWith: apiKeyInput text
]

{ #category : 'initialization' }
SairenPresenter >> initializeWindow: aWindowPresenter [

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
		initialExtent: 600 @ 600;
		windowIcon: ( self iconNamed: #userProfile );
		toolbar: toolbar
]

{ #category : 'private - processing' }
SairenPresenter >> saveConversation [

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

{ #category : 'private - accessing' }
SairenPresenter >> storedParameters [

	^ self class storedSairenParameters
]

{ #category : 'initialization' }
SairenPresenter >> updatePresenter [

	messageList text: ( self formatAsText: tutor conversationMessages ).
	messageInput text: ''
]
