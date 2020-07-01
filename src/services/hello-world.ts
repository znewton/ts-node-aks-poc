import http from 'http';

function helloWorldService(req: http.IncomingMessage, res: http.ServerResponse): void {
    res.writeHead(200);
    res.end('Hello, World!');
}

export default helloWorldService;