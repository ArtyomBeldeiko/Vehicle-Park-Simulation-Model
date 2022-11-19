protocol ServiceVehicle {
    func refuel()
    func repair()
}

class Vehicle: ServiceVehicle {
    
    enum FuelType: String {
        case gasoline = "gasoline"
        case diesel = "diesel"
    }
    
    enum FuelSpecification: String {
        case octane92 = "92"
        case octane95 = "95"
        case octane98 = "98"
        case standard = "standard"
    }
   
    var year: Int
    var brand: String
    var model: String
    var vehicleRun: Int
    var fuelType: FuelType
    var fuelSpecification: FuelSpecification
    var fuelConsumption: Double
    var isRefueled: Bool
    var isRepaired: Bool
    
    init(year: Int, brand: String, model: String, vehicleRun: Int, fuelType: FuelType, fuelSpecification: FuelSpecification, fuelConsumption: Double, isRefueled: Bool, isRepaired: Bool) {
        self.year = year
        self.brand = brand
        self.model = model
        self.vehicleRun = vehicleRun
        self.fuelType = fuelType
        self.fuelSpecification = fuelSpecification
        self.fuelConsumption = fuelConsumption
        self.isRefueled = isRefueled
        self.isRepaired = isRepaired
    }
    
    func refuel() {
        isRefueled = true
    }
    
    func repair() {
        isRepaired = true
    }
}

class Car: Vehicle {
    var passengerCapacity: Int
    var seatsAvailable: Int
    var passengersTransported: Int
    var isPassengerCompartmentCleaned: Bool
    
    init(year: Int, brand: String, model: String, vehicleRun: Int, fuelType: FuelType, fuelSpecification: FuelSpecification, fuelConsumption: Double, passengerCapacity: Int, seatsAvailable: Int, passengersTransported: Int,  isPassengerCompartmentCleaned: Bool, isRefueled: Bool, isRepaired: Bool) {
        self.passengerCapacity = passengerCapacity
        self.seatsAvailable = seatsAvailable
        self.passengersTransported = passengersTransported
        self.isPassengerCompartmentCleaned = isPassengerCompartmentCleaned
        super.init(year: year,
                   brand: brand,
                   model: model,
                   vehicleRun: vehicleRun,
                   fuelType: fuelType,
                   fuelSpecification: fuelSpecification,
                   fuelConsumption: fuelConsumption,
                   isRefueled: isRefueled,
                   isRepaired: isRepaired)
    }
    
    func cleanPassengerCompartment() {
        isPassengerCompartmentCleaned = true
    }
    
    func load(order: Order, for car: Car) {
        if let passenger = order.passenger {
            car.passengersTransported += passenger
            car.seatsAvailable = car.passengerCapacity - passenger
        }
        
        car.isRefueled.toggle()
        car.isPassengerCompartmentCleaned.toggle()
        car.isRepaired.toggle()
    }
    
    func unload(order: Order, for car: Car) {
        if let passenger = order.passenger {
            car.seatsAvailable += passenger
        }
    }
}

class Bus: Car {
    var isLavatoryServiced: Bool
    
    init(year: Int, brand: String, model: String, vehicleRun: Int, fuelType: FuelType, fuelSpecification: FuelSpecification, fuelConsumption: Double, passengerCapacity: Int, seatsAvailable: Int, passengersTransported: Int, isPassengerCompartmentCleaned: Bool, isRefueled: Bool, isRepaired: Bool, isLavatoryServiced: Bool) {
        self.isLavatoryServiced = isLavatoryServiced
        super.init(year: year,
                   brand: brand,
                   model: model,
                   vehicleRun: vehicleRun,
                   fuelType: fuelType,
                   fuelSpecification: fuelSpecification,
                   fuelConsumption: fuelConsumption,
                   passengerCapacity: passengerCapacity,
                   seatsAvailable: seatsAvailable,
                   passengersTransported: passengersTransported,
                   isPassengerCompartmentCleaned: isPassengerCompartmentCleaned,
                   isRefueled: isRefueled,
                   isRepaired: isRepaired)
    }
    
    func serviceLavatory() {
        isLavatoryServiced = true
    }
    
