#!/user/bin/env python3

import socket
import struct


def send_msg(sock, msg):
    """ソケットに指定したバイト列を書き込む関数"""
    total_sent_len = 0
    total_msg_len = len(msg)
    while total_sent_len < total_msg_len:
        sent_len = sock.send(msg[total_sent_len:])
        if sent_len == 0:
            raise RuntimeError("socket connection bloken")
        total_sent_len += sent_len


def recv_msg(sock, total_msg_size):
    """ソケットから接続が終わるまでバイト列を書き込むジェネレータ関数"""
    total_recv_size = 0
    while total_recv_size < total_msg_size:
        received_chunk = sock.recv(total_msg_size - total_recv_size)
        if len(received_chunk) == 0:
            break
        yield received_chunk
        total_recv_size += len(received_chunk)


def main():
    client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    client_socket.connect(("127.0.0.1", 54321))

    operand1, operand2 = 1000, 2000
    print(f"operand1: {operand1}, operand2: {operand2}")

    request_msg = struct.pack("!ii", operand1, operand2)
    send_msg(client_socket, request_msg)
    print(f"send: {request_msg}")

    received_msg = b"".join(recv_msg(client_socket, 8))
    print(f"received: {received_msg}")

    (added_value,) = struct.unpack("!q", received_msg)
    print(f"result: {added_value}")

    client_socket.close()


if __name__ == "__main__":
    main()
