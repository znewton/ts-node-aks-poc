import http from 'http';
import routeHandler from './router';

function requestListener(req: http.IncomingMessage, res: http.ServerResponse): void {
    const url = new URL(req.url, `http://${req.headers.host}`);
    routeHandler(url, req, res);
}

const server = http.createServer(requestListener);
server.listen(8080);