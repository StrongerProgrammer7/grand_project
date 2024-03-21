#!/usr/bin/env python3

import http.server
import socketserver

# Эта переменная нужна для обработки запросов клиента к серверу.
handler = http.server.SimpleHTTPRequestHandler

# Тут мы указываем, что сервер мы хотим запустить на порте 1234.
with socketserver.TCPServer(("", 1234), handler) as httpd:
    # Благодаря этой команде сервер будет выполняться постоянно, ожидая запросов от клиента.
    httpd.serve_forever()
