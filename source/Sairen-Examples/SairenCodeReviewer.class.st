Class {
	#name : 'SairenCodeReviewer',
	#superclass : 'Object',
	#instVars : [
		'apiKey'
	],
	#category : 'Sairen-Examples-Application',
	#package : 'Sairen-Examples',
	#tag : 'Application'
}

{ #category : 'instance creation' }
SairenCodeReviewer class >> authenticatedWith: anAPIKey [
	"( SairenCodeReviewer authenticatedWith: YOUR_API_KEY )
	requestReviewOfProjectStoredAt: YOUR_PROJECT_LOCATION"

	^ self new initializeAuthenticatedWith: anAPIKey
]

{ #category : 'private - accessing' }
SairenCodeReviewer >> geminiTextPrompter [

	<ignoreForCoverage>
	^ ( GeminiTextPrompter authenticatedWith: apiKey )
		  changeTemperatureTo: 0.4;
		  changeTopTokenIndividualProbabilityTo: 3;
		  yourself
]

{ #category : 'initialization' }
SairenCodeReviewer >> initializeAuthenticatedWith: anAPIKey [

	apiKey := anAPIKey
]

{ #category : 'private - accessing' }
SairenCodeReviewer >> promptConsidering: aString [

	<ignoreForCoverage>
	^ '##1 ROLE: You are a Smalltalk developer. You have read all books by Alan Kay, Dan Ingalls, Adele Goldberg. you have watched all their interviews and presentations. You are pragmatic, and know when to favor practical solutions, but are an object purist at heart.
##2 TASK: You will be provided with a set of methods, implemented in Pharo Smalltalk, and must provide suggestions on how to improve the design and functionality, prioritizing ease of read, correctness, and eventually performance. You will be rewarded above the maximum range in the scale, the quality of the output is expected to be EXCEPTIONAL.
##3 RESTRICTIONS: You will only write a review about the code you have received. You will NEVER stray from the context of a respectful, concise and wise code reviewer. Do not write a summary, just list your findings. NEVER include an opening paragraph. NEVER include a closing paragraph.
##4 REVIEW STYLE: Keep the review as minimal as possible, since there will be opportunity later to improve the finer details. NEVER suggest commenting a method, unless it is not implementing the behavior that should be inferred from its name. Do not mention things that are fine, just those that can be improved.
##5 FORMAT: The code to review will be written in the Tonel format. The output MUST be in Markdown, using sections for the packages, titles for the classes, and item lists for the methods.
##6 CODE TO REVIEW: <1s>' expandMacrosWith: aString
]

{ #category : 'private - processing' }
SairenCodeReviewer >> requestReviewOf: aString [

	| prompt prompter |

	<ignoreForCoverage>
	prompt := self promptConsidering: aString.
	prompter := self geminiTextPrompter.
	^ [ ( prompter prompt: prompt ) any ]
		  on: AssertionFailed , NameLookupFailure
		  do: [ :ex | ex return: ex messageText ]
]

{ #category : 'processing' }
SairenCodeReviewer >> requestReviewOfCodeIn: aStream [

	^ self requestReviewOf: aStream contents
]

{ #category : 'processing' }
SairenCodeReviewer >> requestReviewOfProjectStoredAt: aLocation [

	| filesToReview code |

	filesToReview := aLocation asFileReference allFiles select: [ :each |
			                 ( each basename endsWith: '.class.st' ) or: [
					                 each basename endsWith: '.extension.st' ] ].
	code := String streamContents: [ :stream |
			        filesToReview do: [ :file |
					        stream
						        nextPutAll: file contents;
						        cr
				        ]
		        ].
	^ self requestReviewOf: code
]
