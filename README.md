# Repo overview

This package contains small exercises to get you used to reading and writing Cairo code, all while abstracting away much of the legwork that revolves around development, such as compilation or deployment.
Abstraction is accomplished using a script that automatically compiles, deploys and tests `.cario` files, so what is left is to fix the code so that it fulfils desired criteria.

There are two distinct exercise sets:

- Cairo programs
- Starknet contracts

After the invocation, the Python script will iterate over the exercises, Cairo programs and StarkNet contracts.

This form of the tutorial has been inspired by [rustlings](https://github.com/rust-lang/rustlings) repo (used for learning rust) and likewise to communicate to the script to proceed to the next exercise tag `## I am not done` at the top of the file has to be removed.

# Set-up

Precursors necessary are:

- [protostar](https://docs.swmansion.com/protostar/docs/tutorials/installation)
- [python 3.7](https://www.python.org/downloads/)
- [cairo](https://www.cairo-lang.org/docs/quickstart.html)

# Starting autoloader script

From within the main repo directory, run:

    python3 main.py

In the background, it will invoke the following command (for the first exercise)

    protostar test test/test_ex1.cairo

with the exception that the python script will recompile and retest upon saving of any `.cairo` exercise file.

**All tests should pass without any modification of the test files.**

**Hence you must only modify the `.cairo` files in the `/exercises/` directory.**

# Cairo programs exercises

Cairo is a programming language for writing provable programs, where one party can prove computational integrity to the other party without revealing computation or the input data.

These are single purpose functions that accomplish some logic, that rather than being useful to some application, forces you to think the "cairo" way. Function declarations are not to be modified, as they are invoked from within the tests. If you find a way to solve a challenge without using up all of the available parameter slots, leave some unused rather than remove them.

# Starknet contracts exercises

StarkNet uses the Cairo programming language both for its infrastructure and for writing StarkNet contracts and it exists as it's own layer that does not need necessarily need direct interaction with an L1 such as Ethereum.

## Basic contract

This is a straightforward contract with minimal testing that attempts to showcase much of the structural building blocks used to assemble smart contracts.

## Battleship contract

This is a gaming example where you will develop a game where two players compete by trying to shoot down each other's ships. This is an example of a commit-reveal pattern, which is very common in many blockchain applications.
To simplify necessary tasks to complete core game mechanics are slightly different from the classical battleship game; ships are points, and a player does not get another move upon a successful strike.
The winner is selected after hitting four enemy ships, and the grid is 5x5.

### Features to implement

#### Structs

Need to implement three structs:

- `Square`
- `Player`
- `Game`

`Square` has three fields all felts: square_commit, square_reveal, shot.

`Player` has three fields all felts: address, points, revealed

`Game` has five fields:

- player1 of type `player`
- player2 of type `player`
- next_player of type `felt`
- last_move of type double felt tuple `(felt,felt)`
- winner of type `felt`

#### Game set-up

The function `set_up_game` is the first one to be called by whoever wants to set up a game, and it accepts two players' addresses.

It will read the current game index from `game_counter`, create a struct `Game` with addresses of the players (everything else set to zero) and finally will write it to the `games` mapping.

Finally, this function will increment the `game_counter` by one.

#### Check vallid caller

Two different functions will require access control that ensures only either of the players is allowed to call, this reused logic will be accomplished using the function `check_caller`.

This function takes in caller's address and the game struct and returns true if the caller is one of the players and false otherwise.

#### Check hit

The function `check_hit` checks whether previously invoked bombardment has hit the square containing a ship.

It receives `square_commit` and `square_reveal`.

If re-hashed `square_reveal` matches `square_commit` it will return true, and false otherwise.

#### Load masked ship positions

Player that wants to add masked positions will call `add_squares`. This funcion will verify authenticity of the caller by checking with with `check_caller` that the caller is one of the players in the supplied game index.

It will then call an internal function `load_hashes` that will iterate over an array and submit each hash under the correct mapping index.

Array will be loaded sequentially from the top, so first position will be [0,0], second will be [1,0] and at _x_ index of 4 ([4,0]) it will then jump with next one which will be [0,1]. Same loading pattern will occur on each subsequent row.

#### Bombardment

Function `bombard`, will take the game index, position to hit as well as the reveal for the previous hit by the othe player.

It will check whether the caller is one of the players and whether it is their move (first move can be by anyone).

Then it will check whether this is the very first move and whether it needs to process the `square_reveal` argument, if it is not first move it will assert that is the right player and call `check_hit`. If the player has accumulated four points, they are declared a winner.

If hit has been made, score for the previous player will be incremented.

The next player will be set to the opposite player depending on what current caller is.

The game struct under this particular game index will be updated to reflect changes in:

- player points
- next player
- potential winner
- last move

# Conversion helper

File `conversion.py` in the root directory can be used for conversion between felt and strings and numbers and uint256.

To use that helper iteratively interactively run:

`python3 -i conversion.py`
