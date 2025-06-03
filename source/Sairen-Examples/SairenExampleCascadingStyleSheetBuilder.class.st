Class {
	#name : 'SairenExampleCascadingStyleSheetBuilder',
	#superclass : 'ReflectiveCascadingStyleSheetBuilder',
	#pools : [
		'Willow'
	],
	#category : 'Sairen-Examples-Libraries',
	#package : 'Sairen-Examples',
	#tag : 'Libraries'
}

{ #category : 'class initialization' }
SairenExampleCascadingStyleSheetBuilder class >> initialize [

	<ignoreForCoverage>
	Classification bind: #sairenApps to: Namespace new.
	Classification >> #sairenApps bind: #poem to: 'poem'.
	Classification >> #sairenApps bind: #apiKey to: 'apiKey'.
	Classification >> #sairenApps bind: #translator to: 'translator'
]

{ #category : 'style declaration' }
SairenExampleCascadingStyleSheetBuilder >> declareApiKeyStyleIn: aBuilder [

	aBuilder
		declareRuleSetFor: [ :selector | selector class: self sairenApps >> #apiKey ] with: [ :style |
				style
					border: { 1 px . #solid . #lightgrey };
					width: 50 vw;
					margin: #auto;
					marginTop: 10 px;
					padding: 20 px;
					borderRadius: 20 px
			];
		declareRuleSetFor: [ :selector | ( selector class: self sairenApps >> #apiKey ) label ]
		with: [ :style | style width: 7 em ];
		declareRuleSetFor: [ :selector | ( selector class: self sairenApps >> #apiKey ) input ]
		with: [ :style |
				style
					width: 30 vw;
					display: #inlineBlock;
					marginLeft: 20 px;
					verticalAlign: #middle
			]
]

{ #category : 'style declaration' }
SairenExampleCascadingStyleSheetBuilder >> declarePoemStyleIn: aBuilder [

	aBuilder
		declareRuleSetFor: [ :selector | selector class: self sairenApps >> #poem ] with: [ :style |
				style
					border: { 1 px . #solid . #lightgrey };
					width: 50 vw;
					margin: #auto;
					marginTop: 10 px;
					padding: 20 px;
					borderRadius: 20 px
			];
		declareRuleSetFor: [ :selector | ( selector class: self sairenApps >> #poem ) label ]
		with: [ :style | style width: 7 em ];
		declareRuleSetFor: [ :selector | ( selector class: self sairenApps >> #poem ) input ]
		with: [ :style |
				style
					width: 30 vw;
					display: #inlineBlock;
					marginLeft: 20 px;
					verticalAlign: #middle
			];
		declareRuleSetFor: [ :selector | ( selector class: self sairenApps >> #poem ) button ]
		with: [ :style |
				style
					marginLeft: 10 px;
					verticalAlign: #middle
			];
		declareRuleSetFor: [ :selector | ( selector class: self sairenApps >> #poem ) > selector div ]
		with: [ :style |
				style
					margin: 10 px;
					fontSize: #large;
					fontFamily: #sansSerif;
					height: 5 em;
					display: #inline
			];
		declareRuleSetFor: [ :selector |
			( selector class: self sairenApps >> #poem ) > selector div > selector image ]
		with: [ :style |
				style
					display: #block;
					maxHeight: 20 vh;
					margin: #auto;
					marginTop: 10 px;
					marginBottom: 10 px
			]
]

{ #category : 'style declaration' }
SairenExampleCascadingStyleSheetBuilder >> declareTranslatorStyleIn: aBuilder [

	aBuilder
		declareRuleSetFor: [ :selector | selector class: self sairenApps >> #translator ]
		with: [ :style |
				style
					border: { 1 px . #solid . #lightgrey };
					width: 50 vw;
					margin: #auto;
					marginTop: 10 px;
					padding: 20 px;
					borderRadius: 20 px
			];
		declareRuleSetFor: [ :selector | ( selector class: self sairenApps >> #translator ) button ]
		with: [ :style |
				style
					marginLeft: 10 px;
					verticalAlign: #middle
			];
		declareRuleSetFor: [ :selector |
			( selector class: self sairenApps >> #translator ) > selector div ]
		with: [ :style |
				style
					margin: 10 px;
					fontSize: #large;
					fontFamily: #sansSerif;
					height: 5 em
			]
]

{ #category : 'accessing' }
SairenExampleCascadingStyleSheetBuilder >> sairenApps [

	^ self classification >> #sairenApps
]
