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
	#classVars : [
		'StoredSairenParameters'
	],
	#category : 'Sairen-UI',
	#package : 'Sairen-UI'
}

{ #category : 'accessing' }
SairenTutorPresenter class >> storedSairenParameters [

	StoredSairenParameters ifNil: [ StoredSairenParameters := Dictionary new ].
	^ StoredSairenParameters
]

{ #category : 'private - processing' }
SairenTutorPresenter >> askMessage [

	| message |

	UIManager default inform: 'Waiting for model response'.

	message := messageInput text.

	[
		tutor askAbout: message.
		self updatePresenter
	] fork
]

{ #category : 'initialization' }
SairenTutorPresenter >> connectPresenters [

	apiKeyInput whenTextChangedDo: [ :newText |
			self storedParameters at: #apiKey put: newText.
			self initializeTutor.
			self updatePresenter
		]
]

{ #category : 'layout' }
SairenTutorPresenter >> defaultLayout [

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
SairenTutorPresenter >> formatAsText: aCollection [

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
SairenTutorPresenter >> initializeAPIKeyInput [

	apiKeyInput := self newTextInput.
	apiKeyInput text: ( self storedParameters at: #apiKey ifAbsent: '' )
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

	messageList := self newText.
	self initializeMessages
]

{ #category : 'initialization' }
SairenTutorPresenter >> initializeMessages [

	messageList text:
		( self formatAsText: ( self storedParameters at: #messages ifAbsent: OrderedCollection new ) )
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

	tutor := SairenPharoTutor authenticatedWith: apiKeyInput text
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
		initialExtent: 600 @ 600;
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

{ #category : 'private - accessing' }
SairenTutorPresenter >> storedParameters [

	^ self class storedSairenParameters
]

{ #category : 'initialization' }
SairenTutorPresenter >> updatePresenter [

	messageList text: ( self formatAsText: tutor conversationMessages ).
	messageInput text: ''
]
