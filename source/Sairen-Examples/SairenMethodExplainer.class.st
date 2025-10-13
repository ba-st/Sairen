Class {
	#name : 'SairenMethodExplainer',
	#superclass : 'Object',
	#instVars : [
		'apiKey'
	],
	#category : 'Sairen-Examples-Application',
	#package : 'Sairen-Examples',
	#tag : 'Application'
}

{ #category : 'instance creation' }
SairenMethodExplainer class >> authenticatedWith: anAPIKey [
	"( SairenMethodExplainer authenticatedWith: YOUR_API_KEY ) explain: '<' in: String"

	^ self new initializeAuthenticatedWith: anAPIKey
]

{ #category : 'processing' }
SairenMethodExplainer >> explain: aSelector in: aClass [

	| collector code |

	collector := SourceCodeCollector searchingOnly: aClass.
	code := collector sourceCodeOfAllLocalImplementorsFrom: aSelector.
	^ self explain: aSelector knowingAbout: code
]

{ #category : 'private - processing' }
SairenMethodExplainer >> explain: aSelector knowingAbout: code [

	<ignoreForCoverage>
	| prompt prompter |

	prompt := self promptToExplain: aSelector knowingAbout: code.
	prompter := self geminiTextPrompter.
	^ [ ( prompter prompt: prompt ) any ]
		  on: AssertionFailed , NameLookupFailure
		  do: [ :ex | ex return: ex messageText ]
]

{ #category : 'private - accessing' }
SairenMethodExplainer >> geminiTextPrompter [

	<ignoreForCoverage>
	^ ( GeminiTextPrompter authenticatedWith: apiKey )
		  changeTemperatureTo: 0.4;
		  changeTopTokenIndividualProbabilityTo: 3;
		  chooseMostPotentModel;
		  yourself
]

{ #category : 'initialization' }
SairenMethodExplainer >> initializeAuthenticatedWith: anAPIKey [

	apiKey := anAPIKey
]

{ #category : 'private - accessing' }
SairenMethodExplainer >> promptToExplain: aSelector knowingAbout: code [

	<ignoreForCoverage>
	^ '##1 ROLE: You are a Smalltalk developer. You have read all books by Alan Kay, Dan Ingalls, Adele Goldberg. you have watched all their interviews and presentations. You are pragmatic, and know when to favor practical solutions, but are an object purist at heart.
##2 TASK: You will be provided with a set of methods, implemented in Pharo Smalltalk, and pointed out to one of them. You must provide a high level explanation of what method does, ONLY THAT ONE, the rest of the code is only to give context, they represent methods implemented in the same hierarchy. In case the implementation details of methods not provided are required, use your best guess about what they do, and how, based on their name. Pay special attention to calls to other classes, make sure the analysis mentions them, and give your best guess about what they are used for in the context of the initial method. You will be rewarded above the maximum range in the scale, the quality of the output is expected to be EXCEPTIONAL.
##3 RESTRICTIONS:
* You will ONLY write an explanation about the method request.
* You will NEVER stray from the context of a respectful, concise and wise developer colleague.
* NEVER include an opening paragraph.
* NEVER include a closing paragraph.
* DO NOT include the source code of the method in your response, only the explanation.
* DO NOT express doubt, write in an assertive tone. If you don''t know something, say so clearly.
* DO NOT make the answer longer than required. The person who requested the job already knows the name of the method and the task you set out to do. Just give the answer.
* DO NOT talk about the implementation, and DO NOT mention the method selectors, but rather, explain in a colloquial way the observed behavior of the method, in the context of the known source code received.
##4 EXPLANATION STYLE: Keep the explanation to a minimum, since there will be opportunity later to improve the finer details.
##5 FORMAT: The code will be written in the Tonel format.
##6 METHOD TO EXPLAIN: <1s>
##7 KNOWN IMPLEMENTATION OF METHODS REFERENCED: <2s>' expandMacrosWith: aSelector with: code
]
