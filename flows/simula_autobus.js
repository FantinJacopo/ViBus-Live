// 1. MODIFICA IL SIMULATORE AUTOBUS (flow esistente)
// Nel nodo "Simula Autobus SVT", sostituisci le righe con flow.get/set con global.get/set

const lines = [{id: "1", name: "Stanga-Ospedale", color: "#FF6B35"}, {id: "2", name: "Anconetta-Ferrovieri", color: "#004E89"}, {id: "3", name: "Maddalene-Cattane", color: "#00A8CC"}, {id: "5", name: "Villaggio-Centro", color: "#7209B7"}, {id: "7", name: "Laghetto-Stadio", color: "#FF8500"}]; 

const vicenzaCenter = { lat: 45.5477, lon: 11.5458 }; 

// CAMBIA: da flow.get("buses") a global.get("buses")
if (!global.get("buses")) { 
    const buses = []; 
    lines.forEach(line => { 
        for (let i = 1; i <= 2; i++) { 
            buses.push({ 
                id: `SVT${line.id}${String(i).padStart(2, '0')}`, 
                line: line.id, 
                lineName: line.name, 
                lat: vicenzaCenter.lat + (Math.random() - 0.5) * 0.02, 
                lon: vicenzaCenter.lon + (Math.random() - 0.5) * 0.02, 
                speed: 25 + Math.random() * 15, 
                bearing: Math.random() * 360, 
                delay: Math.floor(Math.random() * 8) - 2, 
                passengers: Math.floor(Math.random() * 40), 
                status: "in_service", 
                lastUpdate: new Date() 
            }); 
        } 
    }); 
    // CAMBIA: da flow.set("buses", buses) a global.set("buses", buses)
    global.set("buses", buses); 
} 

// CAMBIA: da flow.get("buses") a global.get("buses")
const buses = global.get("buses"); 

const updatedBuses = buses.map(bus => { 
    const moveDistance = 0.0005; 
    const bearing = bus.bearing + (Math.random() - 0.5) * 30; 
    const newLat = bus.lat + moveDistance * Math.cos(bearing * Math.PI / 180); 
    const newLon = bus.lon + moveDistance * Math.sin(bearing * Math.PI / 180); 
    const lat = Math.max(45.52, Math.min(45.57, newLat)); 
    const lon = Math.max(11.52, Math.min(11.57, newLon)); 
    return { 
        ...bus, 
        lat: lat, 
        lon: lon, 
        bearing: bearing, 
        speed: Math.max(5, Math.min(50, bus.speed + (Math.random() - 0.5) * 5)), 
        delay: bus.delay + (Math.random() - 0.5) * 0.5, 
        passengers: Math.max(0, Math.min(50, bus.passengers + Math.floor((Math.random() - 0.5) * 6))), 
        lastUpdate: new Date() 
    }; 
}); 

// CAMBIA: da flow.set("buses", updatedBuses) a global.set("buses", updatedBuses)
global.set("buses", updatedBuses); 

const messages = []; 
updatedBuses.forEach(bus => { 
    messages.push({ 
        payload: JSON.stringify({ 
            bus_id: bus.id, 
            line: bus.line, 
            line_name: bus.lineName, 
            position: { 
                lat: bus.lat, 
                lon: bus.lon 
            }, 
            speed: Math.round(bus.speed * 10) / 10, 
            bearing: Math.round(bus.bearing), 
            delay: Math.round(bus.delay * 10) / 10, 
            passengers: bus.passengers, 
            status: bus.status, 
            timestamp: bus.lastUpdate.toISOString() 
        }), 
        topic: `vibus/autobus/${bus.id}/posizione` 
    }); 
}); 

return [messages];