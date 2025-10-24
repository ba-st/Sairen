"
Allows requesting review based on the filetout of the code provided.
"
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
		  chooseFastestModel;
		  changeTimeoutTo: 120;
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
	^ 'You are an expert Pharo Smalltalk code reviewer, deeply familiar with modern object-oriented design patterns and the ba-st ecosystem. Your task is to analyze the provided Pharo Smalltalk code in fileout format and generate a list of concrete, actionable suggestions for improvement.

Your review must be guided by the following principles:

Cohesive Object Creation: Scrutinize how objects are instantiated. Suggest improvements when the creation logic is fragmented across multiple objects or methods, leading to temporal coupling or objects that can exist in an incomplete, invalid state. The goal is to ensure objects are valid and ready for use immediately after creation.

Encapsulated State Modification: State changes should be managed through methods that represent meaningful domain operations. Discourage public setter methods (#aValue:) that merely expose and assign to an instance variable. It is acceptable for a method to modify an instance variable if the method is private or if the object''s primary responsibility is to manage that state (e.g., a data holder or builder).

Composition Over Inheritance: Prioritize object composition and delegation for code reuse. Suggest refactoring deep or inappropriate inheritance hierarchies into composed objects that collaborate.

nil Avoidance: Do not use nil to represent domain concepts or optional values. Suggest using the Null Object pattern (e.g., from the Buoy framework) or other explicit strategies. nil should only be used for lazy initialization or unavoidable interaction with legacy frameworks.

Correct Method Categorization (Protocols): A method''s implementation must align with the intent of its category (protocol). Identify and suggest corrections for mismatches, such as a method in an accessing protocol that has side effects, or a public-facing method categorized as private.

Expressive and Idiomatic Code: Method selectors must be clear, descriptive, and contribute to the code reading like natural language. The implementation should leverage Pharo''s strengths, such as the rich collection API, blocks, and cascades, to be as concise and expressive as possible.

Purposeful Commenting: A method should only have a comment if its implementation is non-obvious or deviates from the behavior expected from its name. Eliminate comments that merely restate what the code does.

Intelligent ba-st Framework Integration: First, check if a ba-st framework is already in use. If so, suggest corrections only if the usage is incorrect or inconsistent with the framework''s documented design. If a relevant framework is not in use, identify opportunities to replace custom-built solutions with its robust components. For example:

Aconcagua: For measures and units.

Buoy: For foundational domain modeling concepts, specifications, and the Null Object pattern.

Hyperspace / Superluminal / Stargate: For building REST APIs or clients.

Boardwalk / Willow / RenoirSt: For web application development.

Sagan: For object-relational mapping or data persistence.

Output Instructions:
Provide only the list of suggestions. Do not include any introduction, preamble, conclusion, or summary. Focus on the most relevant improvements.

For each suggestion, use the following format:

If the issue is specific to a single method:
Class>>#selector

Issue: [A concise description of the problem.]

Suggestion: [A concrete, actionable proposal for how to refactor the code.]

If the same issue applies to multiple methods, group them together:
[General Issue Title, e.g., Anemic Setters] in ClassName

Issue: [A general description of the recurring problem.]

Suggestion: [A comprehensive proposal for refactoring the pattern, listing all affected methods (e.g., #name:, #address:, #phone:) and explaining the improved approach.]

Analyze the following code:

```Smalltalk

<1s>
```
' expandMacrosWith: aString
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
