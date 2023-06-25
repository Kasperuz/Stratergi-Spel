extends Node

var lag = [0,0,0,0,0,0,0,0,0,0]

var nuvarande_lag = -1

var antal_lag = 11

func create_server(PORT):
	# Start as server.
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer
	nuvarande_lag = 1
	print("Server created at port: ",PORT, ", peer id: ",peer.get_unique_id())
	new_player_conected(1)
	start_game()

func create_client(PORT, ip):
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
	
	await get_tree().create_timer(1).timeout
	rpc("new_player_conected",peer.get_unique_id())
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
		synca_lag(lag)
		rpc("synca_lag",lag)
@rpc
func synca_lag(Lag):
	lag = Lag
	for i in range(len(Lag)):
		if Lag[i] == multiplayer.get_unique_id():
			nuvarande_lag = i
			print("Set the team of peer id: ",multiplayer.get_unique_id()," to: ",nuvarande_lag)
			break

func start_game():
	pass
