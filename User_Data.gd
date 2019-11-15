extends Node

### An uber basic game data controller ###
### Built for keeping a handful of variables between levels ###
### Set this script to AutoLoad in Project Settings ###

# all variables we want to keep between levels can be stored in a dicitonary
# access them from anywhere with User_Data.store.[YourVariable]
# we will back up the entire dictionary in one go, no need to modify the save and load functions

var store = {
	# you can add as many variables as you want here, they will all be saved
	level = 1,
	score = 0,
	lives = 3
	}

func _ready():
	# check if a Saves directory exists.
	var dir = Directory.new()
	if !dir.dir_exists("user://Saves"):
		# if not we'll create it.
		dir.open("user://")
		dir.make_dir("user://Saves")

# we'll setup quicksave and quickload buttons here for demonstration
# they could be called from anywhere with User_Data.save_game_state("filename"):
func _physics_process(delta):
	if Input.is_action_just_pressed("qsave"):
		# Trigger the save function with the filename we want for our save
		save_game_state("QuickSave")
	if Input.is_action_just_pressed("qload"):
		# trigger the load function with the correct filename 
		load_game_state("QuickSave")


# this is our save function, it creates a json file with our data
func save_game_state(var saveName):
	# create a file object
	var saveGame = File.new()
	# create our save location
	saveGame.open("user://Saves/"+saveName+".sve", File.WRITE)
	# write the data to disk
	saveGame.store_line(to_json(store))
	# close the file
	saveGame.close()
	# done

# this function loads the previously saved variables as text
# converts the text, and replaces all variables in our data store
func load_game_state(var saveName):
	# create a file object
	var loadGame = File.new()
	# check that the file exists before trying to open it
	if !loadGame.file_exists("user://Saves/"+saveName+".sve"):
		print ("Abort! Abort! No file to load...")
		return
	
	# time to read the data in our file
	loadGame.open("user://Saves/"+saveName+".sve", File.READ)
	# now simply overwrite store by parsing the loaded data
	store = parse_json(loadGame.get_line())
	loadGame.close()
	#Done!
	
	# DEBUG stuff: we'll just check that everything worked right
	print("Loaded data: ", store)

# this function is for resetting your variables for a new game
func new_game():
	# intitalize default variables
	store = newgame
