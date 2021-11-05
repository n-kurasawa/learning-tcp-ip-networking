#!/user/bin/env python3

import socket


def send_msg(sock, msg):
    """ソケットに指定したバイト列を書き込む関数"""
    total_sent_len = 0
    total_msg_len = len(msg)
    while total_sent_len < total_msg_len:
        sent_len = sock.send(msg[total_sent_len:])
        if sent_len == 0:
            raise RuntimeError("socket connection bloken")
        total_sent_len += sent_len


def recv_msg(sock, chunk_len=1024):
    """ソケットから接続が終わるまでバイト列を書き込むジェネレータ関数"""
    while True:
        received_chunk = sock.recv(chunk_len)
        if len(received_chunk) == 0:
            break
        yield received_chunk


def main():
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, True)
    server_socket.bind(("127.0.0.1", 54321))
    server_socket.listen()
    print("starting server ...")

    client_socket, (cleint_address, client_prot) = server_socket.accept()

    print(f"accepted from {cleint_address}:{client_prot}")

    for received_msg in recv_msg(client_socket):
        send_msg(client_socket, received_msg)
        print(f"echo: {received_msg}")

    client_socket.close()
    server_socket.close()


if __name__ == "__main__":
    main()
