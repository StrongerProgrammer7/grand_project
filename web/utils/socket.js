// @ts-nocheck
const socketIo = require('socket.io');
const logger = require('../logger/logger');
const https = require('https');
const db = require("../models/db");
const jwt = require("jsonwebtoken");

let connectedUsers = 0;

const send_message = (clients, socketId, send, messageJson, error = null) =>
{

    let client = null;
    const sender = clients[socketId];
    for (const clientId in clients)
        if (clientId !== socketId)
            if (send.name === clients[clientId].name && send.id === clients[clientId].id)
            {
                client = clients[clientId];
                break;
            }
    if (client !== null)
        client.socket.emit('message', messageJson);
    if (error != null)
    {
        sender.socket.emit('message', messageJson);
    } else
    {
        const message = JSON.stringify({ "msg": "Success send" });
        sender.socket.emit('message', message);
    }
}

const isExistsClient = (clients, socketId, send) =>
{
    for (const clientId in clients)
        if (clientId !== socketId && send.name === clients[clientId].name && send.id === clients[clientId].id)
            return true;
    return false;
}

const sendDataToDB = (options, msg) =>
{
    return new Promise((resolve, reject) =>
    {
        let data = '';
        const req = https.request(options, (res) =>
        {
            res.on('data', (chunk) =>
            {
                data += chunk;
            });
            res.on('end', () =>
            {
                // console.log(data);
                resolve(data);
            });
            res.on('error', (error) =>
            {
                resolve(error);
                console.error('Error in response:', error);
            });
        });

        req.on('error', (error) =>
        {
            console.log(error);
            reject(error);
        });

        if (msg)
            req.write(JSON.stringify(msg));
        req.end();
    });

}

const isExistsAccess = async (decoded) =>
{
    const result = await db.query(`Select id,password FROM worker WHERE login = $1`, [decoded.login]);
    if (result.rows.length > 0)
        return true;
    else
        return false;
}


const connectSoket = (httpsServer) =>
{
    const io = socketIo(httpsServer, { secure: true });
    const clients = {};


    io.on('connection', async (socket) =>
    {
        logger.info(`User ${ socket.id } connected`);
        const token = socket.handshake.auth.token;
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        // console.log(token);
        // разбор токена
        // Если ок
        const isAccess = await isExistsAccess(decoded);
        if (isAccess === false)
        {
            const messageJson = JSON.stringify({ "message": "You are not have access" });
            socket.emit('message', messageJson);
            socket.disconnect(true);
            return;
        }
        if (connectedUsers >= 10)
        {
            const messageJson = JSON.stringify({ "message": "Go away!" });
            socket.emit('message', messageJson);
            socket.disconnect(true);
            return;
        }

        connectedUsers++;
        clients[socket.id] = {
            "name": socket.handshake.auth.name,
            "id": socket.handshake.auth.id,
            socket
        };
        //console.log(clients[socket.id])
        // Обработчик события 'message' от клиента
        socket.on('message', async (msg) =>
        {
            logger.info('Message from client:', msg);
            if (!msg.send)
                return;


            const options = {
                hostname: process.env.HOST,
                port: process.env.PORT,
                path: msg.path,
                method: msg.method,
                rejectUnauthorized: false,
                headers: {
                    'Content-Type': 'application/json',
                    'Content-Length': JSON.stringify(msg).length
                }
            };
            //console.log(msg);
            if (isExistsClient(clients, socket.id, msg.send) === false)
            {
                const messageJson = JSON.stringify({ "message": "Incorrect data, getter not exists!" });
                clients[socket.id].socket.emit('message', messageJson);
                return;
            }
            sendDataToDB(options, msg)
                .then((data) =>
                {
                    console.log("RES", data, typeof data);
                    return JSON.parse(data);
                })
                .then((data) =>
                {
                    if (data.status === 201)
                    {
                        const send = msg.send;
                        send_message(clients, socket.id, send, msg);

                    }

                })
                .catch(error =>
                {
                    console.error('Error:', error);
                    const messageJson = JSON.stringify({ msg: "Internal error", error: error });
                    send_message(clients, socket.id, msg.send, messageJson, error)
                });


        });

        socket.on('disconnect', () =>
        {
            console.log('user disconnected');
            delete clients[socket.id];
        });
    });
}

module.exports = connectSoket;