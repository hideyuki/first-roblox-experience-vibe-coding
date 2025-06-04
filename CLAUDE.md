# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Build and Deploy
```bash
# Build the place file
rojo build -o "first-roblox-experience-vibe-coding.rbxlx"

# Start development server (connect to Roblox Studio)
rojo serve

# Install dependencies
wally install

# Update tool versions
aftman install
```

### Testing
```bash
# Test in Roblox Studio - open .rbxlx file and press F5
# Use TestEZ framework (available as dev dependency)
```

## Project Architecture

This is **Kanata Maze** - a large-scale competitive Roblox maze experience supporting 100 concurrent players, built with client-server architecture managed by Rojo.

### Core Structure
- **Client** (`src/client/`): UI management, timer display, horizontal ranking board updates
- **Server** (`src/server/`): Advanced game state management, DataStore operations, collision detection, warp system
- **Shared** (`src/shared/`): Updated constants and utilities for the renovated maze

### Major Renovation Features (v2.0)

**Massive Maze Upgrade**
- Maze size: 186×150 studs (3× larger than original)
- Path width: 12 studs (2× wider for comfortable navigation)
- Wall height: 40 studs with ceiling system (4× taller, prevents jumping over)
- 522 parts total: 261 walls + 261 ceiling blocks with lighting gaps

**Enhanced Player Areas**
- Start area: 80×40 studs enclosed space (spawn at z=-110)
- Goal area: 60×50 studs with ranking board and warp zone
- Warp system: Blue "WARP TO START" zone for instant return (z=115)

**Advanced Lighting System**
- Wall-mounted torches every 10 walls with flickering effects
- Campfires in start/goal areas with smoke and particle effects
- Strategic ceiling gaps for natural lighting
- Dynamic brightness tweening for atmospheric ambiance

### Key Systems

**Enhanced Game Flow Management**
- Robust state machine: WAITING → STARTED → COMPLETED
- Advanced duplicate prevention: 2-second cooldown + state validation
- 1-start-1-goal system: each start allows exactly one goal record
- Seamless re-attempt system via warp zones

**Competition-Grade Maze Logic**
- Start gate (z=-73): Triggers timer, validates WAITING state
- Goal gate (z=73): Records time, updates global rankings, sets COMPLETED state  
- Warp zone (z=115): Instant teleport to start area, resets to WAITING state
- Anti-cheat: Ceiling system prevents maze bypassing

**Scalable Data Architecture**
- Production: KanataMazeRankings DataStore for global leaderboards
- Local testing: Enhanced dummy data with realistic completion times
- Top 100 ranking system with real-time updates
- Optimized ranking display: 1-20 (left panel), 21-40 (right panel)

**Real-time Communication**
- RemoteEvents: StartTimer, StopTimer, UpdateRanking
- 5-second automatic ranking broadcasts to all clients
- 0.1-second client timer updates for precision timing

### Dependencies
- **Signal**: Event management and signals
- **ProfileService**: DataStore management and player profiles  
- **Roact**: UI component framework
- **DataStore2**: Enhanced DataStore functionality (server-only)
- **TestEZ**: Testing framework (dev)

### Important Files
- `maze_setup.luau`: Original maze generation script (legacy)
- `lighting_setup.luau`: Comprehensive lighting system with torches and campfires
- `default.project.json`: Rojo project configuration mapping file structure
- `src/shared/Constants.luau`: Updated game configuration for Kanata Maze v2.0
- `src/client/init.client.luau`: Enhanced UI with horizontal ranking board
- `src/server/init.server.luau`: Advanced state management with warp system support

### Game Flow (Updated)
1. **Spawn**: Players appear in start area (z=-110) 
2. **Start**: Pass through green start gate (z=-73) → Timer begins, state = STARTED
3. **Navigate**: Complete the 186×150 stud maze with 12-stud wide paths
4. **Goal**: Pass through red goal gate (z=73) → Timer stops, ranking updated, state = COMPLETED
5. **Review**: Check horizontal ranking board in goal area (z=110)
6. **Return**: Use blue warp zone (z=115) → Instant teleport to start, state = WAITING
7. **Repeat**: Unlimited re-attempts supported

### Local Development
The server automatically detects Studio environment and switches to local testing mode with dummy data and disabled DataStore operations. Use F5 in Studio for immediate testing of the complete maze experience.

## Toolchain
- **Rojo 7.5.1**: Project management and sync
- **Wally 0.3.2**: Package management
- **Aftman**: Tool version management