    func load(order: Order, for bus: Bus) {
        if let passenger = order.passenger {
            if bus.seatsAvailable != 60 {
                bus.seatsAvailable = bus.passengerCapacity - (bus.passengersTransported + passenger)
            } else {
                bus.seatsAvailable = bus.passengerCapacity - passenger
            }
            bus.passengersTransported += passenger
        }
        
        bus.isRefueled.toggle()
        bus.isPassengerCompartmentCleaned.toggle()
        bus.isRepaired.toggle()
        bus.isLavatoryServiced.toggle()
    }
    
    func unload(order: Order, for bus: Bus) {
        if let passenger = order.passenger {
            bus.seatsAvailable += passenger
        }
    }
}

class Truck: Vehicle {
    var cargoCapacity: Int
    var cargoSpace: Int
    var isCargoCompartmentSealed: Bool
    var cargoCapacityAvailable: Int
    var cargoSpaceAvailable: Int
    var ordersPerformed: Int
    var ordersLoaded = [Order]()
    
    init(year: Int, brand: String, model: String, vehicleRun: Int, fuelType: FuelType, fuelSpecification: FuelSpecification, fuelConsumption: Double, cargoCapacity: Int, cargoSpace: Int, isRefueled: Bool, isRepaired: Bool, isCargoCompartmentSealed: Bool, cargoCapacityAvailable: Int, cargoSpaceAvailable: Int, ordersPerformed: Int) {
        self.cargoCapacity = cargoCapacity
        self.cargoSpace = cargoSpace
        self.isCargoCompartmentSealed = isCargoCompartmentSealed
        self.cargoCapacityAvailable = cargoCapacityAvailable
        self.cargoSpaceAvailable = cargoSpaceAvailable
        self.ordersPerformed = ordersPerformed
        super.init(year: year,
                   brand: brand,
                   model: model,
                   vehicleRun: vehicleRun,
                   fuelType: fuelType,
                   fuelSpecification: fuelSpecification,
                   fuelConsumption: fuelConsumption,
                   isRefueled: isRefueled,
                   isRepaired: isRepaired)
    }
    
    func sealCargoCompartment() {
        isCargoCompartmentSealed = true
    }
}

class CurtainSidedTruck: Truck {
    var truckType = "curtain-sided"
    
    func load(order: HouseholdGoodsOrder, for truck: CurtainSidedTruck) {
        truck.ordersLoaded.append(order)
        
        if let cargoWeight = order.cargoWeight, let cargoVolume = order.cargoVolume {
            truck.cargoCapacityAvailable -= cargoWeight
            truck.cargoSpaceAvailable -= cargoVolume
        }
    }
    
    func unload(order: HouseholdGoodsOrder, from truck: CurtainSidedTruck) {
        truck.ordersPerformed += 1
        truck.ordersLoaded.removeFirst()
        if let cargoWeight = order.cargoWeight, let cargoVolume = order.cargoVolume {
            truck.cargoCapacityAvailable += cargoWeight
            truck.cargoSpaceAvailable += cargoVolume
        }
    }
}

class RefrigeratorTruck: Truck {
    var truckType = "refrigerator"
    
    func load(order: PerishableGoodsOrder, for truck: RefrigeratorTruck) {
        truck.ordersLoaded.append(order)
        
        if let cargoWeight = order.cargoWeight, let cargoVolume = order.cargoVolume {
            truck.cargoCapacityAvailable -= cargoWeight
            truck.cargoSpaceAvailable -= cargoVolume
        }
    }
    
    func unload(order: PerishableGoodsOrder, from truck: RefrigeratorTruck) {
        truck.ordersPerformed += 1
        truck.ordersLoaded.removeFirst()
        if let cargoWeight = order.cargoWeight, let cargoVolume = order.cargoVolume {
            truck.cargoCapacityAvailable += cargoWeight
            truck.cargoSpaceAvailable += cargoVolume
        }
    }
}

class TankTruck: Truck {
    var truckType = "tank"
    
    func load(order: LiquidGoodsOrder, for truck: TankTruck) {
        truck.ordersLoaded.append(order)
        
        if let cargoWeight = order.cargoWeight, let cargoVolume = order.cargoVolume {
            truck.cargoCapacityAvailable -= cargoWeight
            truck.cargoSpaceAvailable -= cargoVolume
        }
    }
    
    func unload(order: LiquidGoodsOrder, from truck: TankTruck) {
        truck.ordersPerformed += 1
        truck.ordersLoaded.removeFirst()
        if let cargoWeight = order.cargoWeight, let cargoVolume = order.cargoVolume {
            truck.cargoCapacityAvailable += cargoWeight
            truck.cargoSpaceAvailable += cargoVolume
        }
    }
}

