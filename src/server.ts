import http from 'http';
import routeHandler from './router';

const PORT = process.env.PORT || 8080;

function requestListener(req: http.IncomingMessage, res: http.ServerResponse): void {
    const url = new URL(req.url, `http://${req.headers.host}`);
    routeHandler(url, req, res);
}

const server = http.createServer(requestListener);
server.listen(PORT, () => {
    console.log(`> Listening on port ${PORT}`)
});