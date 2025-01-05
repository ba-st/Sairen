Class {
	#name : 'BaselineOfSairen',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfSairen',
	#package : 'BaselineOfSairen'
}

{ #category : 'baselines' }
BaselineOfSairen >> baseline: spec [

	<baseline>
	spec for: #pharo do: [ 
		self
			setUpDependencies: spec;
			setUpPackages: spec.

		spec
			group: 'Development' with: #( 'Tests' );
			group: 'CI' with: 'Tests';
			group: 'default' with: 'Development' ]
]

{ #category : 'accessing' }
BaselineOfSairen >> projectClass [

	^ MetacelloCypressBaselineProject
]

{ #category : 'baselines' }
BaselineOfSairen >> setUpDependencies: spec [

	spec
		baseline: 'Buoy' with: [ spec repository: 'github://ba-st/Buoy:v8' ];
		project: 'Buoy-Deployment' copyFrom: 'Buoy' with: [ spec loads: 'Deployment' ];
		project: 'Buoy-SUnit' copyFrom: 'Buoy' with: [ spec loads: 'Dependent-SUnit-Extensions' ];
		project: 'Buoy-Tools' copyFrom: 'Buoy' with: [ spec loads: 'Tools' ].
	spec
		baseline: 'ZincHTTPComponents' with: [ spec repository: 'github://svenvc/zinc' ];
		project: 'Zinc-Core' copyFrom: 'ZincHTTPComponents' with: [ spec loads: 'Core' ]
]

{ #category : 'baselines' }
BaselineOfSairen >> setUpPackages: spec [

	spec
		package: 'Sairen-Model' with: [ spec requires: #( 'Buoy-Deployment' 'Zinc-Core' ) ];
		group: 'Deployment' with: 'Sairen-Model';
		package: 'Sairen-Model-Tests' with: [ spec requires: #( 'Sairen-Model' ) ];
		group: 'Tests' with: 'Sairen-Model-Tests'
]
