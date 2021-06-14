extends Spatial

export(NodePath) var terrain_path = null

var terrain_tool = null
var terrain = null

# Called when the node enters the scene tree for the first time.
func _ready():
  
  terrain = get_node(terrain_path)
  terrain_tool = terrain.get_voxel_tool()
  #terrain_tool.channel = VoxelBuffer.CHANNEL_TYPE

func _input(event):
  if event.is_action_pressed('ui_accept'):
    terrain_tool.set_voxel(Vector3(0, 0, 0), 1)
    terrain_tool.set_voxel(Vector3(2, 1, 2), 1)
    terrain_tool.set_voxel(Vector3(2, 0, 2), 1)
    terrain_tool.set_voxel(Vector3(2, 1, 1), 1)
    terrain_tool.set_voxel(Vector3(2, 0, 1), 1)

func _notification(what: int):
  match what:
    NOTIFICATION_WM_QUIT_REQUEST:
      # Save game when the user closes the window
      _save_world()

func _save_world():
  terrain.save_modified_blocks()