class Order {
    var departurePoint: String
    var destinationPoint: String
    var cargoWeight: Int?
    var cargoVolume: Int?
    var passenger: Int?
    
    init(departurePoint: String, destinationPoint: String, cargoWeight: Int, cargoVolume: Int) {
        self.departurePoint = departurePoint
        self.destinationPoint = destinationPoint
        self.cargoWeight = cargoWeight
        self.cargoVolume = cargoVolume
    }
    
    init(departurePoint: String, destinationPoint: String, passenger: Int) {
        self.departurePoint = departurePoint
        self.destinationPoint = destinationPoint
        self.passenger = passenger
    }
}

class HouseholdGoodsOrder: Order {
    var goodsType = "household goods"
}

class PerishableGoodsOrder: Order {
    var goodsType = "perishable goods"
}

class LiquidGoodsOrder: Order {
    var goodsType = "liquid goods"
}

class PassengerTransportationOrder: Order {
    var passengerType = "tourists"
}

// MARK: Vehicles' Initialization

var firstCar = Car(year: 2019, brand: "Toyota", model: "Camry", vehicleRun: 25000, fuelType: .gasoline, fuelSpecification: .octane95, fuelConsumption: 9.5, passengerCapacity: 3, seatsAvailable: 3, passengersTransported: 0, isPassengerCompartmentCleaned: true, isRefueled: false, isRepaired: true)
var secondCar = Car(year: 2015, brand: "Skoda", model: "Rapid", vehicleRun: 50000, fuelType: .gasoline, fuelSpecification: .octane95, fuelConsumption: 8.2, passengerCapacity: 3, seatsAvailable: 3, passengersTransported: 0, isPassengerCompartmentCleaned: false, isRefueled: false, isRepaired: false)
var bus = Bus(year: 2017, brand: "Setra", model: "TopClass", vehicleRun: 120000, fuelType: .diesel, fuelSpecification: .standard, fuelConsumption: 18.8, passengerCapacity: 60, seatsAvailable: 60, passengersTransported: 0, isPassengerCompartmentCleaned: true, isRefueled: true, isRepaired: true, isLavatoryServiced: true)
var curtainSidedTruck = CurtainSidedTruck(year: 2011, brand: "MAN", model: "450", vehicleRun: 250000, fuelType: .diesel, fuelSpecification: .standard, fuelConsumption: 24.0, cargoCapacity: 15000, cargoSpace: 100, isRefueled: true, isRepaired: true, isCargoCompartmentSealed: false, cargoCapacityAvailable: 15000, cargoSpaceAvailable: 100, ordersPerformed: 0)
var tankTruck = TankTruck(year: 2004, brand: "Scania", model: "S", vehicleRun: 450000, fuelType: .diesel, fuelSpecification: .standard, fuelConsumption: 28.3, cargoCapacity: 20000, cargoSpace: 150, isRefueled: true, isRepaired: false, isCargoCompartmentSealed: false, cargoCapacityAvailable: 20000, cargoSpaceAvailable: 150, ordersPerformed: 0)
var frigeTruck = RefrigeratorTruck(year: 2019, brand: "Volvo", model: "P", vehicleRun: 75000, fuelType: .diesel, fuelSpecification: .standard, fuelConsumption: 24.3, cargoCapacity: 18000, cargoSpace: 120, isRefueled: false, isRepaired: false, isCargoCompartmentSealed: false, cargoCapacityAvailable: 18000, cargoSpaceAvailable: 120, ordersPerformed: 0)

// MARK: Orders' Initialization

let passengerTransportationOrder1 = PassengerTransportationOrder(departurePoint: "Minsk", destinationPoint: "Warsaw", passenger: 45)
let passengerTransportationOrder2 = PassengerTransportationOrder(departurePoint: "Minsk", destinationPoint: "Vilnus", passenger: 3)
let passengerTransportationOrder3 = PassengerTransportationOrder(departurePoint: "Brest", destinationPoint: "Warsaw", passenger: 5)
let householdGoodsOrder1 = HouseholdGoodsOrder(departurePoint: "Minsk", destinationPoint: "Berlin", cargoWeight: 8000, cargoVolume: 50)
let householdGoodsOrder2 = HouseholdGoodsOrder(departurePoint: "Berlin", destinationPoint: "Istambul", cargoWeight: 3000, cargoVolume: 30)
let liquidGoodsOrder1 = LiquidGoodsOrder(departurePoint: "Baku", destinationPoint: "Minsk", cargoWeight: 9000, cargoVolume: 65)

