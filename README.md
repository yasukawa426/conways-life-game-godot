[20 Games Catalogue.](https://github.com/yasukawa426/20-games-challenge-catalog)


## Game 5 of 20 - Conway's Game of Life

Its [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life) implemented in Godot. Made in 2 days.
### Gameplay Video
[![Game Screenshot](http://img.youtube.com/vi/PShm-TCEQ-4/0.jpg)](https://youtu.be/PShm-TCEQ-4)

### Controls
- Set Cell Alive: Hold LMB
- Set Cell Dead: Hold RMB
- Toggle Simulation: Space Bar 
- Reset Grid: R
- Move Camera: WASD
- Boost Camera: Left Shift
- Zoom In/Out: QE and Scroll Wheel 

### Goals
- [X] Create the “Universe” - a square grid with cells that can be “alive” or “dead,” represented by two different colors. The universe is infinite in theory, but you might want to pick a grid size that can fit within a computer’s memory 
- [X] The simulation will occur in steps, or “generations.” Make the appropriate data structures to track both the current and future generation.
- [X] Allow the player to toggle any of the cells between alive and dead.
- [X] Allow the player to start, stop, and reset the simulation. You might also want to make the simulation speed variable.
- [X] During the simulation, each cell will follow a simple set of rules: 
	- [X] Any live cell with fewer than two live neighbors dies.
	- [X] Any live cell with two or three neighbors lives on in the next generation.
	- [X] Any live cell with more than three live neighbors dies.
	- [X] Any dead cell with exactly three live neighbors becomes alive in the next generation.

### Bonus
- [ ] Add multi-threading

### Credits
John Conway for inventing his game of life
