Class {
	#name : 'SairenState',
	#superclass : 'WorldState',
	#category : 'Sairen-UI',
	#package : 'Sairen-UI'
}

{ #category : 'world state' }
SairenState class >> aiWorldMenuOn: aBuilder [

	<worldMenu>
	( aBuilder item: #'Sairen tutor' )
		order: 1;
		icon: SairenIcons sairenIcon;
		help: 'Ask questions to the Sairen tutor';
		action: [ SairenSpecApplication open ]
]