// MARK: Simulation

firstCar.refuel()
print("The first car has enough fuel. - \(firstCar.isRefueled)")
firstCar.load(order: passengerTransportationOrder2, for: firstCar)
print("There are \(firstCar.passengersTransported) passengers in the first car. The first car has \(firstCar.seatsAvailable) seats available.")
firstCar.unload(order: passengerTransportationOrder2, for: firstCar)
print("The first car transported \(firstCar.passengersTransported) passengers.")
print("The first is fueled enough for the next trip. - \(firstCar.isRefueled)")
curtainSidedTruck.load(order: householdGoodsOrder1, for: curtainSidedTruck)
curtainSidedTruck.sealCargoCompartment()
print("The curtain-sided truck is transporting \(householdGoodsOrder1.cargoWeight!) kg of goods. The curtain-sided truck has \(curtainSidedTruck.cargoCapacityAvailable) kg available.")
curtainSidedTruck.load(order: householdGoodsOrder2, for: curtainSidedTruck)
print("The curtain-sided truck can carry \(curtainSidedTruck.cargoCapacityAvailable) kg more and has \(curtainSidedTruck.cargoSpaceAvailable) cubic meters of space available.")
curtainSidedTruck.unload(order: householdGoodsOrder1, from: curtainSidedTruck)
print("\(householdGoodsOrder1.cargoWeight!) kg were unloaded from the curtain-sided truck. \(curtainSidedTruck.ordersLoaded[0].cargoWeight!) kg are still in the truck. The truck has performed \(curtainSidedTruck.ordersPerformed) order so far.")
bus.load(order: passengerTransportationOrder1, for: bus)
print("The bus provides transportation for \(passengerTransportationOrder1.passenger!) passengers and has \(bus.seatsAvailable) seats available.")
bus.load(order: passengerTransportationOrder3, for: bus)
print("The bus has only \(bus.seatsAvailable) seats left.")
bus.unload(order: passengerTransportationOrder1, for: bus)
bus.unload(order: passengerTransportationOrder3, for: bus)
print("The bus has succesfully transported \(bus.passengersTransported) passengers.")
bus.serviceLavatory()
print("The lavatory in the bus is serviced. - \(bus.isLavatoryServiced)")
print("The tank truck is repaired. - \(tankTruck.isRepaired)")
tankTruck.repair()
print("The tank truck is repaired. - \(tankTruck.isRepaired)")
tankTruck.load(order: liquidGoodsOrder1, for: tankTruck)
print("The tank truck has \(tankTruck.cargoSpaceAvailable) cubic meters available.")
tankTruck.sealCargoCompartment()
print("The tank truck cargoCompartment is sealed. - \(tankTruck.isCargoCompartmentSealed)")
tankTruck.unload(order: liquidGoodsOrder1, from: tankTruck)
print("The tank truck has succesfully unloaded \(liquidGoodsOrder1.goodsType) of volume equal to \(liquidGoodsOrder1.cargoVolume!) cubic meters. The truck has \(tankTruck.cargoSpaceAvailable) cubic meters available.")

// MARK: Console Output

/*
The first car has enough fuel. - true
There are 3 passengers in the first car. The first car has 0 seats available.
The first car transported 3 passengers.
The first is fueled enough for the next trip. - false
The curtain-sided truck is transporting 8000 kg of goods. The curtain-sided truck has 7000 kg available.
The curtain-sided truck can carry 4000 kg more and has 20 cubic meters of space available.
8000 kg were unloaded from the curtain-sided truck. 3000 kg are still in the truck. The truck has performed 1 order so far.
The bus provides transportation for 45 passengers and has 15 seats available.
The bus has only 10 seats left.
The bus has succesfully transported 50 passengers.
The lavatory in the bus is serviced. - true
The tank truck is repaired. - false
The tank truck is repaired. - true
The tank truck has 85 cubic meters available.
The tank truck cargoCompartment is sealed. - true
The tank truck has succesfully unloaded liquid goods of volume equal to 65 cubic meters. The truck has 150 cubic meters available.
*/


