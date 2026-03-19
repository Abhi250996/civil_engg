class PromptBuilder {
  /// MAIN ENTRY
  static String build(String type, Map<String, dynamic> data) {
    switch (type) {
      case "building":
        return _building(data);

      case "road":
        return _road(data);

      case "bridge":
        return _bridge(data);

      case "tunnel":
        return _tunnel(data);

      case "chimney":
        return _chimney(data);

      case "thermal_chimney":
        return _thermalChimney(data);

      case "foundation":
        return _foundation(data);

      case "tank":
        return _tank(data);

      case "retaining_wall":
        return _retainingWall(data);

      case "dam":
        return _dam(data);

      case "tower":
      case "telecom":
        return _tower(data);

      case "pipeline":
        return _pipeline(data);

      case "solar":
        return _solar(data);

      case "cooling_tower":
        return _coolingTower(data);

      case "warehouse":
        return _warehouse(data);

      case "silo":
        return _silo(data);

      case "parking":
        return _parking(data);

      case "fence":
        return _fence(data);

      case "plant":
      case "factory":
        return _plant(data);

      default:
        return _custom(data);
    }
  }

  /// ================= BUILDING =================
  static String _building(Map d) {
    return """
2D Architectural Floor Plan (Top View)

Plot Size: ${d["plotLength"]} m x ${d["plotWidth"]} m
Floor Height: ${d["floorHeight"]} m

Include:
- Bedrooms, Kitchen, Living, Dining
- Bathrooms, staircase, parking
- Furniture layout

Technical:
- Wall thickness (230mm external, 115mm internal)
- Doors & windows
- Column grid + beam layout

Output:
- Clean blueprint
- All dimensions labeled
""";
  }

  /// ================= ROAD =================
  static String _road(Map d) {
    final length = d["geometry"]?["length"] ?? "0";
    final width = d["geometry"]?["width"] ?? "0";
    final thickness = d["geometry"]?["thickness"] ?? "0";
    final lanes = d["geometry"]?["lanes"] ?? "2";

    return """
ADVANCED ROAD ENGINEERING DRAWING

================ GEOMETRY =================
- Length: ${length} km
- Carriageway Width: ${width} m
- Number of Lanes: ${lanes}
- Pavement Thickness: ${thickness} mm

================ ROAD STRUCTURE =================
Include:
- Subgrade
- Sub-base layer
- Base course
- Bituminous layer
- Wearing course

================ DESIGN ELEMENTS =================
- Camber / cross slope (%)
- Shoulder width
- Median (if any)
- Side slopes

================ DRAINAGE =================
- Side drains
- Cross drainage
- Water flow direction arrows

================ TRAFFIC DETAILS =================
- Lane markings
- Road centerline
- Edge lines
- Turning radius

================ DRAWING REQUIREMENTS =================
Include:
1. Top view (plan layout)
2. Cross-section view (layered pavement)
3. Longitudinal profile
4. Dimension lines (width, layers, slopes)
5. Labels for all layers

================ STYLE =================
- CAD blueprint style
- Black & white
- Clean engineering drawing

================ OUTPUT =================
- Detailed road plan + section
- All layers clearly visible
""";
  }

  /// ================= BRIDGE =================
  static String _bridge(Map d) {
    final span = d["geometry"]?["spanLength"] ?? "0";
    final width = d["geometry"]?["width"] ?? "0";

    return """
ADVANCED BRIDGE ENGINEERING DRAWING

================ GEOMETRY =================
- Span Length: ${span} m
- Deck Width: ${width} m

================ STRUCTURAL ELEMENTS =================
Include:
- Deck slab
- Girders / beams
- Piers and columns
- Abutments
- Bearings

================ FOUNDATION =================
- Pile / open foundation
- Footings
- Soil interaction

================ LOAD SYSTEM =================
- Dead load
- Live load (vehicles)
- Wind load

================ DETAILS =================
- Expansion joints
- Railings / parapets
- Drainage outlets

================ DRAWING REQUIREMENTS =================
Include:
1. Elevation view
2. Cross-section of deck
3. Pier and foundation detail
4. Reinforcement indication
5. Dimension annotations

================ STYLE =================
- Professional structural blueprint
- Clean vector drawing
- No sketch style

================ OUTPUT =================
- Detailed bridge drawing (plan + elevation + section)
""";
  }

  /// ================= TUNNEL =================
  static String _tunnel(Map d) {
    final length = d["geometry"]?["length"] ?? "0";
    final diameter = d["geometry"]?["diameter"] ?? "0";
    final depth = d["geometry"]?["depth"] ?? "0";

    return """
ADVANCED TUNNEL ENGINEERING DRAWING

================ GEOMETRY =================
- Length: ${length} m
- Diameter: ${diameter} m
- Depth: ${depth} m

================ STRUCTURAL SYSTEM =================
Include:
- Tunnel lining (RC / shotcrete)
- Reinforcement layers
- Segment joints

================ EXCAVATION =================
- Excavation boundary
- Rock / soil layers
- Support system

================ SYSTEMS =================
- Ventilation ducts
- Drainage channels
- Cable trays

================ GEOTECHNICAL =================
- Rock strata layers
- Groundwater level
- Soil pressure arrows

================ DRAWING REQUIREMENTS =================
Include:
1. Longitudinal profile
2. Cross-section view
3. Lining detail
4. Drainage system
5. Dimension labels

================ STYLE =================
- Underground engineering blueprint
- Clean CAD style

================ OUTPUT =================
- Detailed tunnel section + profile drawing
""";
  }

  /// ================= CHIMNEY =================
  static String _chimney(Map d) {
    final height = d["height"] ?? "0";
    final diameter = d["diameter"] ?? "0";

    return """
ADVANCED INDUSTRIAL CHIMNEY DRAWING

================ GEOMETRY =================
- Height: ${height} m
- Diameter: ${diameter} m

================ STRUCTURE =================
Include:
- Tall vertical shaft
- Tapered profile (wider at base)
- Wall thickness variation
- Reinforced concrete / steel structure

================ FOUNDATION =================
- Circular footing
- Base slab
- Soil interaction

================ INTERNAL SYSTEM =================
- Flue gas passage
- Inner lining
- Heat resistant layer

================ LOADS =================
- Wind load
- Seismic load

================ DRAWING REQUIREMENTS =================
Include:
1. Elevation view (full height)
2. Cross-section view
3. Base foundation detail
4. Dimension annotations
5. Material labeling

================ STYLE =================
- Industrial blueprint
- Clean engineering drawing

================ OUTPUT =================
- Detailed chimney design drawing
""";
  }

  static String _coolingTower(Map d) {
    final height = d["height"] ?? "0";
    final diameter = d["diameter"] ?? "0";

    return """
ADVANCED COOLING TOWER ENGINEERING DRAWING

================ GEOMETRY =================
- Height: ${height} m
- Diameter: ${diameter} m

================ STRUCTURE =================
Include:
- Hyperbolic tower shape
- Shell thickness variation
- Reinforced concrete structure

================ AIRFLOW SYSTEM =================
- Air inlet at base
- Upward airflow arrows
- Natural draft system

================ WATER SYSTEM =================
- Hot water inlet
- Cooling distribution
- Cold water basin

================ THERMAL SYSTEM =================
- Heat exchange zone
- Evaporation effect

================ FOUNDATION =================
- Circular raft foundation
- Base support system

================ DRAWING REQUIREMENTS =================
Include:
1. Elevation view
2. Cross-section view
3. Airflow + water flow arrows
4. Dimension annotations

================ STYLE =================
- Industrial blueprint
- Clean CAD drawing

================ OUTPUT =================
- Detailed cooling tower drawing
""";
  }

  /// ================= THERMAL CHIMNEY =================
  static String _thermalChimney(Map d) {
    final height = d["geometry"]?["height"] ?? "0";
    final diameter = d["geometry"]?["diameter"] ?? "0";
    final inletArea = d["geometry"]?["inletArea"] ?? "0";
    final outletArea = d["geometry"]?["outletArea"] ?? "0";

    final radiation = d["solar"]?["radiation"] ?? "0";
    final efficiency = d["solar"]?["efficiency"] ?? "0";
    final glazing = d["solar"]?["glazing"] ?? "N/A";
    final orientation = d["solar"]?["orientation"] ?? "South";

    final inletTemp = d["airflow"]?["inletTemp"] ?? "0";
    final outletTemp = d["airflow"]?["outletTemp"] ?? "0";
    final velocity = d["airflow"]?["velocity"] ?? "0";
    final ach = d["airflow"]?["ach"] ?? "0";

    final material = d["material"]?["type"] ?? "Concrete";
    final conductivity = d["material"]?["conductivity"] ?? "0";
    final insulation = d["material"]?["insulation"] ?? "0";

    final windLoad = d["structure"]?["windLoad"] ?? "0";
    final seismic = d["structure"]?["seismicZone"] ?? "0";

    final foundationType = d["foundation"]?["type"] ?? "Raft";
    final foundationDepth = d["foundation"]?["depth"] ?? "0";
    final soil = d["foundation"]?["soil"] ?? "0";

    return """
ADVANCED THERMAL CHIMNEY ENGINEERING DRAWING

================ GEOMETRY =================
- Height: ${height} m
- Shaft Diameter: ${diameter} m
- Air Inlet Area: ${inletArea} m²
- Air Outlet Area: ${outletArea} m²

================ SOLAR HEATING SYSTEM =================
- Solar Radiation: ${radiation} W/m²
- Absorber Efficiency: ${efficiency} %
- Glazing Type: ${glazing}
- Orientation: ${orientation}

Include:
- Solar collector zone around chimney base
- Sun rays entering collector
- Heat gain area clearly marked

================ AIRFLOW SYSTEM =================
- Inlet Temperature: ${inletTemp} °C
- Outlet Temperature: ${outletTemp} °C
- Air Velocity: ${velocity} m/s
- Air Changes per Hour: ${ach}

Include:
- Strong airflow arrows from inlet to top
- Stack effect visualization
- Velocity direction indicators
- Pressure difference representation

================ STRUCTURAL DESIGN =================
- Material: ${material}
- Thermal Conductivity: ${conductivity} W/mK
- Insulation Thickness: ${insulation} mm
- Wind Load: ${windLoad} kN/m²
- Seismic Zone: ${seismic}

Include:
- Reinforced concrete shaft
- Variable wall thickness (thicker at base)
- Structural stability indication

================ FOUNDATION =================
- Type: ${foundationType}
- Depth: ${foundationDepth} m
- Soil Bearing Capacity: ${soil} kN/m²

Include:
- Circular footing / raft foundation
- Base slab with reinforcement
- Soil interaction zone

================ DRAWING REQUIREMENTS =================
Include ALL of the following:

1. Elevation View (full chimney height)
2. Cross Section View (cut section)
3. Detailed base + collector zone
4. Air inlet openings
5. Internal airflow passage
6. Dimension lines (height, diameter, base width)
7. Labels for each component
8. Material annotations

================ STYLE =================
- Black & white CAD blueprint
- Clean vector technical drawing
- Proper scale proportions
- No cartoon or artistic sketch

================ OUTPUT =================
- Professional civil engineering drawing
- Highly detailed (NOT simple diagram)
- Section + elevation combined
""";
  }

  /// ================= FOUNDATION =================
  static String _foundation(Map d) {
    final length = d["foundation"]?["length"] ?? "0";
    final width = d["foundation"]?["width"] ?? "0";
    final depth = d["foundation"]?["depth"] ?? "0";

    return """
ADVANCED FOUNDATION ENGINEERING DRAWING

================ GEOMETRY =================
- Length: ${length} m
- Width: ${width} m
- Depth: ${depth} m

================ FOUNDATION SYSTEM =================
Include:
- Footing (isolated / raft / combined)
- Base slab
- Column connection

================ STRUCTURAL =================
- Reinforcement bars (top & bottom)
- Rebar spacing
- Concrete cover

================ SOIL =================
- Soil strata layers
- Bearing capacity
- Pressure distribution arrows

================ DRAWING REQUIREMENTS =================
Include:
1. Plan view
2. Cross-section view
3. Reinforcement detail
4. Dimension labels

================ STYLE =================
- Structural blueprint
- Clean CAD drawing

================ OUTPUT =================
- Detailed foundation design
""";
  }

  /// ================= TANK =================
  static String _tank(Map d) {
    final dia = d["tank"]?["diameter"] ?? "0";
    final height = d["tank"]?["height"] ?? "0";

    return """
ADVANCED WATER TANK ENGINEERING DRAWING

================ GEOMETRY =================
- Diameter: ${dia} m
- Height: ${height} m

================ STRUCTURE =================
Include:
- Circular tank wall
- Base slab
- Roof slab (if overhead)

================ REINFORCEMENT =================
- Wall reinforcement
- Slab reinforcement
- Ring beams

================ PIPE SYSTEM =================
- Inlet pipe
- Outlet pipe
- Overflow pipe
- Drain pipe

================ HYDRAULIC =================
- Water level markings
- Pressure distribution

================ DRAWING REQUIREMENTS =================
Include:
1. Plan view
2. Section view
3. Pipe layout
4. Dimension annotations

================ STYLE =================
- Clean engineering blueprint

================ OUTPUT =================
- Detailed tank drawing (plan + section)
""";
  }

  /// ================= RETAINING WALL =================
  static String _retainingWall(Map d) {
    final height = d["geometry"]?["height"] ?? "0";

    return """
ADVANCED RETAINING WALL DESIGN

================ GEOMETRY =================
- Wall Height: ${height} m

================ STRUCTURE =================
Include:
- Stem
- Heel
- Toe
- Base slab

================ SOIL & PRESSURE =================
- Backfill soil
- Active earth pressure arrows
- Passive resistance

================ DRAINAGE =================
- Weep holes
- Drainage layer

================ REINFORCEMENT =================
- Steel bars in stem & base
- Shear key (if needed)

================ DRAWING REQUIREMENTS =================
Include:
1. Cross-section view
2. Soil interaction
3. Reinforcement layout
4. Dimension labels

================ STYLE =================
- Structural blueprint

================ OUTPUT =================
- Detailed retaining wall section
""";
  }

  /// ================= DAM =================
  static String _dam(Map d) {
    final height = d["geometry"]?["height"] ?? "0";

    return """
ADVANCED DAM ENGINEERING DRAWING

================ GEOMETRY =================
- Height: ${height} m

================ STRUCTURE =================
Include:
- Dam body (gravity / arch)
- Base width
- Crest

================ HYDRAULIC =================
- Reservoir water level
- Water pressure distribution
- Flow arrows

================ SPILLWAY =================
- Spillway gates
- Overflow system

================ FOUNDATION =================
- Rock foundation
- Uplift pressure

================ DRAWING REQUIREMENTS =================
Include:
1. Elevation view
2. Cross-section
3. Water flow system
4. Dimension labels

================ STYLE =================
- Hydraulic engineering blueprint

================ OUTPUT =================
- Detailed dam drawing
""";
  }

  /// ================= TOWER =================
  static String _tower(Map d) {
    final height = d["tower"]?["height"] ?? "0";

    return """
ADVANCED TOWER STRUCTURAL DRAWING

================ GEOMETRY =================
- Height: ${height} m

================ STRUCTURE =================
Include:
- Lattice / monopole structure
- Leg members
- Bracing system (X / K)

================ LOADS =================
- Wind load arrows
- Load transfer to foundation

================ FOUNDATION =================
- Pile / footing
- Base plate

================ DETAILS =================
- Bolt connections
- Member joints

================ DRAWING REQUIREMENTS =================
Include:
1. Elevation view
2. Structural framing
3. Foundation detail
4. Dimension labels

================ STYLE =================
- Steel structure blueprint

================ OUTPUT =================
- Detailed tower drawing
""";
  }

  /// ================= PIPELINE =================
  static String _pipeline(Map d) {
    final length = d["pipeline"]?["length"] ?? "0";

    return """
ADVANCED PIPELINE ENGINEERING DRAWING

================ GEOMETRY =================
- Length: ${length} km

================ PIPE SYSTEM =================
Include:
- Main pipeline
- Diameter variation
- Pipe material

================ COMPONENTS =================
- Valves
- Joints
- Supports

================ FLOW SYSTEM =================
- Flow direction arrows
- Pressure zones

================ INSTALLATION =================
- Underground trench
- Bedding layer
- Cover depth

================ DRAWING REQUIREMENTS =================
Include:
1. Plan layout
2. Longitudinal profile
3. Cross-section
4. Dimension labels

================ STYLE =================
- Utility engineering blueprint

================ OUTPUT =================
- Detailed pipeline drawing
""";
  }

  /// ================= SOLAR =================
  static String _solar(Map d) {
    final length = d["site"]?["length"] ?? "0";
    final width = d["site"]?["width"] ?? "0";

    return """
ADVANCED SOLAR FARM LAYOUT

================ SITE =================
- Area: ${length} m x ${width} m

================ PANEL SYSTEM =================
Include:
- Solar panel arrays
- Tilt angle
- Row spacing

================ ELECTRICAL =================
- Inverters
- Transformers
- Cable routing

================ STRUCTURE =================
- Mounting system
- Foundations (pile)

================ ENERGY FLOW =================
- Power flow arrows
- Grid connection

================ DRAWING REQUIREMENTS =================
Include:
1. Site layout plan
2. Panel arrangement
3. Electrical layout
4. Dimension labels

================ STYLE =================
- Clean engineering blueprint

================ OUTPUT =================
- Detailed solar farm layout
""";
  }

  static String _warehouse(Map d) {
    final length = d["dimensions"]?["length"] ?? "0";
    final width = d["dimensions"]?["width"] ?? "0";
    final height = d["dimensions"]?["height"] ?? "0";

    return """
ADVANCED WAREHOUSE ENGINEERING LAYOUT

================ GEOMETRY =================
- Length: ${length} m
- Width: ${width} m
- Height: ${height} m

================ STRUCTURE =================
Include:
- Steel frame / portal frame
- Columns & beams
- Roof truss system

================ STORAGE =================
- Rack systems
- Aisle spacing
- Storage zones

================ LOADING SYSTEM =================
- Loading docks
- Truck bays
- Entry/exit paths

================ FLOOR =================
- Floor load capacity
- Industrial slab

================ DRAWING REQUIREMENTS =================
Include:
1. Floor plan layout
2. Structural frame layout
3. Section view
4. Dimension annotations

================ STYLE =================
- Industrial CAD blueprint

================ OUTPUT =================
- Detailed warehouse layout
""";
  }

  static String _silo(Map d) {
    final height = d["geometry"]?["height"] ?? "0";
    final diameter = d["geometry"]?["diameter"] ?? "0";

    return """
ADVANCED SILO ENGINEERING DRAWING

================ GEOMETRY =================
- Height: ${height} m
- Diameter: ${diameter} m

================ STRUCTURE =================
Include:
- Cylindrical body
- Hopper bottom
- Roof structure

================ STORAGE =================
- Material storage zone
- Load distribution

================ FLOW SYSTEM =================
- Discharge outlet
- Material flow arrows

================ STRUCTURAL =================
- Wall thickness variation
- Reinforcement

================ FOUNDATION =================
- Circular footing
- Load transfer

================ DRAWING REQUIREMENTS =================
Include:
1. Elevation view
2. Cross-section
3. Hopper detail
4. Dimension labels

================ STYLE =================
- Structural blueprint

================ OUTPUT =================
- Detailed silo drawing
""";
  }

  static String _parking(Map d) {
    final length = d["site"]?["length"] ?? "0";
    final width = d["site"]?["width"] ?? "0";

    return """
ADVANCED PARKING LAYOUT DESIGN

================ SITE =================
- Area: ${length} m x ${width} m

================ PARKING SYSTEM =================
Include:
- Parking slots (standard sizes)
- Drive aisles
- Turning radius

================ TRAFFIC FLOW =================
- Entry/exit
- Direction arrows
- Circulation paths

================ SAFETY =================
- Pedestrian paths
- Markings

================ DRAWING REQUIREMENTS =================
Include:
1. Top view layout
2. Slot dimensions
3. Lane widths
4. Turning radius

================ STYLE =================
- Urban planning blueprint

================ OUTPUT =================
- Detailed parking layout
""";
  }

  static String _fence(Map d) {
    final length = d["length"] ?? "0";

    return """
ADVANCED FENCE ENGINEERING DRAWING

================ GEOMETRY =================
- Length: ${length} m

================ STRUCTURE =================
Include:
- Fence posts
- Panels / mesh
- Top rail

================ SPACING =================
- Post spacing
- Height variation

================ FOUNDATION =================
- Post footing
- Embed depth

================ DRAWING REQUIREMENTS =================
Include:
1. Elevation view
2. Post detail
3. Spacing dimensions

================ STYLE =================
- Boundary structure blueprint

================ OUTPUT =================
- Detailed fence design
""";
  }

  static String _plant(Map d) {
    final length = d["site"]?["length"] ?? "0";
    final width = d["site"]?["width"] ?? "0";

    return """
ADVANCED INDUSTRIAL / POWER PLANT LAYOUT

================ SITE =================
- Area: ${length} m x ${width} m

================ PROCESS ZONES =================
Include:
- Production area
- Machinery layout
- Storage zones

================ UTILITIES =================
- Boiler / turbine
- Cooling system
- Electrical rooms

================ MATERIAL FLOW =================
- Flow arrows
- Conveyor paths

================ SAFETY =================
- Emergency exits
- Fire zones

================ INFRASTRUCTURE =================
- Internal roads
- Drainage
- Pipe routing

================ DRAWING REQUIREMENTS =================
Include:
1. Master layout plan
2. Equipment placement
3. Utility systems
4. Flow diagram

================ STYLE =================
- Industrial engineering blueprint

================ OUTPUT =================
- Detailed plant layout
""";
  }

  static String _custom(Map d) {
    return """
CUSTOM CIVIL ENGINEERING DRAWING

================ INPUT DATA =================
$d

================ REQUIREMENTS =================
Generate:
- Full engineering drawing
- Include geometry, structure, system details
- Add dimensions and annotations

================ STYLE =================
- Professional CAD blueprint
- Clean vector drawing

================ OUTPUT =================
- Highly detailed engineering design
""";
  }
}
