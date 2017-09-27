ModuleType.create([
    { id:1, name:'LUX' },
    { id:2, name:'POTENTIA' },
    { id:3, name:'OMNI' }
])

SensorType.create([
    { id:1, name:'CURRENT' },
    { id:2, name:'LUMINOSITY' },
    { id:3, name:'MOVEMENT' },
    { id:4, name:'SOUND' },
    { id:5, name:'TEMPERATURE' }
])

DeviceState.create([
    { id:0, name:'PRECONFIGURED'},
    { id:1, name:'DISCOVERY'},
    { id:2, name:'AWAITING CONNECTION'},
    { id:3, name:'UNMANAGED'},
    { id:4, name:'OPERATIONAL'}
])

ModuleState.create([
    { id:0, name:'INACTIVE'},
    { id:1, name:'ACTIVE'},
    { id:2, name:'INACTIVE BY OVERRIDE'},
    { id:3, name:'ACTIVE BY OVERRIDE'}
])

######## A REMOVER EN FUTURO ########
Ambience.create([
    { id: 1, name: 'Not Specified'},
    { id: 2, name: 'Roaming Device'}
])