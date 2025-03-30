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
				group: 'CI' with: 'Tests';
				group: 'Examples' with: #( 'Deployment' 'Sairen-Examples' );
				group: 'Development' with: #( 'Tests' );
				group: 'default' with: 'Development'
		]
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
		baseline: 'Boardwalk' with: [ spec repository: 'github://ba-st/Boardwalk:v7' ];
		project: 'Boardwalk-SUnit'
		copyFrom: 'Boardwalk'
		with: [ spec loads: 'Dependent-SUnit-Extensions' ].
	spec
		baseline: 'ZincHTTPComponents' with: [ spec repository: 'github://svenvc/zinc' ];
		project: 'Zinc-Core' copyFrom: 'ZincHTTPComponents' with: [ spec loads: 'Core' ].
	spec
		baseline: 'Willow' with: [ spec repository: 'github://ba-st/Willow:v15' ];
		project: 'Willow-Development' copyFrom: 'Willow' with: [ spec loads: 'Development' ].
	spec
		baseline: 'WillowBootstrap' with: [ spec repository: 'github://ba-st/Willow-Bootstrap:v14' ];
		project: 'Willow-Bootstrap-Deployment'
		copyFrom: 'WillowBootstrap'
		with: [ spec loads: 'Deployment' ].
	spec
		baseline: 'WillowSpinKit' with: [ spec repository: 'github://ba-st/Willow-SpinKit:v10' ];
		project: 'Willow-SpinKit-Deployment' copyFrom: 'WillowSpinKit' with: [ spec loads: 'Deployment' ]
]

{ #category : 'baselines' }
BaselineOfSairen >> setUpPackages: spec [

	spec
		package: 'Sairen-Model' with: [ spec requires: #( 'Buoy-Deployment' 'Zinc-Core' ) ];
		group: 'Deployment' with: 'Sairen-Model';
		package: 'Sairen-Examples' with: [
				spec requires:
						#( 'Sairen-Model' 'Willow-Development' 'Willow-Bootstrap-Deployment'
						   'Willow-SpinKit-Deployment' )
			];
		group: 'Examples' with: 'Sairen-Examples';
		package: 'Sairen-Model-Tests' with: [ spec requires: #( 'Sairen-Model' ) ];
		group: 'Tests' with: 'Sairen-Model-Tests';
		package: 'Sairen-Examples-Tests'
		with: [ spec requires: #( 'Boardwalk-SUnit' 'Sairen-Examples' ) ];
		group: 'Tests' with: 'Sairen-Examples-Tests'
]
