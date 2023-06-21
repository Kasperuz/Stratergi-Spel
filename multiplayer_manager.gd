extends Node

var multiplayer_peer = ENetMultiplayerPeer.new()


const port = 9999
const address = "localhost"

var conected_peer_ids = []


func createClient():
	multiplayer_peer.create_client(address,port)
	multiplayer.multiplayer_peer = multiplayer_peer
	conected_peer_ids.append(multiplayer_peer.get_unique_id())
	
func createServer():
	multiplayer_peer.create_server(port)
	multiplayer.multiplayer_peer = multiplayer_peer
	conected_peer_ids.append(1)
	
#	multiplayer_peer.peer_connected.connect(
#		func(new_peer_id):
#			add_player_character(new_peer_id))
