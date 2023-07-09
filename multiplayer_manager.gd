extends Node

var lag = [0,0,0,0,0,0,0,0,0,0]

var names = [null,null,null,null,null,null,null,null,null,null]

var nuvarande_lag = -1

var antal_lag = 11

var upnp := UPNP.new()

var Ip = 0

func create_server(PORT,username: String):
	# Start as server.
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(client_connected)
#	multiplayer.peer_disconnected.connect(client_disconnected)
	
	var discoverResult = upnp.discover()
	if discoverResult == upnp.UPNP_RESULT_SUCCESS:
		if upnp.get_gateway() and upnp.get_gateway().is_valid_gateway():
			var mapResultUDP := upnp.add_port_mapping(PORT,0,"Stratergy godot game", "UDP" ,3600)
#			var mapResultTCP := upnp.add_port_mapping(PORT,0,"Stratergy godot game", "TCP" ,3600)
			if not mapResultUDP == upnp.UPNP_RESULT_SUCCESS:
				upnp.add_port_mapping(PORT,0,"","UDP",3600)
#			if not mapResultTCP == upnp.UPNP_RESULT_SUCCESS:
#				upnp.add_port_mapping(PORT,0,"","TCP",3600)
		else:
			print("Error")
			breakpoint
			return
	else:
		print("Error")
		breakpoint
		return
	
	
	Ip = upnp.query_external_address()
#	upnp.delete_port_mapping(PORT,"UDP")
#	upnp.delete_port_mapping(PORT,"TCP")
	
	new_player_conected(1)
	print("Server created at port: ",PORT, ", peer id: ",peer.get_unique_id())
	setName(username,nuvarande_lag)
	start_game()
	
@rpc("any_peer")
func setName(nameIn: String,team: int):
	if names[team] == null:
		names[team] = nameIn

@rpc
func syncaNamn(peer,namn):
	if multiplayer.get_unique_id() == peer:
		names = namn

func client_connected(peer_id):
	print(multiplayer.get_unique_id(),"     ",peer_id)
	rpc("syncaNamn",peer_id,names)
	
#func client_disconnected(peer_id):
#	pass

func create_client(PORT, ip, username):
	Ip = ip
	# Start as client.
	if ip == "":
		OS.alert("Need a ip to connect to.")
		return
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client.")
		return
	multiplayer.multiplayer_peer = peer
	
	await multiplayer.connected_to_server
	print("Rpc")
	new_player_conected(peer.get_unique_id())
	rpc("new_player_conected",peer.get_unique_id())
	
	await get_tree().create_timer(0.1).timeout
	setName(username,nuvarande_lag)
	rpc("setName",username,nuvarande_lag)
	
	print("Client created. Conected to sever at port: ",PORT, ", ip: ",ip,". Peer id: ",peer.get_unique_id())
	start_game()
	

@rpc("any_peer")
func new_player_conected(peer_id):
	print("A new player conected peer id: ",peer_id)
	if multiplayer.is_server():
		for i in range(len(lag)-1):
			if lag[i+1] == 0:
				lag[i+1] = peer_id
				break
		synca_lag(lag,peer_id)
		rpc("synca_lag",lag,peer_id)
@rpc
func synca_lag(Lag,peer_id):
	lag = Lag
	for i in range(len(Lag)):
		if Lag[i] == multiplayer.get_unique_id():
			nuvarande_lag = i
			if multiplayer.is_server():
				print("Set the team of peer id: ",peer_id," to: ",nuvarande_lag)
			break

func start_game():
	pass
