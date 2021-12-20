tool
extends Button

export var active: bool

func draw_circle_outline(center, radius, color):
	var nb_points = 10
	var points_arc = PoolVector2Array()
	var angle_from = 0
	var angle_to = 360

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)

func _draw():
	var index = get_index()
	var size = self.rect_size
	var offset = size[0]/2
	if index == 0:
		offset = size[0] - 8
	elif index == 2:
		offset = 0 + 8
	var radius = 6
	# This draws a circle that isnt anti aliased :(((
	if active:
		draw_circle(Vector2(offset, radius+4), radius, Color.white)
	else:
		draw_circle_outline(Vector2(offset, radius+4), radius, Color.white)
