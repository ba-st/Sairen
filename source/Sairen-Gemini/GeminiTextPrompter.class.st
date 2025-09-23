Class {
	#name : 'GeminiTextPrompter',
	#superclass : 'GeminiPrompterBehavior',
	#category : 'Sairen-Gemini',
	#package : 'Sairen-Gemini'
}

{ #category : 'configuring' }
GeminiTextPrompter >> changeMaximumOutputTokensTo: aNumber [
	"maxOutputTokens sets the maximum number of tokens to include in a candidate."

	self currentConfiguration at: 'maxOutputTokens' put: aNumber
]

{ #category : 'configuring' }
GeminiTextPrompter >> changeStopSequencesTo: someWords [
	"stopSequences specifies the set of character sequences (up to 5) that will stop output generation. If specified, the API will stop at the first appearance of a stop_sequence. The stop sequence won't be included as part of the response."

	self currentConfiguration at: 'stopSequences' put: someWords
]

{ #category : 'configuring' }
GeminiTextPrompter >> changeTopTokenAccumulatedProbabilityTo: aNumber [
	"topP changes how the model selects tokens for output. Tokens are selected from the most to least probable until the sum of their probabilities equals the topP value. The default topP value is 0.95."

	self currentConfiguration at: 'topP' put: aNumber
]

{ #category : 'configuring' }
GeminiTextPrompter >> changeTopTokenIndividualProbabilityTo: aNumber [
	"topK changes how the model selects tokens for output. A topK of 1 means the selected token is the most probable among all the tokens in the model's vocabulary, while a topK of 3 means that the next token is selected from among the 3 most probable using the temperature. Tokens are further filtered based on topP with the final token selected using temperature sampling."

	self currentConfiguration at: 'topK' put: aNumber
]

{ #category : 'private - accessing' }
GeminiTextPrompter >> flattenedPartsFrom: responseEntity [

	^ responseEntity
		  at: 'candidates'
		  ifPresent: [ :candidates |
				  ( candidates collect: [ :candidate | ( candidate at: 'content' ) at: 'parts' ] ) flattened ]
		  ifAbsent: [
				  AssertionFailed signal: ( 'Gemini responded with error: <1s>' expandMacrosWith:
						    ( ( responseEntity at: 'error' ) at: 'message' ) )
			  ]
]

{ #category : 'private - accessing' }
GeminiTextPrompter >> jsonEntityFor: aText whenListeningTo: aBase64Audio with: aMimeType [

	^ ZnEntity json: ( '{
  "contents": [{
    "parts":[{"inlineData": {"mimeType":"<1s>","data":"<2s>"}},{"text": "<3s>"}]
    }]
   }' expandMacrosWith: aMimeType with: aBase64Audio with: aText )
]

{ #category : 'private - accessing' }
GeminiTextPrompter >> model [

	^ 'gemini-2.0-flash'
]

{ #category : 'accessing' }
GeminiTextPrompter >> prompt: aText whenListeningTo: aBase64Audio with: aMimeType [

	^ self promptUsing: ( self jsonEntityFor: aText whenListeningTo: aBase64Audio with: aMimeType )
]

{ #category : 'accessing' }
GeminiTextPrompter >> promptBasedOn: aDictionary [

	^ self promptUsing: ( self jsonEntityBasedOn: aDictionary )
]

{ #category : 'private - accessing' }
GeminiTextPrompter >> promptUsing: anEntity [

	| responseEntity |

	responseEntity := self postResponseFor: anEntity.
	^ self flattenedPartsFrom: responseEntity
]
