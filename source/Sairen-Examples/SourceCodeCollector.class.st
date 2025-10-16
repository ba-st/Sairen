Class {
	#name : 'SourceCodeCollector',
	#superclass : 'Object',
	#instVars : [
		'classToSearch',
		'allMethods'
	],
	#category : 'Sairen-Examples-Application',
	#package : 'Sairen-Examples',
	#tag : 'Application'
}

{ #category : 'instance creation' }
SourceCodeCollector class >> searchingOnly: aClass [

	^ self new initializeSearchingOnly: aClass
]

{ #category : 'private - processing' }
SourceCodeCollector >> addAllLocalImplementorsFor: aCompiledMethod to: aCollection [

	aCompiledMethod allLiterals do: [ :literal |
			allMethods do: [ :method |
					( method selector = literal and: [ ( aCollection includes: method ) not ] ) then: [
							aCollection add: method.
							self addAllLocalImplementorsFor: method to: aCollection
						]
				]
		]
]

{ #category : 'initialization' }
SourceCodeCollector >> initializeSearchingOnly: aClass [

	classToSearch := aClass.
	allMethods := classToSearch allMethods
]

{ #category : 'private - accessing' }
SourceCodeCollector >> methodNamed: aSelector in: aClass [

	^ aClass perform: #'>>' with: aSelector asSymbol
]

{ #category : 'private - accessing' }
SourceCodeCollector >> sourceCodeOfAll: methods [

	^ String streamContents: [ :stream |
			  self write: classToSearch asClassOn: stream.
			  stream
				  cr;
				  cr.
			  methods do: [ :method |
					  self write: method asMethodOn: stream.
					  stream
						  cr;
						  cr
				  ]
		  ]
]

{ #category : 'accessing' }
SourceCodeCollector >> sourceCodeOfAllLocalImplementorsFromAll: someSelectors [

	| methods |

	methods := OrderedSet new.
	someSelectors do: [ :selector |
			| startingMethod |

			startingMethod := self methodNamed: selector in: classToSearch.
			methods add: startingMethod.
			self addAllLocalImplementorsFor: startingMethod to: methods
		].
	^ self sourceCodeOfAll: methods
]

{ #category : 'private - processing' }
SourceCodeCollector >> write: aClass asClassOn: aStream [

	aStream nextPutAll: ( 'Class {
	#name : ''<1s>'',
	#superclass : ''<2s>'',
	#category : ''<3s>'',
	#package : ''<4s>'',
	#tag : ''<5s>''
}' expandMacrosWithArguments:
			  { aClass name . aClass superclass name . aClass category . aClass packageName .
				  aClass packageTagName } )
]

{ #category : 'private - processing' }
SourceCodeCollector >> write: aMethod asMethodOn: aStream [

	| sourceCodeLines |

	sourceCodeLines := aMethod sourceCode lines.
	aStream
		nextPutAll: ( '{ #category : ''<1s>'' }
<2s> >> <3s> ['
				  expandMacrosWith: aMethod protocol name
				  with: classToSearch name
				  with: sourceCodeLines first );
		cr.
	sourceCodeLines allButFirst do: [ :line |
			aStream
				nextPutAll: line;
				cr
		].
	aStream nextPut: $]
]
